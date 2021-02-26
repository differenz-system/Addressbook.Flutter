import 'package:addressbook_flutter/src/customWidgets/MyButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:addressbook_flutter/src/utils/globals.dart' as globals;
import 'package:addressbook_flutter/src/database/DBHelper.dart';
import 'package:addressbook_flutter/src/model/AddressBook.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:io' as IO;

class UpdateScreen extends StatefulWidget {
  final AddressBook addressbooks;

  /*
  * addressbooks is get from intent from previous screen
   */
  UpdateScreen({Key key, @required this.addressbooks}) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState(addressbooks);
}

class _UpdatePageState extends State<UpdateScreen> {
  var dbHelper = DBHelper();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

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
     * validate al fields
     */
    if (form.validate()) {
      form.save();

      // save data in sqlite
      var addressbooks = AddressBook('${_name}', '${_email}',
          '${_contact_number}', (_value1 == true) ? 1 : 0);
      var dbHelper = DBHelper();
      dbHelper.insertAddressBook(addressbooks);

      globals.showShortToast(globals.data_saved_succesfully);

      // Navigator.of(context).pop();
      Navigator.pop(context, true);
    }
  }

  // intent back to previous screen
  void _cancelScreen() {
    // Navigator.pop(context,false);
    Navigator.pop(context, true);
  }

  /*
     * delete the data from sqlite
     */
  void _deleteScreen(BuildContext context) {
    _showAlert(context, addressbooksData.id);
  }

  /*
     * update the data in sqlite
     */
  void _submitUpdate() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      var addressbooks = AddressBook.withId(addressbooksData.id, '${_name}',
          '${_email}', '${_contact_number}', (_value1 == true) ? 1 : 0);
      var dbHelper = DBHelper();
      dbHelper.updateAddressBook(addressbooks, addressbooksData.id);

      globals.showShortToast(globals.data_updated_succesfully);

      Navigator.pop(context, true);
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
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false);
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
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: globals.bgColor,
      appBar: AppBar(
        backgroundColor: globals.barColor,
        title: Text(globals.details),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings_power), onPressed: _logout),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 0.0),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue:
                        addressbooksData != null ? addressbooksData.name : '',
                    textInputAction: TextInputAction.next,
                    focusNode: _nameFocus,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(_emailFocus);
                    },
                    decoration: InputDecoration(labelText: globals.name),
                    validator: (val) =>
                        val.isEmpty ? globals.validation_name : null,
                    onSaved: (val) => _name = val,
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0)),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    initialValue:
                        addressbooksData != null ? addressbooksData.email : '',
                    focusNode: _emailFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(_contactFocus);
                    },
                    decoration: InputDecoration(labelText: globals.email),
                    validator: (val) => (!globals.validateEmail(val))
                        ? globals.invalid_email
                        : null,
                    onSaved: (val) => _email = val,
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0)),
                  TextFormField(
                    initialValue: addressbooksData != null
                        ? addressbooksData.contact_number.toString()
                        : '',
                    focusNode: _contactFocus,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: globals.contact_no),
                    validator: (val) =>
                        val.length != 10 ? globals.validation_enter_no : null,
                    onSaved: (val) => _contact_number = val,
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0)),
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Switch(
                          activeColor: globals.greenThemeColor,
                          value: _value1,
                          onChanged: _onChangedIsActive,
                        ),
                      )
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0)),
                  SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: MyButton(
                      titleText: addressbooksData != null
                          ? globals.update
                          : globals.save,
                      onPressed: () {
                        addressbooksData != null ? _submitUpdate() : _submit();
                      },
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                  SizedBox(
                      width: double.infinity,
                      // height: double.infinity,
                      child: MyButton(
                        titleText: addressbooksData != null
                            ? globals.delete
                            : globals.cancel,
                        onPressed: () {
                          addressbooksData != null
                              ? _deleteScreen(context)
                              : _cancelScreen();
                        },
                      )),
                ],
              )),
        ),
      ),
    );
  }

  void _showAlert(BuildContext context, int id) {
    showDialog(
        context: context,
        builder: (context) => (IO.Platform.isAndroid)
            ? AlertDialog(
          content: Text("Are you sure want to delete this Record",style: TextStyle(fontWeight: FontWeight.bold),),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // dismisses only the dialog and returns nothing
                    },
                    child: new Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // dismisses only the dialog and returns nothing
                    },
                    child: new Text('OK',style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ],
              )
            : CupertinoAlertDialog(
                content: Text("Are you sure want to delete this Record",style: TextStyle(fontWeight: FontWeight.bold),),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text('Cancel'),
                  ),
                  FlatButton(
                    onPressed: () {
                      dbHelper.deleteAddressBook(id);

                      // Navigator.of(context).popUntil((route) => route.isFirst);
                      // Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.of(context).pop();
                      Navigator.pop(context, true);
                    },
                    child: new Text('OK'),
                  ),
                ],
              ));
  }
}
