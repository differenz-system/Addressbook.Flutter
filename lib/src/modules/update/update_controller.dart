import 'package:addressbook_flutter/src/database/db_helper.dart';
import 'package:addressbook_flutter/src/model/address_book.dart';
import 'package:addressbook_flutter/src/modules/login/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' as io;
import 'package:addressbook_flutter/src/utils/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateController extends GetxController {
  var dbHelper = DBHelper();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _contactFocusNode = FocusNode();

  String? name;
  String? email;
  String? contactNumber;
  AddressBook? addressbooksData;

  bool isChecked = false;

  void onChangedIsActive(bool value) {
    isChecked = value;
    update();
  }

  setInititalData(AddressBook? addressbooks) {
    addressbooksData = addressbooks;
    if (addressbooksData != null &&
        addressbooksData!.isactive != null &&
        addressbooksData!.isactive == 1) {
      isChecked = true;
    }
    update();
  }

  //This function will show a confirmation dialog while user will try to delete entry from database
  void showAlert(BuildContext context, int? id) {
    showDialog(
        context: context,
        builder: (context) => (io.Platform.isAndroid)
            ? AlertDialog(
                content: const Text(
                  "Are you sure want to delete this Record",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // dismisses only the dialog and returns nothing
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      dbHelper.deleteAddressBook(id);
                      Navigator.of(context).pop();
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            : CupertinoAlertDialog(
                content: const Text(
                  "Are you sure want to delete this Record",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      dbHelper.deleteAddressBook(id);
                      Navigator.of(context).pop();
                      Navigator.pop(context, true);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ));
  }

  void submit() async {
    final form = formKey.currentState!;

    /*
     * validate all fields
     */
    if (form.validate()) {
      form.save();

      // save data in sqlite
      var addressbooks = AddressBook(
          '$name', '$email', '$contactNumber', (isChecked == true) ? 1 : 0);
      var dbHelper = DBHelper();
      await dbHelper.insertAddressBook(addressbooks);

      globals.showShortToast(globals.data_saved_succesfully);
      navigator?.pop(true);
    }
  }

  // intent back to previous screen
  void cancelScreen() {
    navigator?.pop(true);
  }

  /*
     * delete the data from sqlite
     */
  void deleteScreen(BuildContext context) {
    showAlert(context, addressbooksData!.id);
  }

  //This method will save the updated data in database and navigate user to the home screen
  void submitUpdate() async {
    final form = formKey.currentState!;

    if (form.validate()) {
      form.save();

      var addressbooks = AddressBook.withId(addressbooksData!.id, '$name',
          '$email', '$contactNumber', (isChecked == true) ? 1 : 0);
      var dbHelper = DBHelper();
      await dbHelper.updateAddressBook(addressbooks, addressbooksData!.id);

      globals.showShortToast(globals.data_updated_succesfully);

      navigator?.pop(true);
    }
  }

  //This method will clear all user data saved in local storage and navigate user back to login screen
  clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(globals.user_map, "");
    Get.offAllNamed(LoginPage.routeName);
  }

  void logout() {
    clearUser();
  }

  @override
  void onInit() {
    super.onInit();
    //Below code will get arguments from previous screen and update the textfeilds in the update screen according to passed data.
    Map<String, dynamic>? args = Get.arguments as Map<String, dynamic>;
    setInititalData(args['addressbooks']);
  }

  FocusNode get nameFocusNode => _nameFocusNode;
  FocusNode get emailFocusNode => _emailFocusNode;
  FocusNode get contactFocusNode => _contactFocusNode;
}
