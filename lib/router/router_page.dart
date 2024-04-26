import 'package:flutter/material.dart';
import 'package:gobang/router/router_setting.dart';

/// copy from [PageRouteBuilder]
class OriginPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  final bool disableTransitions;

  final Map<TargetPlatform, PageTransitionsBuilder>? transitionBuilders;

  OriginPageRoute(
      {required RouteSettings settings,
      required this.builder,
      this.maintainState = true,
      this.disableTransitions = true,
      this.transitionDuration = const Duration(milliseconds: 350),
      this.transitionBuilders,
      bool fullscreenDialog = false})
      : super(settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  final bool maintainState;

  @override
  bool get opaque => true;

  @override
  final Duration transitionDuration;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return nextRoute is PageRoute && !nextRoute.fullscreenDialog;
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (transitionBuilders != null) {
      return PageTransitionsTheme(builders: transitionBuilders!)
          .buildTransitions(
              this, context, animation, secondaryAnimation, child);
    }
    if (!disableTransitions) {
      return Theme.of(context).pageTransitionsTheme.buildTransitions(
          this, context, animation, secondaryAnimation, child);
    }
    return child;
  }

  // workaround wrong state, check isActive first
  @override
  bool get isCurrent => isActive && super.isCurrent;

  @override
  bool get isFirst {
    if (!isActive) return false;
    final page = settings;
    if (page is OriginPageSettings) return page.isInitialPage;
    return super.isFirst;
  }

  @override
  String toString() {
    return '$runtimeType-${settings.name}';
  }
}
