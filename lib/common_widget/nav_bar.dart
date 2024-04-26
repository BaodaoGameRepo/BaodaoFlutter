// Copyright (c) 2019 Bilibili Inc. All rights reserved.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gobang/common_widget/screen_sp.dart';

import 'back_top_scope.dart';


/// TopBar instead of AppBar
class NavBar extends StatelessWidget {
  final String title;
  final double titleSize;
  final FontWeight titleWeight;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final double /*!*/ height;
  final List<Widget> actions;
  final Widget? bottom;
  final double bottomLineHeight;
  final Color bottomLineColor;
  final Color titleColor;
  final WidgetBuilder? leadIconBuilder;
  final WidgetBuilder? middleBuilder;
  final bool centerMiddle;
  final bool isAlert;
  final Color? leadIconColor;

  const NavBar({
    Key? key,
    this.title = "",
    this.titleColor = Colors.black,
    this.titleSize = 18,
    this.titleWeight = FontWeight.w600,
    this.onPressed,
    this.height = 44,
    this.actions = const [],
    this.bottom,
    this.bottomLineHeight = 0.0,
    this.leadIconBuilder,
    this.backgroundColor = Colors.white,
    this.bottomLineColor = Colors.white,
    this.middleBuilder,
    this.centerMiddle = true,
    this.isAlert = false,
    this.leadIconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double navHeight = height;
    if (Platform.isAndroid || isAlert) {
      navHeight += 12;
    }
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: navHeight + statusBarHeight,
            child: Container(
              margin: EdgeInsets.only(top: statusBarHeight),
              height: navHeight,
              child: NavigationToolbar(
                centerMiddle: centerMiddle,
                // middleSpacing: ,
                leading: onPressed != null ? IconButton(onPressed: onPressed, iconSize: 44, splashColor: Colors.transparent, highlightColor: Colors.transparent, icon: leadIconBuilder != null ? leadIconBuilder!(context) : Image.asset('images/png/label_left.png', width: 20.csp, height: 20.csp,)) : null,
                middle: middleBuilder != null
                    ? middleBuilder!(context)
                    : GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          BackTopScope.backToTop(context);
                        },
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: titleColor, fontWeight: titleWeight, fontSize: titleSize.csp),
                        )),
                trailing: buildActionsView(),
              ),
            ),
          ),
          if (bottom != null) bottom!,
          if (bottomLineHeight > 0) Container(height: bottomLineHeight, color: bottomLineColor)
        ],
      ),
    );
  }

  Widget buildActionsView() {
    if (actions.isNotEmpty == true) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: actions,
      );
    }
    return const SizedBox(width: 44);
  }
}

Widget redPoint(String text, {Color? color}) {
  double size = 14.csp;
  Widget redWidget = Container(
    alignment: Alignment.center,
    constraints: BoxConstraints(maxHeight: size, minHeight: size, minWidth: size),
    padding: const EdgeInsets.only(left: 3.2, right: 3.2, top: 0.5).csp,
    child: Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 12.csp),
      // strutStyle: StrutStyle(forceStrutHeight: true),
    ),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8.csp),
    ),
  );
  return redWidget;
}
