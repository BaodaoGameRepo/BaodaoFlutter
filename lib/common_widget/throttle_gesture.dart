import 'dart:async';

import 'package:flutter/widgets.dart';

class ThrottleGesture extends StatefulWidget {
  final Duration duration;

  final Widget child;

  final VoidCallback? callback;

  final HitTestBehavior? behavior;

  const ThrottleGesture(
      {Key? key,
      required this.child,
      this.duration = const Duration(milliseconds: 300),
      this.behavior,
      this.callback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ThrottleGestureState();
}

class ThrottleGestureState extends State<ThrottleGesture> {
  bool enable = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: behavior,
      onTap: () {
        if (enable && callback != null) {
          enable = false;
          callback!();
          Future.delayed(duration, () {
            enable = true;
          });
        }
      },
      child: widget.child,
    );
  }

  VoidCallback? get callback => widget.callback;

  Duration get duration => widget.duration;

  HitTestBehavior? get behavior => widget.behavior;
}
