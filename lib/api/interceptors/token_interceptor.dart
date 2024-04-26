import 'package:dio/dio.dart';

final TokenInterceptor tokenInterceptor = TokenInterceptor();

/// must before header interceptors , header info need  sign
class TokenInterceptor extends Interceptor {
  String token = "";

  TokenInterceptor() {
    setToken();
  }

  void setToken() async {
    // token = await userServices.getToken();
  }

  void setTokenString(String token) {
    this.token = token;
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers["Authorization"] = token;
    super.onRequest(options, handler);
  }
}
