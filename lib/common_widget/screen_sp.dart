import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final double scale = min(max(ScreenUtil().scaleWidth, 1.0), 1.2);

extension CustomSp on num {
  double get csp => (this * scale).ceilToDouble();
}

extension EdgeInsetsSp on EdgeInsets {
  EdgeInsets get csp => this * scale;
}

extension SizeBoxSp on SizedBox {
  SizedBox get csp =>
      SizedBox(width: width?.csp ?? 0, height: height?.csp ?? 0);
}

extension SizeSp on Size {
  Size get csp => this * scale;
}
