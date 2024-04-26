import 'dart:io';

import 'package:dio/dio.dart';


typedef FromJson<T> = T Function(dynamic json);

class ClientResponse<T> {
  //business data
  final T? data;
  //busindess error
  final ClientError? error;
  //http
  final int? httpCode;
  final String? httpMsg;

  //origin data use for http.data is not json formatter
  final dynamic originData;

  const ClientResponse(
      {this.data, this.error, this.httpCode, this.httpMsg, this.originData});

  static ClientResponse<T> fromResponse<T>(Response response,
      {FromJson? parser}) {
    final httpCode = response.statusCode;
    final httpMsg = response.statusMessage;
    if ((httpCode == HttpStatus.ok || httpCode == HttpStatus.notModified) &&
        response.data is Map<String, dynamic>) {
      Map<String, dynamic> map = response.data;
      final jsonData = map['data'];
      if (jsonData is Map<String, dynamic>) {
        final data = parser == null ? fromJsonT<T>(jsonData) : parser(jsonData);
        final error = ClientError.fromJson(map['errors'] ?? {});
        return ClientResponse(
            data: data, error: error, httpCode: httpCode, httpMsg: httpMsg);
      } else if (jsonData is List<dynamic>) {
        final data = fromJsonListT<T>(jsonData);
        final error = ClientError.fromJson(map['errors'] ?? {});
        return ClientResponse(
            data: data, error: error, httpCode: httpCode, httpMsg: httpMsg);
      } else {
        final error = ClientError.fromJson(map['errors'] ?? {});
        return ClientResponse(
            data: null,
            error: error,
            httpCode: httpCode,
            httpMsg: httpMsg,
            originData: jsonData);
      }
    } else if (httpCode != HttpStatus.ok &&
        httpCode != HttpStatus.notModified) {
      return ClientResponse(httpCode: httpCode, httpMsg: httpMsg);
    } else {
      return ClientResponse(
          httpCode: httpCode, httpMsg: httpMsg, originData: response.data);
    }
  }

  bool get httpSuccess => httpCode == HttpStatus.ok;

  bool get success => httpCode == HttpStatus.ok && data != null;

  static T? fromJsonT<T>(Map<String, dynamic> map) {
    final name = T.toString();
    // if (name == BatchResponse.className) {
    //   return BatchResponse.fromJson(map) as T;
    // }
    return map as T;
  }

  static T? fromJsonListT<T>(List<dynamic> list) {
    final name = T.toString();
    return list as T;
  }

  String get errorMsg => error?.title ?? httpMsg ?? '';
}

class ClientError {
  String title;

  String code;

  ClientError({this.title = '', this.code = ''});

  ClientError.fromJson(Map<String, dynamic> map)
      : title = map['title'] ?? '',
        code = map['code'] ?? '';
}
