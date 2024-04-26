import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import 'http_config.dart';

abstract class ClientRequestModel<T> {
  String get method => ClientRequestModel.METHOD_POST;

  String get path;

  String get host => '';

  int get port => 0;

  Map<String, dynamic> toJson() => <String, dynamic>{};

  Options get opthions {
    //cache only support GET
    if (useCache) {
      return CacheConfig.cacheOptions
          .copyWith(
              policy: CachePolicy.forceCache, maxStale: Nullable(duration))
          .toOptions()
          .copyWith(method: ClientRequestModel.METHOD_GET);
    }
    return Options(method: method)
      ..sendTimeout = const Duration(milliseconds: 30000)
      ..receiveTimeout = const Duration(milliseconds: 30000);
  }

  dynamic get data => null;

  bool get useCache => false;

  Duration get duration => const Duration();

  // ignore: constant_identifier_names
  static const String METHOD_GET = 'GET';
  static const String METHOD_POST = 'POST';
  static const String METHOD_PUT = 'PUT';
  static const String METHOD_DELETE = 'DELETE';
}

abstract class ClientRequestModelV2<T> extends ClientRequestModel<T> {
  T modelfromJson(dynamic json);
}

class EmptyPOSTRequest extends ClientRequestModel {
  String httpPath;
  EmptyPOSTRequest(this.httpPath);

  @override
  String get method => ClientRequestModel.METHOD_POST;

  @override
  String get path => httpPath;

  @override
  String get host => 'api.dev.desktop.xiaochuanai.com';

  @override
  int get port => 30443;
}

class EmptyGetRequest extends ClientRequestModel {
  String httpPath;
  EmptyGetRequest(this.httpPath);

  @override
  String get host => 'api.dev.desktop.xiaochuanai.com';

  @override
  int get port => 30443;

  @override
  String get method => ClientRequestModel.METHOD_GET;

  @override
  String get path => httpPath;
}
