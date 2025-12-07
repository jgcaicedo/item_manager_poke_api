import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/sources/pokemon_api.dart';
import '../../data/models/pokemon_dto.dart';
import 'api_state.dart';

class ApiCubit extends Cubit<ApiState> {
  final PokemonApi api;

  ApiCubit(this.api) : super(const ApiInitial());

  void selectPokemon(PokemonDto pokemon) {
    if (state is ApiLoaded) {
      emit(ApiLoaded((state as ApiLoaded).items, selectedPokemon: pokemon, formText: state.formText));
    } else {
      emit(ApiInitial(selectedPokemon: pokemon, formText: state.formText));
    }
  }

  void updateFormText(String text) {
    if (state is ApiLoaded) {
      emit(ApiLoaded((state as ApiLoaded).items, selectedPokemon: state.selectedPokemon, formText: text));
    } else {
      emit(ApiInitial(selectedPokemon: state.selectedPokemon, formText: text));
    }
  }

  Future<void> fetchPokemons() async {
    emit(const ApiLoading());
    try {
      final list = await api.getPokemonList();
      emit(ApiLoaded(list, selectedPokemon: state.selectedPokemon, formText: state.formText));
    } catch (e) {
      emit(ApiError('Error al cargar Pokémon', selectedPokemon: state.selectedPokemon, formText: state.formText));
    }
  }
}
