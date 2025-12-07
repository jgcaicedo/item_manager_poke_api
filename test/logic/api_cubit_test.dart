import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:item_manager_poke_api/cubit/api_cubit/api_cubit.dart';
import 'package:item_manager_poke_api/cubit/api_cubit/api_state.dart';
import 'package:mocktail/mocktail.dart';

import 'package:item_manager_poke_api/data/models/pokemon_dto.dart';
import 'package:item_manager_poke_api/data/sources/pokemon_api.dart';

class MockPokemonApi extends Mock implements PokemonApi {}

void main() {
  late ApiCubit cubit;
  late MockPokemonApi mockApi;

  final dto = PokemonDto(
    id: 1,
    name: 'bulbasaur',
    sprites: Sprites(frontDefault: 'https://pokeapi.co/bulba.png'),
    types: [
      PokemonTypeSlot(
        type: TypeInfo(name: 'grass'),
      ),
    ],
  );

  setUp(() {
    mockApi = MockPokemonApi();
    cubit = ApiCubit(mockApi);
  });

  group('ApiCubit', () {
    test('initial state is ApiInitial', () {
      expect(cubit.state, ApiInitial());
    });

    blocTest<ApiCubit, ApiState>(
      'emits [ApiLoading, ApiLoaded] when fetchPokemons succeeds',
      build: () {
        when(() => mockApi.getPokemonList()).thenAnswer((_) async => [dto]);
        return cubit;
      },
      act: (cubit) => cubit.fetchPokemons(),
      expect: () => [
        ApiLoading(),
        ApiLoaded([dto]),
      ],
    );

    blocTest<ApiCubit, ApiState>(
      'emits [ApiLoading, ApiError] when fetchPokemons fails',
      build: () {
        when(() => mockApi.getPokemonList()).thenThrow(Exception('API failed'));
        return cubit;
      },
      act: (cubit) => cubit.fetchPokemons(),
      expect: () => [
        ApiLoading(),
        isA<ApiError>(),
      ],
    );
  });
}
