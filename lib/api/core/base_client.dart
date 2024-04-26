import 'package:dio/dio.dart';

import '../../app_service.dart';
import '../interceptors/mock_interceptor.dart';
import 'client_request_model.dart';
import 'client_response.dart';
import 'http_config.dart';

abstract class BaseClient {
  late Dio dio;
  late HttpBaseConfig config;
  BaseClient() {
    initConfig();
    initDio();
    initInterceptors();
  }
  void initConfig();
  void initDio();
  void initInterceptors();

  Future<ClientResponse<R>> request<R>(ClientRequestModel rModel) async {
    try {
      if (rModel.method == "POST" || rModel.method == "PUT") {
        final resp = await dio.request(
          rModel.path,
          queryParameters: null,
          options: rModel.opthions,
          data: rModel.data ?? rModel.toJson(),
        );
        return ClientResponse.fromResponse<R>(resp,
            parser:
                rModel is ClientRequestModelV2 ? rModel.modelfromJson : null);
      } else {
        final resp = await dio.request(
          rModel.path,
          queryParameters: rModel.toJson(),
          options: rModel.opthions,
          data: rModel.data,
        );
        return ClientResponse.fromResponse<R>(resp,
            parser:
                rModel is ClientRequestModelV2 ? rModel.modelfromJson : null);
      }
    } on DioException catch (e) {
      return ClientResponse<R>(error: ClientError(title: '网络异常，请检查网络环境后重试'));
    } catch (e) {
      return ClientResponse<R>(error: ClientError(title: '网络异常，请检查网络环境后重试'));
    }
  }

  Future<ClientResponse<T>> requestUrl<T>(String url,
      {Map<String, dynamic>? params, Options? options}) async {
    try {
      final resp =
          await dio.requestUri(Uri.parse(url), data: params, options: options);
      return ClientResponse.fromResponse<T>(resp);
    } on DioException catch (e) {
      return ClientResponse<T>(error: ClientError(title: '网络异常，请检查网络环境后重试'));
    } catch (e) {
      return ClientResponse<T>(error: ClientError(title: '网络异常，请检查网络环境后重试'));
    }
  }

  //app mock interface
  void addMockInterceptor({bool add = false}) {
    assert(app.isDebugMode, 'only debug mode enable');
    if (add) {
      dio.interceptors.add(mockInterceptor.interceptor);
    } else {
      dio.interceptors.remove(mockInterceptor.interceptor);
    }
  }
}
