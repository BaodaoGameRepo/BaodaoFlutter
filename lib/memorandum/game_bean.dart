import 'package:json_annotation/json_annotation.dart';

part 'game_bean.g.dart';


@JsonSerializable()
class GameBean extends Object {

  static String className = 'GameBean';
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'map')
  int map;

  @JsonKey(name: 'game')
  String game;

  @JsonKey(name: 'building')
  List<Building> building;

  @JsonKey(name: 'disturb')
  List<Disturb> disturb;

  @JsonKey(name: 'current')
  int current;

  @JsonKey(name: 'legend')
  List<int> legend;

  @JsonKey(name: 'normal')
  List<int> normal;

  @JsonKey(name: 'deck')
  List<int> deck;

  @JsonKey(name: 'play')
  List<int> play;

  @JsonKey(name: 'discard')
  List<int> discard;

  @JsonKey(name: 'user')
  List<User> user;

  GameBean(this.id,this.map,this.game,this.building,this.disturb,this.current,this.legend,this.normal,this.deck,this.play,this.discard,this.user,);

  factory GameBean.fromJson(Map<String, dynamic> srcJson) => _$GameBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GameBeanToJson(this);

}


@JsonSerializable()
class Building extends Object {

  @JsonKey(name: 'points')
  List<int> points;

  @JsonKey(name: 'belongs')
  List<int> belongs;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'number')
  int? number;

  Building(this.points,this.belongs,this.type,this.number);

  factory Building.fromJson(Map<String, dynamic> srcJson) => _$BuildingFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BuildingToJson(this);

}


@JsonSerializable()
class Disturb extends Object {

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'usr')
  String usr;

  @JsonKey(name: 'number')
  int number;

  Disturb(this.type,this.usr,this.number,);

  factory Disturb.fromJson(Map<String, dynamic> srcJson) => _$DisturbFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DisturbToJson(this);

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

  @JsonKey(name: 'order')
  int order;

  User(this.deck,this.discard,this.hands,this.gold,this.point,this.prosperity,this.id,this.color,this.order,);

  factory User.fromJson(Map<String, dynamic> srcJson) => _$UserFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}

  
