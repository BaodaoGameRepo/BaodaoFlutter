import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseScaffold extends StatelessWidget {
  final WidgetBuilder builder;
  final SystemUiOverlayStyle systemUiOverlayStyle;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final Widget? bottomSheet;
  final AppBar? appBar;
  final bool disableEdit;
  final bool extendBody;
  final Widget? bottomBar;

  const BaseScaffold(
      {Key? key,
      required this.builder,
      this.systemUiOverlayStyle = SystemUiOverlayStyle.dark,
      this.backgroundColor,
      this.bottomSheet,
      this.appBar,
      this.bottomBar,
      this.disableEdit = false,
      this.extendBody = false,
      this.resizeToAvoidBottomInset = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemUiOverlayStyle,
        child: Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: this.extendBody,
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: disableEdit
                  ? () {}
                  : () {
                      // 触摸收起键盘
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
              child: Builder(
                builder: builder,
              ),
            ),
            bottomSheet: bottomSheet,
            appBar: appBar,
            bottomNavigationBar: bottomBar,
            backgroundColor: backgroundColor,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset));
  }
}
