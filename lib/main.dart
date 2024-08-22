import 'package:addressbook_flutter/src/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import './src/utils/globals.dart' as globals;
import 'src/modules/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //used this code to set device orientation to portratit
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    ScreenUtilInit(
      useInheritedMediaQuery: true,
      minTextAdapt: true,
      //used design size to dynamically adapt ui for different screen sizes
      designSize: const Size(360, 690),
      //get marerial app is wrapper arounf material app used for routing and context management by getx
      child: GetMaterialApp(
        theme: ThemeData(
          primaryColor: globals.greenThemeColor,
        ),
        debugShowCheckedModeBanner: false,
        //get pages are used fpr setting up the routes for the app
        getPages: Routes.appRoutes,
        //splash screen will be the intial route for the app
        initialRoute: SplashScreen.routeName,
      ),
    ),
  );
}
