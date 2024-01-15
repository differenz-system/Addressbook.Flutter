import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const barColor = Color(0xFF238080);
const bgColor = Color(0xFFEEEEEE);
const greenThemeColor = Color(0xFF238080);

const String user_map = 'user_map';

const String app_name = 'AddressBook';
const String save = 'Save';
const String login = 'Login';
const String log_in = 'Log In';
const String or = 'OR';
const String login_with_facebook = 'Login with Facebook';
const String details = 'Details';
const String cancel = 'Cancel';
const String delete = 'Delete';
const String update = 'Update';
const String validation_enter_no = 'Contact Number must be of 10 digit';
const String contact_no = 'Contact Number';
const String validation_email = 'Please enter email';
const String email = 'Email';
const String validation_name = 'Please enter name';
const String name = 'Name';
const String invalid_email = 'Invalid Email';
const String password = 'Password';
const String data_saved_succesfully = 'Data saved successfully';
const String data_updated_succesfully = 'Data Updated successfully';
const String data_deleted_succesfully = 'Data Deleted successfully';
const String min_length_password = 'Password must be minimum of 6 characters';

const String base_url = 'https://postman-echo.com/post';

/*
 * this method is to check email validation
 * paramater value is passed as email
 */
bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern as String);
  if (!regex.hasMatch(value))
    return false;
  else
    return true;
}

/*
 * this method is to show short toast message
 * paramater toast_msg is passed to display
 */
void showShortToast(String toast_msg) {
  Fluttertoast.showToast(
    msg: toast_msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
  );
}

//This method is used for showing toast
void showLongToast(String toast_msg) {
  Fluttertoast.showToast(
    msg: toast_msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 2,
  );
}
