// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PokemonDto _$PokemonDtoFromJson(Map<String, dynamic> json) => PokemonDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      sprites: Sprites.fromJson(json['sprites'] as Map<String, dynamic>),
      types: (json['types'] as List<dynamic>)
          .map((e) => PokemonTypeSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PokemonDtoToJson(PokemonDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sprites': instance.sprites,
      'types': instance.types,
    };

Sprites _$SpritesFromJson(Map<String, dynamic> json) => Sprites(
      frontDefault: json['front_default'] as String,
    );

Map<String, dynamic> _$SpritesToJson(Sprites instance) => <String, dynamic>{
      'front_default': instance.frontDefault,
    };

PokemonTypeSlot _$PokemonTypeSlotFromJson(Map<String, dynamic> json) =>
    PokemonTypeSlot(
      type: TypeInfo.fromJson(json['type'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PokemonTypeSlotToJson(PokemonTypeSlot instance) =>
    <String, dynamic>{
      'type': instance.type,
    };

TypeInfo _$TypeInfoFromJson(Map<String, dynamic> json) => TypeInfo(
      name: json['name'] as String,
    );

Map<String, dynamic> _$TypeInfoToJson(TypeInfo instance) => <String, dynamic>{
      'name': instance.name,
    };
