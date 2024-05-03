import 'package:json_annotation/json_annotation.dart'; 
  
part 'game_bean.g.dart';


@JsonSerializable()
  class GameBean extends Object {

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'map')
  int map;

  @JsonKey(name: 'game')
  String game;

  @JsonKey(name: 'current')
  String current;

  @JsonKey(name: 'legend')
  List<int> legend;

  @JsonKey(name: 'normal')
  List<int> normal;

  @JsonKey(name: 'deck')
  List<int> deck;

  @JsonKey(name: 'discard')
  List<int> discard;

  @JsonKey(name: 'user')
  List<User> user;

  GameBean(this.id,this.map,this.game,this.current,this.legend,this.normal,this.deck,this.discard,this.user,);

  factory GameBean.fromJson(Map<String, dynamic> srcJson) => _$GameBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GameBeanToJson(this);

}

  
@JsonSerializable()
  class User extends Object {

  @JsonKey(name: 'deck')
  List<int> deck;

  @JsonKey(name: 'discard')
  List<int> discard;

  @JsonKey(name: 'hands')
  List<int> hands;

  @JsonKey(name: 'gold')
  int gold;

  @JsonKey(name: 'point')
  int point;

  @JsonKey(name: 'prosperity')
  int prosperity;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'color')
  String color;

  User(this.deck,this.discard,this.hands,this.gold,this.point,this.prosperity,this.id,this.color,);

  factory User.fromJson(Map<String, dynamic> srcJson) => _$UserFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}

  
