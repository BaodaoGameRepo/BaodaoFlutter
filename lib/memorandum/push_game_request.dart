import 'package:json_annotation/json_annotation.dart';

import '../../api/core/client_request_model.dart';


part 'push_game_request.g.dart';

@JsonSerializable()
class PushGameRequest extends ClientRequestModel {
  @override
  String get path => '/push_game';

  @override
  String get method => ClientRequestModel.METHOD_POST;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'data')
  String data;

  PushGameRequest(
    this.id,
    this.data,
  );

  factory PushGameRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$PushGameRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PushGameRequestToJson(this);
}
