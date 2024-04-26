import 'dart:io';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app_service.dart';
import '../interceptors/header_interceptor.dart';
import '../interceptors/token_interceptor.dart';
import '../interceptors/user_status_interceptor.dart';
import 'base_client.dart';
import 'http_config.dart';

final client = AppClient();

class AppClient extends BaseClient {
  AppClient._();

  static final AppClient _singleton = AppClient._();

  factory AppClient() => _singleton;

  @override
  void initConfig() {
    config = HttpConfig();
  }

  @override
  void initDio() {
    dio = Dio(BaseOptions(
        baseUrl: config.baseUrl,
        contentType: config.contentType,
        connectTimeout: Duration(milliseconds: config.connectTimeout),
        receiveTimeout: Duration(milliseconds: config.receiveTimeout),
        validateStatus: config.validateStatus));
    //证书
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (c) {
      c.badCertificateCallback = (X509Certificate cert, String host, int port) {
        print("badCertificateCallback ???? ");
        return true;
      };
      // c.findProxy = HttpClient.findProxyFromEnvironment;
      c.findProxy = ((url) {
        // return "PROXY 192.168.0.11:8888";
        return HttpClient.findProxyFromEnvironment(url);
      });
      return c;
    };
  }

  @override
  void initInterceptors() {
    List<Interceptor> dioInter = [];
    // cache
    dioInter.add(DioCacheInterceptor(options: CacheConfig.cacheOptions));
    //token
    dioInter.add(tokenInterceptor);
    //userStatus
    dioInter.add(userStatusInterceptor);
    // comment header
    dioInter.add(HeaderInterceptor());
    if (app.isDebugMode) {
      //过长的输出会卡 线程
      dioInter.add(PrettyDioLogger());
      //curl
      dioInter.add(CurlLoggerDioInterceptor(
          printOnSuccess: true, convertFormData: true));
    }
    //拦截器
    dio.interceptors.addAll(dioInter);
  }
}
