import 'package:flutter/widgets.dart';

//This class is created for adding all icons used in app in one place
class MyIcons {
  MyIcons._();
  static const _kFontFam = 'MyIcons';

  static const IconData deleteForever = IconData(0xe800, fontFamily: _kFontFam);
  static const IconData delete = IconData(0xe801, fontFamily: _kFontFam);
  static const IconData deleteSweep = IconData(0xe802, fontFamily: _kFontFam);
  static const IconData trash = IconData(
    0xe803,
    fontFamily: _kFontFam,
  );
}
