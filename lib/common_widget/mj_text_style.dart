import 'package:flutter/material.dart';

import 'constants/mj_font_weights.dart';

class MJTextStyle {
  static TextStyle? textStyle(
      {double? fontSize,
      String fontWeight = MJFontWeights.regular,
      Color? color,
      double? height,
      TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: fontWeight,
        fontSize: fontSize,
        color: color,
        height: height,
        decoration: decoration);
  }
}
