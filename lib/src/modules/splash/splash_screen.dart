import 'package:addressbook_flutter/src/modules/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splashScreen";

  const SplashScreen({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<SplashController>().loadUser();
  }

  @override
  Widget build(BuildContext context) {
    // Will display addressbook text on the center of the screen
    return Scaffold(
      body: Center(
        child: Text(
          'AddressBook',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
