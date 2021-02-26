import 'dart:async';
import 'package:addressbook_flutter/src/customWidgets/MyButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:addressbook_flutter/src/utils/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:addressbook_flutter/src/model/UserModel.dart';
import 'dart:convert';
import 'package:addressbook_flutter/src/model/LoginResponseModel.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String _connectionStatus;
  final Connectivity _connectivity = Connectivity();

  //For subscription to the ConnectivityResult stream
  StreamSubscription<ConnectivityResult> _connectionSubscription;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  bool isLoggedIn = false;
  var profileData;

  var facebookLogin = FacebookLogin();

  String _email;
  String _password;

  Future<UserModel> userModel;

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;

      // get the email from facebook login profile
      if (isLoggedIn) {
        navigateHomePage(profileData['email'], true);
      }
    });
  }

  /*
  ConnectivityResult is an enum with the values as { wifi, mobile, none }.
  */
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initConnectivity(); before calling on button press
    _connectionSubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus = result.toString();
      });
    });
    print("Initstate : $_connectionStatus");
  }

  // initialize the facebook login
  void initiateFacebookLogin() async {
    var facebookLoginResult = await facebookLogin.logIn(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        globals.showShortToast(FacebookLoginStatus.error.toString());

        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=$facebookLoginResult.accessToken.token}');

        var profile = json.decode(graphResponse.body);
        print(profile.toString());

        onLoginStatusChanged(true, profileData: profile);
        break;
    }
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }

  // check internet connection and then perform login operation
  Future<Null> initConnectivity(bool isFbLogin) async {
    String connectionStatus;

    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on Exception catch (e) {
      print(e.toString());
      connectionStatus = "Internet connectivity failed";
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = connectionStatus;
    });
    print("InitConnectivity : $_connectionStatus");
    if (_connectionStatus == "ConnectivityResult.mobile" ||
        _connectionStatus == "ConnectivityResult.wifi") {
      if (isFbLogin) {
        initiateFacebookLogin();
      } else {
        // call signin method
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 4),
            content: Row(
              children: <Widget>[
                CircularProgressIndicator(),
                Text("  Signing-In...")
              ],
            ),
          ),
        );
        fetchPost(emailController.text, passwordController.text)
            .whenComplete(() => navigateHomePage(emailController.text, false));
      }
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Row(
          children: <Widget>[Text("  No Internet Connection")],
        ),
      ));
    }
  }

  /*
     * this method call on login button click
     */
  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      initConnectivity(false);
    }
  }

  /*
     * save login details in shared prefrences
     * Paramaters email = login email
     * Parameters isFbLogin = passed true if it is facebook login
     */
  _saveUser(String email, bool isFbLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString(globals.user_map, email);
      prefs.setBool(globals.user_fb_logged_in, isFbLogin);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: globals.bgColor,
      appBar: AppBar(
        backgroundColor: globals.barColor,
        centerTitle: true,
        title: Text(globals.login),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 60.0, 50.0, 0.0),
          child: Form(
              key: formKey,
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: emailController,
                            focusNode: _emailFocus,
                            onFieldSubmitted: (term) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocus);
                            },
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration:
                                InputDecoration(labelText: globals.email),
                            validator: (val) => !globals.validateEmail(val)
                                ? globals.invalid_email
                                : null,
                            onSaved: (val) => _email = val,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                          ),
                          TextFormField(
                            focusNode: _passwordFocus,
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            decoration:
                                InputDecoration(labelText: globals.password),
                            validator: (val) => val.length < 6
                                ? globals.min_length_password
                                : null,
                            onSaved: (val) => _password = val,
                            obscureText: true,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 75.0, 0.0, 0.0),
                          ),
                          SizedBox(
                            width: double.infinity,
                            // height: double.infinity,
                            child: MyButton(
                              titleText: globals.log_in,
                              onPressed: () {
                                _submit();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                          ),
                          Text(globals.or,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black)),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                          ),
                          SizedBox(
                            width: double.infinity,
                            // height: double.infinity,
                            child: MyButton(
                              titleText: globals.login_with_facebook,
                              onPressed: () {
                                initConnectivity(true);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  /*
     * navigate to home page
     * Paramaters email = login email
     * Parameters isFbLogin = passed true if it is facebook login
     */
  void navigateHomePage(String email, bool isFbLogin) {
    _saveUser(email, isFbLogin);
    Navigator.of(context).pushReplacementNamed('/Home');
  }

  /*
     * dummy api call for login
     */
  Future<UserModel> fetchPost(String str_email, String str_password) async {
    final response = await http.post(globals.base_url,
        body: {"email": str_email, "password": str_password});

    if (response.statusCode == 200) {

      // If the call to the server was successful, parse the JSON

      print("Response body: $response.body");

      var loginResponseModel =
          LoginResponseModel.fromJson(jsonDecode(response.body));

      String str_json = loginResponseModel.json.toString();
      print("str_json : $str_json");

      Map<String, dynamic> user = loginResponseModel.json;

      String email = user['email'];

      print("Response body: $email");

      return null;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
