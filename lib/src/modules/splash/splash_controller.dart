import 'dart:async';

import 'package:addressbook_flutter/src/modules/home/home_screen.dart';
import 'package:addressbook_flutter/src/modules/login/login_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:addressbook_flutter/src/utils/globals.dart' as globals;

class SplashController extends GetxController {
  String userEmail = '';

  loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = (prefs.getString(globals.user_map) ?? '');
    startTime();
  }

  // This function will wait for 1 seconds and after that it will navigate user to appropriate screen based on user data saved in local storage or not
  startTime() async {
    var duration = const Duration(seconds: 1);
    return Timer(duration,
        (userEmail.isEmpty) ? navigationLoginPage : navigationHomePage);
  }

  /*
     * navigate to login page
     */
  void navigationLoginPage() {
    Get.offNamed(LoginPage.routeName);
  }

  /*
     * navigate to home page
     */
  void navigationHomePage() {
    Get.offNamed(HomeScreen.routeName);
  }
}
