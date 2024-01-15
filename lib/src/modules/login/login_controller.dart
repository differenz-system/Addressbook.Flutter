import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:addressbook_flutter/src/model/login_response_model.dart';
import 'package:addressbook_flutter/src/model/user_model.dart';
import 'package:addressbook_flutter/src/modules/home/home_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:addressbook_flutter/src/utils/globals.dart' as globals;
import 'package:http/http.dart' as http;

//Login controller is craeted for handling logic part of login screen
class LoginController extends GetxController {
  //For the email and password text editing feilds
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _connectionStatus;
  final Connectivity _connectivity = Connectivity();

  //For subscription to the ConnectivityResult stream
  late StreamSubscription<ConnectivityResult> _connectionSubscription;

  //For handing focus on text feilds
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  //form key is used for validating from and saving forms
  final formKey = GlobalKey<FormState>();

  bool isLoggedIn = false;
  var profileData;

  Future<UserModel>? userModel;

  void submit() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      initConnectivity();
    }
  }

  /*
     * save login details in shared prefrences
     * Paramaters email = login email
     * Parameters isFbLogin = passed true if it is facebook login
     */
  saveUser(String? email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(globals.user_map, email!);
    update();
  }

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    this.isLoggedIn = isLoggedIn;
    this.profileData = profileData;
    if (isLoggedIn) {
      navigateHomePage(profileData['email']);
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    // initConnectivity(); before calling on button press
    _connectionSubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      update();
    });
    log("Initstate : $_connectionStatus");
  }

  @override
  void onClose() {
    super.onClose();
    //This will cancel connectivity stream subscription
    _connectionSubscription.cancel();
  }

  // check internet connection and then perform login operation
  // This function will display dummy signing in... text for 3 seconds and navigate to home screen while performing the signin request
  Future<void> initConnectivity() async {
    String connectionStatus;
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on Exception catch (e) {
      log(e.toString());
      connectionStatus = "Internet connectivity failed";
    }

    _connectionStatus = connectionStatus;
    update();
    log("InitConnectivity : $_connectionStatus");
    if (_connectionStatus == "ConnectivityResult.mobile" ||
        _connectionStatus == "ConnectivityResult.wifi") {
      // call signin method
      Get.showSnackbar(GetSnackBar(
        messageText: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              width: 15.w,
            ),
            Text(
              "Signing-In...",
            )
          ],
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.white,
      ));

      fetchPost(emailController.text, passwordController.text)
          .whenComplete(() => navigateHomePage(emailController.text));
    } else {
      Get.showSnackbar(GetSnackBar(
        messageText: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              width: 15.w,
            ),
            Text("No Internet Connection")
          ],
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.white,
      ));
    }
  }

  void navigateHomePage(
    String? email,
  ) {
    saveUser(email);
    Get.closeAllSnackbars();
    Get.offNamed(HomeScreen.routeName);
  }

  /*
     * dummy api call for login
     */
  Future<UserModel?> fetchPost(String str_email, String str_password) async {
    final response = await http.post(Uri.parse(globals.base_url),
        body: {"email": str_email, "password": str_password});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      print("Response body: $response.body");

      var loginResponseModel =
          LoginResponseModel.fromJson(jsonDecode(response.body));

      String str_json = loginResponseModel.json.toString();
      print("str_json : $str_json");

      Map<String, dynamic> user = loginResponseModel.json!;

      String? email = user['email'];

      print("Response body: $email");

      return null;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  FocusNode get emailFocusNode => _emailFocusNode;
  FocusNode get passwordFocusNode => _passwordFocusNode;
}
