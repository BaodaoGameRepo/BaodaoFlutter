import 'package:json_annotation/json_annotation.dart';

import '../../api/core/client_request_model.dart';


part 'get_game_request.g.dart';

@JsonSerializable()
class GetGameRequest extends ClientRequestModel {
  @override
  String get path => '/get_game';

  @override
  String get method => ClientRequestModel.METHOD_GET;

  @JsonKey(name: 'id')
  String id;

  GetGameRequest(
    this.id,
  );

  factory GetGameRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$GetGameRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetGameRequestToJson(this);
}
