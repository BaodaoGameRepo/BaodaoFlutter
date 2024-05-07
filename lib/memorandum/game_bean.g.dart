// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameBean _$GameBeanFromJson(Map<String, dynamic> json) => GameBean(
      json['id'] as String?,
      ((json['map']??0) as num).toInt(),
      json['game'] as String,
      (json['building'] as List<dynamic>)
          .map((e) => Building.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['disturb'] as List<dynamic>)
          .map((e) => Disturb.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['current'] as num).toInt(),
      (json['legend'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      (json['normal'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      (json['deck'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      (json['play'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      ((json['discard']?? []) as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      (json['user'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GameBeanToJson(GameBean instance) => <String, dynamic>{
      'id': instance.id,
      'map': instance.map,
      'game': instance.game,
      'building': instance.building,
      'disturb': instance.disturb,
      'current': instance.current,
      'legend': instance.legend,
      'normal': instance.normal,
      'deck': instance.deck,
      'play': instance.play,
      'discard': instance.discard,
      'user': instance.user,
    };

Building _$BuildingFromJson(Map<String, dynamic> json) => Building(
      (json['points'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      (json['belongs'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      json['type'] as String,
      json['number'] as int?,
    );

Map<String, dynamic> _$BuildingToJson(Building instance) => <String, dynamic>{
      'points': instance.points,
      'belongs': instance.belongs,
      'type': instance.type,
      'number': instance.number,
    };

Disturb _$DisturbFromJson(Map<String, dynamic> json) => Disturb(
      (json['type'] as num).toInt(),
      json['usr'] as String,
      (json['number'] as num).toInt(),
    );

Map<String, dynamic> _$DisturbToJson(Disturb instance) => <String, dynamic>{
      'type': instance.type,
      'usr': instance.usr,
      'number': instance.number,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      (json['deck'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      (json['discard'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      (json['hands'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      (json['gold'] as num).toInt(),
      (json['point'] as num).toInt(),
      (json['prosperity'] as num).toInt(),
      json['id'] as String,
      json['color'] as String,
      (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'deck': instance.deck,
      'discard': instance.discard,
      'hands': instance.hands,
      'gold': instance.gold,
      'point': instance.point,
      'prosperity': instance.prosperity,
      'id': instance.id,
      'color': instance.color,
      'order': instance.order,
    };
