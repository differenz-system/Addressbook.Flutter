import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './src/utils/globals.dart' as globals;
import './src/login/SplashScreen.dart';
import './src/login/Login.dart';
import './src/home/HomeScreen.dart';
import './src/home/UpdateScreen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp( MaterialApp(
      theme:  ThemeData(
        primaryColor: globals.greenThemeColor,
      ),
      debugShowCheckedModeBanner: false,
      home:  SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/Splash': (BuildContext context) =>  SplashScreen(),
        '/Login': (BuildContext context) =>  Login(),
        '/Home': (BuildContext context) =>  HomeScreen(),
        '/Update': (BuildContext context) =>  UpdateScreen(
          addressbooks: null,
        ),
      },
    ));
  });
}