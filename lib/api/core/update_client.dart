import 'dart:io';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'base_client.dart';
import 'http_config.dart';

final updateClient = UpdateClient();

class UpdateClient extends BaseClient {
  static final UpdateClient _singleton = UpdateClient._();

  factory UpdateClient() => _singleton;

  UpdateClient._();

  @override
  void initConfig() {
    config = HttpUpdateConfig();
  }

  @override
  void initDio() {
    dio = Dio(BaseOptions(
      baseUrl: config.baseUrl,
      contentType: config.contentType,
      connectTimeout: Duration(milliseconds: config.connectTimeout),
      receiveTimeout: Duration(milliseconds: config.receiveTimeout),
    ));
    //证书
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
      return client;
    };
  }

  @override
  void initInterceptors() {
    List<Interceptor> dioInter = [];
    //http
    dioInter.add(PrettyDioLogger());
    //curl
    dioInter.add(CurlLoggerDioInterceptor(printOnSuccess: true, convertFormData: true));
    //拦截器
    dio.interceptors.addAll(dioInter);
  }
}
