import 'package:flutter/material.dart';

class BackTopScope extends StatefulWidget {
  final Widget child;

  const BackTopScope({required this.child, Key? key}) : super(key: key);

  static void backToTop(BuildContext context) {
    final scope = context.findAncestorStateOfType<_BackTopScopeState>();
    assert(scope != null, "Forget wrap [BackTopScope]");
    scope?._scrollPrimaryController();
  }

  @override
  _BackTopScopeState createState() => _BackTopScopeState();
}

class _BackTopScopeState extends State<BackTopScope> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _scrollPrimaryController() {
    PrimaryScrollController.of(context)
        ?.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }
}
