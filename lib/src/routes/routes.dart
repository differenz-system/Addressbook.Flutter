import 'package:addressbook_flutter/src/modules/home/home_bindings.dart';
import 'package:addressbook_flutter/src/modules/home/home_screen.dart';
import 'package:addressbook_flutter/src/modules/login/login_bindings.dart';
import 'package:addressbook_flutter/src/modules/login/login_screen.dart';
import 'package:addressbook_flutter/src/modules/splash/splash_bindings.dart';
import 'package:addressbook_flutter/src/modules/splash/splash_screen.dart';
import 'package:addressbook_flutter/src/modules/update/update_bindings.dart';
import 'package:addressbook_flutter/src/modules/update/update_screen.dart';
import 'package:get/get.dart';

//This are the routes(means screens) used in our app
//bindings are used for providing the controller to that specific route
class Routes {
  static final appRoutes = [
    GetPage(
      name: SplashScreen.routeName,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: LoginPage.routeName,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: HomeScreen.routeName,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: UpdateScreen.routeName,
      page: () => const UpdateScreen(),
      binding: UpdateBinding(),
    ),
  ];
}
