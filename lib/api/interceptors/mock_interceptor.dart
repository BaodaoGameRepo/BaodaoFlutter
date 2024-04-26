// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

final mockInterceptor = MockInterceptor._();

class MockInterceptor {
  late InterceptorsWrapper interceptor;
  late Map<String, dynamic> mockMap = {};

  MockInterceptor._() {
    interceptor = InterceptorsWrapper(
        onRequest: onRequest, onResponse: onResponse, onError: onError);
  }

  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final path = options.uri.path;
    if (mockMap.isEmpty) {
      final mockJsonString = await rootBundle.loadString("json/mock.json");
      mockMap = await jsonDecode(mockJsonString);
    }
    final match = mockMap.keys
        .firstWhere((element) => path.endsWith(element), orElse: () => "");
    final mockedStructure = mockMap[match];
    String mockedPath = "";
    if (mockedStructure is String) {
      mockedPath = mockedStructure;
    } else if (mockedStructure is List) {
      final params = options.queryParameters;
      params.entries.forEach((e1) {
        try {
          final mockedData = mockedStructure.firstWhere((e2) {
            return e2[e1.key] == e1.value;
          });
          mockedPath = mockedData["json"];
          // ignore: empty_catches
        } catch (e) {}
      });
      if (mockedPath.isEmpty) {
        mockedPath = mockedStructure.last["json"];
      }
    }
    final mockedData = await rootBundle.loadString(mockedPath);
    final map = jsonDecode(mockedData);
    if (mockedData.isEmpty) {
      print('[HTTP] [mock miss] path : $path');
      handler.next(options);
    } else {
      handler.resolve(
          Response(requestOptions: options, data: map, statusCode: 200), true);
    }
  }

  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  void onError(DioError error, ErrorInterceptorHandler handler) {}
}
