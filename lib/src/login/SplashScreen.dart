import 'package:flutter/material.dart';
import 'dart:async';
import 'package:addressbook_flutter/src/utils/globals.dart' as globals;

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashScreen> {
  String user_email = '';

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_email = (prefs.getString(globals.user_map) ?? '');

      startTime();
    });
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(
        _duration,
        (user_email == null || user_email.isEmpty)
            ? navigationLoginPage
            : navigationHomePage);
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Center(
        child: Text(
          'AddressBook',
          textAlign: TextAlign.center,
          style: new TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /*
     * navigate to login page
     */
  void navigationLoginPage() {
    Navigator.of(context).pushReplacementNamed('/Login');
  }

  /*
     * navigate to home page
     */
  void navigationHomePage() {
    Navigator.of(context).pushReplacementNamed('/Home');
  }
}
