import 'package:equatable/equatable.dart';
import '../../data/models/pokemon_dto.dart';

/// Estado base para la gestión de la API de Pokémon.
abstract class ApiState extends Equatable {
  final PokemonDto? selectedPokemon;
  final String? formText;

  const ApiState({this.selectedPokemon, this.formText});

  @override
  List<Object?> get props => [selectedPokemon, formText];
}

/// Estado inicial antes de cargar datos de la API.
class ApiInitial extends ApiState {
  const ApiInitial({super.selectedPokemon, super.formText});
}

/// Estado que indica que se está realizando una operación de carga desde la API.
class ApiLoading extends ApiState {
  const ApiLoading({super.selectedPokemon, super.formText});
}

/// Estado que contiene la lista de Pokémon cargados correctamente desde la API.
class ApiLoaded extends ApiState {
  final List<PokemonDto> items;

  const ApiLoaded(this.items, {super.selectedPokemon, super.formText});

  @override
  List<Object?> get props => [items, selectedPokemon, formText];
}

/// Estado que indica que ocurrió un error al obtener datos de la API.
class ApiError extends ApiState {
  final String message;

  const ApiError(this.message, {super.selectedPokemon, super.formText});

  @override
  List<Object?> get props => [message, selectedPokemon, formText];
}
