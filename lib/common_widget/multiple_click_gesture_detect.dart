import 'package:flutter/cupertino.dart';

/*多次连点问题解决*/
class MultipleClickGestureDetector extends StatefulWidget {
  VoidCallback onTap;
  Widget child;
  Duration duration = const Duration(milliseconds: 500);

  MultipleClickGestureDetector({
    required this.onTap,
    required this.child,
    Key? key,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<MultipleClickGestureDetector> createState() =>
      _MultipleClickGestureDetectorState();
}

class _MultipleClickGestureDetectorState
    extends State<MultipleClickGestureDetector> {
  bool _isCan = true;

  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_isCan) {
          _isCan = false;
          Future.delayed(widget.duration, () {
            _isCan = true;
          });
          widget.onTap.call();
        }
      },
      child: widget.child,
    );
  }
}
