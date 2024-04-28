import 'package:flutter/cupertino.dart';

import 'constants/mj_colors.dart';
import 'constants/mj_font_weights.dart';
import 'mj_text_style.dart';
import 'multiple_click_gesture_detect.dart';


class MJTextShadowContainer extends StatelessWidget {
  final Color shadowColor;
  final Color boxColor;
  final double width;
  final double height;
  final String text;
  final Color textColor;
  final String fontWeight;
  final double fontSize;
  final VoidCallback onTap;
  final double borderRadius;

  const MJTextShadowContainer(
      {Key? key,
      this.shadowColor = MJColors.deepGreen,
      this.boxColor = MJColors.defaultGreen,
      required this.width,
      required this.height,
      required this.text,
      this.textColor = MJColors.white,
      this.fontWeight = MJFontWeights.bold,
      this.fontSize = 17,
      this.borderRadius = 16,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultipleClickGestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Container(
        decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [BoxShadow(offset: Offset(0, 4), color: shadowColor)]),
        width: width,
        height: height,
        child: Center(
          child: Text(
            text,
            style: MJTextStyle.textStyle(
                color: textColor, fontWeight: fontWeight, fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}
