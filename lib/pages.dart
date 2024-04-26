import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gobang/router/router_page.dart';
import 'package:gobang/router/router_page_wrap.dart';
import 'package:gobang/entry/pages.dart' as entry;

//routers of application
final List<RoutePageWrap<dynamic>> pages = [
  ...entry.pages,
];

final _pagesMap = <String, RoutePageWrap?>{};

Route<dynamic>? buildPage(RouteSettings settings) {
  RoutePageWrap<dynamic>? page = _pagesMap.putIfAbsent(settings.name!, () {
    return pages.firstWhereOrNull((page) {
      return settings.name == page.name;
    });
  });
  return page?.buildRoute(settings); // null is unknown
}

Route<dynamic> buildUnknownPage(RouteSettings settings) {
  return OriginPageRoute(
    settings: settings,
    disableTransitions: true,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Warning!')),
        body: Container(
          alignment: Alignment.center,
          child: Text(
              'Sorry! Unsupported the feature (${settings.name}) on current version.'
              ' You can upgrade APP to the latest version and retry.'),
        ),
      );
    },
  );
}
