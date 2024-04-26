import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:logging/logging.dart';

import 'api/core/app_client.dart';

OriginAppService get app => OriginAppService.singleton();

final log = Logger('app.service');

class OriginAppService {
  OriginAppService._();

  void init() {
    client;
  }

  static final OriginAppService _singleton = OriginAppService._();

  factory OriginAppService.singleton() => _singleton;

  final navkey = const GlobalObjectKey<NavigatorState>('nav');

  bool get isDebugMode => kDebugMode;

  void showToast(
    String msg, {
    Alignment alignment = Alignment.center,
    Widget? widget,
  }) {
    SmartDialog.showToast(
      msg,
      alignment: alignment,
      debounce: true,
      displayType: SmartToastType.normal,
      builder: (c) {
        if (widget != null) {
          return widget;
        } else {
          return Container();
        }
      },
    );
  }

  void showLoading() {
    SmartDialog.showLoading(
        maskColor: Colors.transparent,
        builder: (ctx) => Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(16),
          child: const CupertinoActivityIndicator(
            color: Colors.white,
          ),
        ));
  }

  void hiddenLoading() {
    SmartDialog.dismiss();
  }
}
