import 'package:dio/dio.dart';

class HeaderInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
  }
}
