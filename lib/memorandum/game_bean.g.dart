// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameBean _$GameBeanFromJson(Map<String, dynamic> json) => GameBean(
      json['id'] as String,
      (json['map'] as num).toInt(),
      json['game'] as String,
      json['current'] as String,
      (json['legend'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      (json['normal'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      (json['deck'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      (json['discard'] as List<dynamic>)
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
      'current': instance.current,
      'legend': instance.legend,
      'normal': instance.normal,
      'deck': instance.deck,
      'discard': instance.discard,
      'user': instance.user,
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
    };
