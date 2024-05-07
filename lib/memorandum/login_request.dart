import 'package:json_annotation/json_annotation.dart';

import '../../api/core/client_request_model.dart';


part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest extends ClientRequestModel {
  @override
  String get path => '/login';

  @override
  String get method => ClientRequestModel.METHOD_GET;

  String name;

  String pwd;

  LoginRequest({
    this.name = '',
    this.pwd = '',
  });

  static LoginRequest fromJson(Map<String, dynamic> map) =>
      _$LoginRequestFromJson(map);

  LoginRequest.smsLogin(
    String p,
    String c,
  )   : name = p,
        pwd = c;

  @override
  Map<String, dynamic> toJson() {
    var map = _$LoginRequestToJson(this);
    map.removeWhere((key, value) {
      if (value is String) {
        return value.isEmpty;
      }
      return false;
    });
    return map;
  }
}
