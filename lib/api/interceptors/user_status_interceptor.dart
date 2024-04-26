import 'package:dio/dio.dart';

final UserStatusInterceptor userStatusInterceptor = UserStatusInterceptor();

class UserStatusInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    Map<String, dynamic> map = response.data;
    print(map);
  }
}
