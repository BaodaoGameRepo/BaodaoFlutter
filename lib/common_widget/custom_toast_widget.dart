import 'package:flutter/material.dart';
import 'package:gobang/common_widget/screen_sp.dart';

class CustomToastWidget extends StatelessWidget {
  const CustomToastWidget({
    Key? key,
    required this.msg,
    required this.alignment,
  }) : super(key: key);

  ///toast msg
  final String msg;

  ///toast location
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        minimum: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).padding.bottom + 28),
        child: Align(
          alignment: alignment,
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 50).csp,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8).csp,
            decoration: BoxDecoration(
              color: const Color(0xCC000000),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(msg, style: const TextStyle(color: Colors.white)),
          ),
        ));
  }
}
