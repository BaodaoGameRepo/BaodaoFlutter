import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class CacheConfig {
  static CacheOptions cacheOptions = CacheOptions(
      store: MemCacheStore(maxSize: 10485760, maxEntrySize: 1048576),
      maxStale: const Duration(minutes: 5),
      policy: CachePolicy.noCache);
}

abstract class HttpBaseConfig {
  String get baseUrl;

  String get contentType;

  ValidateStatus get validateStatus => (s) => true;

  int connectTimeout = 3 * 1000;

  int receiveTimeout = 3 * 1000;
}

class HttpConfig extends HttpBaseConfig {
  @override
  String get baseUrl => 'https://api.dev.desktop.xiaochuanai.com:30443';

  @override
  String get contentType => "application/json";
}

class HttpUpdateConfig extends HttpBaseConfig {
  @override
  String get baseUrl => 'http://104.171.202.53:5000/';

  @override
  String get contentType => 'application/json;charset=utf-8';
}

// never use this code
class OtherConfig extends HttpBaseConfig {
  @override
  String get baseUrl => '';

  @override
  String get contentType => 'application/json;charset=utf-8';
}
