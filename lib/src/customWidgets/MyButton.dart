import 'package:flutter/material.dart';
import 'package:addressbook_flutter/src/utils/globals.dart' as globals;
class MyButton extends StatelessWidget {
  final String titleText;
  final Color textColor;
  final double cornerRadius;
  final VoidCallback onPressed;
  final Color bgColor;

  const MyButton({Key key,@required this.titleText, this.textColor, this.cornerRadius, this.onPressed, this.bgColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        padding:
        const EdgeInsets.only(top: 15,bottom: 15),
        child:  Text(
        titleText,
          style:  TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius ?? 6)),
        color: bgColor ?? globals.greenThemeColor,
        onPressed: onPressed);
  }
}
