import 'package:flutter/material.dart'
    show CupertinoPageTransitionsBuilder, PageTransitionsBuilder;
import 'package:flutter/widgets.dart';
import 'package:gobang/router/router_page.dart';
import 'package:gobang/router/router_setting.dart';

import 'router_cons.dart';

export 'package:flutter/material.dart'
    show PageTransitionsBuilder, TargetPlatform;
export 'package:flutter/widgets.dart' show RouteSettings;

typedef PageBuilder = Widget Function(
    BuildContext context, RouteSettings settings);
typedef RouteInterceptor = RouteSettings Function(RouteSettings settings);
typedef RouteBuilder<T> = Route<T> Function(RouteSettings settings);

abstract class RoutePageWrap<T> {
  /// Build a [Route] for [settings]
  /// See [PhoenixPageRoute]
  Route<T> buildRoute(RouteSettings settings);

  /// Intercept [RouteSettings]
  final RouteInterceptor? interceptor;

  /// route name
  final String name;

  const RoutePageWrap(this.name, {this.interceptor});

  @protected
  RouteSettings onIntercept(RouteSettings settings) {
    return interceptor == null ? settings : interceptor!(settings);
  }
}

/// More flexible case, custom [buildRoute]
class PageRouteBuilder<T> extends RoutePageWrap<T> {
  /// Build a [Route]
  final RouteBuilder<T> builder;
  const PageRouteBuilder(
    String name, {
    required this.builder,
    RouteInterceptor? interceptor,
  }) : super(name, interceptor: interceptor);

  @override
  Route<T> buildRoute(RouteSettings settings) {
    return builder(onIntercept(settings));
  }
}

/// General case, custom [Widget] building for [OriginPageRoute]
class OriginRoutePageBuilder<T> extends RoutePageWrap<T> {
  final PageBuilder builder;
  final Map<TargetPlatform, PageTransitionsBuilder>? transitionBuilders;
  final Duration transitionDuration;

  /// show close button instead of back button
  final bool fullscreenDialog;
  OriginRoutePageBuilder(
    String name, {
    required this.builder,
    RouteInterceptor? interceptor,
    this.fullscreenDialog = false,
    this.transitionBuilders,
    this.transitionDuration = const Duration(milliseconds: 350),
  }) : super(name, interceptor: interceptor);

  @override
  Route<T> buildRoute(RouteSettings settings) {
    var newSettings = onIntercept(settings);
    final disableTransitions =
        newSettings is OriginPageSettings && newSettings.isInitialPage ||
            newSettings.name == FlutterRouterCons.appEntry;
    return OriginPageRoute(
        settings: newSettings,
        disableTransitions: disableTransitions,
        fullscreenDialog: fullscreenDialog,
        transitionBuilders: disableTransitions
            ? null
            : transitionBuilders ??
                {
                  TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
                  TargetPlatform.android:
                      const CupertinoPageTransitionsBuilder()
                },
        transitionDuration: transitionDuration,
        builder: (context) {
          return builder(context, newSettings);
        });
  }
}
