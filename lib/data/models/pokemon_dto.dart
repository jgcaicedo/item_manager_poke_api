import 'package:json_annotation/json_annotation.dart';

part 'pokemon_dto.g.dart';

@JsonSerializable()
/// Modelo que representa un Pokémon obtenido de la API.
class PokemonDto {
  final int id;
  final String name;

  final Sprites sprites;
  final List<PokemonTypeSlot> types;

  PokemonDto({
    required this.id,
    required this.name,
    required this.sprites,
    required this.types,
  });

  factory PokemonDto.fromJson(Map<String, dynamic> json) =>
      _$PokemonDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonDtoToJson(this);
}

@JsonSerializable()
/// Modelo para los sprites (imágenes) de un Pokémon.
class Sprites {
  @JsonKey(name: 'front_default')
  final String frontDefault;

  Sprites({required this.frontDefault});

  factory Sprites.fromJson(Map<String, dynamic> json) =>
      _$SpritesFromJson(json);

  Map<String, dynamic> toJson() => _$SpritesToJson(this);
}

@JsonSerializable()
/// Modelo para el tipo de Pokémon y su slot.
class PokemonTypeSlot {
  final TypeInfo type;

  PokemonTypeSlot({required this.type});

  factory PokemonTypeSlot.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeSlotFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonTypeSlotToJson(this);
}

@JsonSerializable()
/// Modelo para la información de tipo de un Pokémon.
class TypeInfo {
  final String name;

  TypeInfo({required this.name});

  factory TypeInfo.fromJson(Map<String, dynamic> json) =>
      _$TypeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TypeInfoToJson(this);
}
