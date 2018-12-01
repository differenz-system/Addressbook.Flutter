import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final barColor = const Color(0xFF238080);
final bgColor = const Color(0xFFEEEEEE);
final greenThemeColor = const Color(0xFF238080);

final String user_map = 'user_map';
final String user_fb_logged_in = 'user_fb_logged_in';

final String app_name = 'AddressBook';
final String save = 'Save';
final String login = 'Login';
final String log_in = 'Log In';
final String or = 'OR';
final String login_with_facebook = 'Login with Facebook';
final String details = 'Details';
final String cancel = 'Cancel';
final String delete = 'Delete';
final String update = 'Update';
final String validation_enter_no = 'Contact Number must be of 10 digit';
final String contact_no = 'Contact Number';
final String validation_email = 'Please enter email';
final String email = 'Email';
final String validation_name = 'Please enter name';
final String name = 'Name';
final String invalid_email = 'Invalid Email';
final String password = 'Password';
final String data_saved_succesfully = 'Data saved successfully';
final String data_updated_succesfully = 'Data Updated successfully';
final String data_deleted_succesfully = 'Data Deleted successfully';
final String min_length_password = 'Password must be minimum of 6 characters';

final String base_url = 'https://postman-echo.com/post';

/**
 * this method is to check email validation
 * paramater value is passed as email
 */
bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return false;
  else
    return true;
}
/**
 * this method is to show short toast message
 * paramater toast_msg is passed to display
 */
void showShortToast(String toast_msg) {
  Fluttertoast.showToast(
    msg: toast_msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIos: 1,
  );
}

/**
 * this method is to show long toast message
 * paramater toast_msg is passed to display
 */
void showLongToast(String toast_msg) {

  Fluttertoast.showToast(
    msg: toast_msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIos: 2,
  );

}
