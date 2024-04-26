import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gobang/router/router_cons.dart';
import 'package:gobang/utils/web_util.dart';
import 'package:logging/logging.dart';

import 'app_service.dart';

final navLog = Logger('navService.log');

final NavService navService = NavService();

class NavService {
  NavigatorState get nav {
    var navigator = app.navkey.currentState;
    if (navigator == null) throw StateError("The Navigator may be unmounted");
    // ignore: unnecessary_type_check
    assert(navigator is NavigatorState,
        "The navigator should be instance of PhoenixPageNavigator");
    return navigator;
  }

  Future<T?> openPage<T>(String name, [Map<String, dynamic>? arguments]) async {
    //todo: 后续如果schema涉及到tab则需要新增tab逻辑
    return nav.pushNamed<T>(name, arguments: arguments ?? <String, dynamic>{});
  }

  Future<T?> openPageAndReplace<T>(String name, String replaceName,
      [Map<String, dynamic>? arguments]) {
    return nav.pushNamedAndRemoveUntil(name, (route) {
      final name = route.settings.name ?? '';
      if (name == '/app_entry') return true;
      if (name == replaceName) return true;
      return false;
    }, arguments: arguments);
  }

  Future<dynamic> routeAppEntry(String name) async {
    return nav.pushNamedAndRemoveUntil(name, (route) => false);
  }

  void closePage<T extends Object>([T? result]) {
    if (!nav.canPop()) return;
    nav.pop(result);
  }

  void closePageTo<T extends Object>(String name, [T? result]) {
    nav.popUntil((route) => route.settings.name == name);
  }

  Future<T?> openUrlRouter<T>(String url,
      {Function(Map<String, dynamic>)? parserCallback,
      Map<String, dynamic>? otherMap}) async {
    final uri = Uri.tryParse(url);
    if (uri == null) Future.value();
    final query = Uri.decodeQueryComponent(uri!.query);
    var map = {};
    try {
      // only for this formatter, why this, ask servicer
      ///message_list_page?param={"news_id":209,"extend_id":0,"news_type":1,"page_title":"\u516c\u544a"}
      map = jsonDecode(query.split('=').last);
    } catch (e) {
      map = Map<String, dynamic>.from(uri.queryParameters);
    } finally {
      if (map.isEmpty) {
        map = Map<String, dynamic>.from(uri.queryParameters);
      }
    }
    if (otherMap != null) {
      map.addAll(otherMap);
    }
    if (map is Map<String, dynamic> && parserCallback != null)
      parserCallback(map);
    if (uri.scheme.isNotEmpty && uri.scheme.startsWith('http')) {
      return openPage(FlutterRouterCons.webView, WebUtil.parameters(uri: url));
    } else if (uri.scheme.isEmpty && uri.path.isNotEmpty) {
      if (map is Map<String, dynamic>) {
        return openPage(uri.path, map);
      } else {
        return openPage(uri.path, uri.queryParameters);
      }
    } else {
      navLog.info('unknown url $url');
    }
    return Future.value();
  }
}
