import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:addressbook_flutter/src/login/SplashScreen.dart';
import 'package:addressbook_flutter/src/login/Login.dart';
import 'package:addressbook_flutter/src/home/HomeScreen.dart';
import 'package:addressbook_flutter/src/home/UpdateScreen.dart';
import 'package:addressbook_flutter/src/utils/globals.dart' as globals;

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MaterialApp(
      theme: new ThemeData(
        primaryColor: globals.greenThemeColor,
      ),
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/Splash': (BuildContext context) => new SplashScreen(),
        '/Login': (BuildContext context) => new Login(),
        '/Home': (BuildContext context) => new HomeScreen(),
        '/Update': (BuildContext context) => new UpdateScreen(
              addressbooks: null,
            ),
      },
    ));
  });
}
