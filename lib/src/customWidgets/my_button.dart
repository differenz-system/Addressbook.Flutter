import 'package:flutter/material.dart';
import 'package:addressbook_flutter/src/utils/globals.dart' as globals;
import 'package:flutter_screenutil/flutter_screenutil.dart';

//This is the common button created to used in different parts of app
class MyButton extends StatelessWidget {
  final String titleText;
  final Color? textColor;
  final double? cornerRadius;
  final VoidCallback? onPressed;
  final Color? bgColor;

  const MyButton(
      {Key? key,
      required this.titleText,
      this.textColor,
      this.cornerRadius,
      this.onPressed,
      this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.resolveWith(
                (states) => EdgeInsets.only(top: 15.h, bottom: 15.h)),
            shape: MaterialStateProperty.resolveWith((states) =>
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(cornerRadius ?? 6))),
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => bgColor ?? globals.greenThemeColor)),
        onPressed: onPressed,
        child: Text(
          titleText,
          style: const TextStyle(color: Colors.white),
        ));
  }
}
