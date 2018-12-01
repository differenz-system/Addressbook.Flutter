import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:addressbook_flutter/src/utils/globals.dart' as globals;
import 'package:addressbook_flutter/src/database/DBHelper.dart';
import 'package:addressbook_flutter/src/model/AddressBook.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class UpdateScreen extends StatefulWidget {
  final AddressBook addressbooks;

  /*
  * addressbooks is get from intent from previous screen
   */
  UpdateScreen({Key key, @required this.addressbooks}) : super(key: key);

  @override
  _UpdatePageState createState() => new _UpdatePageState(addressbooks);
}

class _UpdatePageState extends State<UpdateScreen> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _contactFocus = FocusNode();

  String _name;
  String _email;
  String _contact_number;
  AddressBook addressbooksData;

  var facebookLogin = FacebookLogin();

  bool _value1 = false;

  void _onChangedIsActive(bool value) => setState(() => _value1 = value);

  _UpdatePageState(AddressBook addressbooks) {
    this.addressbooksData = addressbooks;
    this._value1 = true
        ? (addressbooksData != null &&
            addressbooksData.isactive != null &&
            addressbooksData.isactive == 1)
        : false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void facebookLogout() async {}

  void _submit() {
    final form = formKey.currentState;

    /*
     * validate al filelds
     */
    if (form.validate()) {
      form.save();

      // save data in sqlite
      var addressbooks = AddressBook(0, '${_name}', '${_email}',
          '${_contact_number}', (_value1 == true) ? 1 : 0);
      var dbHelper = DBHelper();
      dbHelper.saveAddressBook(addressbooks);

      globals.showShortToast(globals.data_saved_succesfully);

      Navigator.of(context).pop();
    }
  }

  // intent back to previous screen
  void _cancelScreen() {
    Navigator.of(context).pop();
  }

  /*
     * delete the data from sqlite
     */
  void _deleteScreen() {
    var dbHelper = DBHelper();
    dbHelper.deleteAddressBook(addressbooksData.id);

    globals.showShortToast(globals.data_deleted_succesfully);

    Navigator.of(context).pop();
  }

  /*
     * update the data in sqlite
     */
  void _submitUpdate() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      var addressbooks = AddressBook(addressbooksData.id, '${_name}',
          '${_email}', '${_contact_number}', (_value1 == true) ? 1 : 0);
      var dbHelper = DBHelper();
      dbHelper.updateAddressBook(addressbooks, addressbooksData.id);

      globals.showShortToast(globals.data_updated_succesfully);

      Navigator.of(context).pop();
    }
  }

  /*
     * async call for logout from facebook and app
     */
  _clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(globals.user_fb_logged_in)) {
      prefs.setBool(globals.user_fb_logged_in, false);
      await facebookLogin.logOut();
    }

    setState(() {
      prefs.setString(globals.user_map, "");
      Navigator.of(context).pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false) ;
    });



  }

  /*
     * logout method
     */
  void _logout() {
    setState(() {
      _clearUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: globals.bgColor,
      appBar: AppBar(
        backgroundColor: globals.barColor,
        title: new Text(globals.details),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.settings_power), onPressed: _logout),
        ],
      ),
      body: new SingleChildScrollView(
        child: new Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 0.0),
          child: new Form(
              key: formKey,
              child: new Column(
                children: <Widget>[
                  new TextFormField(
                    initialValue:
                        addressbooksData != null ? addressbooksData.name : '',
                    textInputAction: TextInputAction.next,
                    focusNode: _nameFocus,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(_emailFocus);
                    },
                    decoration: new InputDecoration(labelText: globals.name),
                    validator: (val) =>
                        val.isEmpty ? globals.validation_name : null,
                    onSaved: (val) => _name = val,
                  ),
                  new Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0)),
                  new TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    initialValue:
                        addressbooksData != null ? addressbooksData.email : '',
                    focusNode: _emailFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(_contactFocus);
                    },
                    decoration: new InputDecoration(labelText: globals.email),
                    validator: (val) => (!globals.validateEmail(val))
                        ? globals.invalid_email
                        : null,
                    onSaved: (val) => _email = val,
                  ),
                  new Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0)),
                  new TextFormField(
                    initialValue: addressbooksData != null
                        ? addressbooksData.contact_number.toString()
                        : '',
                    focusNode: _contactFocus,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    decoration:
                        new InputDecoration(labelText: globals.contact_no),
                    validator: (val) =>
                        val.length != 10 ? globals.validation_enter_no : null,
                    onSaved: (val) => _contact_number = val,
                  ),
                  new Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0)),
                  new Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: new Switch(
                          activeColor: globals.greenThemeColor,
                          value: _value1,
                          onChanged: _onChangedIsActive,
                        ),
                      )
                    ],
                  ),
                  new Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0)),
                  new SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: new RaisedButton(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                        child: new Text(
                          addressbooksData != null
                              ? globals.update
                              : globals.save,
                          style: new TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        color: globals.greenThemeColor,
                        onPressed: () {
                          addressbooksData != null
                              ? _submitUpdate()
                              : _submit();
                        }),
                  ),
                  new Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                  new SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: new RaisedButton(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                        child: new Text(
                          addressbooksData != null
                              ? globals.delete
                              : globals.cancel,
                          style: new TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        color: globals.greenThemeColor,
                        onPressed: () {
                          addressbooksData != null
                              ? _deleteScreen()
                              : _cancelScreen();
                        }),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
