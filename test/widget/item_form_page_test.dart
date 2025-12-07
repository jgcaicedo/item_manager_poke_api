import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:item_manager_poke_api/cubit/preference_cubit/preference_cubit.dart';
import 'package:item_manager_poke_api/cubit/preference_cubit/preference_state.dart';
import 'package:item_manager_poke_api/cubit/api_cubit/api_cubit.dart';
import 'package:item_manager_poke_api/cubit/api_cubit/api_state.dart';
import 'package:item_manager_poke_api/view/pages/item_form_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:item_manager_poke_api/data/models/pokemon_dto.dart';
import 'package:go_router/go_router.dart';

class MockPreferenceCubit extends Mock implements PreferenceCubit {}
class MockApiCubit extends Mock implements ApiCubit {}

void main() {
  testWidgets('El texto del formulario se mantiene al seleccionar Pokémon', (WidgetTester tester) async {
    final mockPreferenceCubit = MockPreferenceCubit();
    final mockApiCubit = MockApiCubit();
    when(() => mockPreferenceCubit.state).thenReturn(PreferenceInitial());
    when(() => mockPreferenceCubit.stream).thenAnswer((_) => Stream.value(PreferenceInitial()));
    when(() => mockApiCubit.state).thenReturn(const ApiInitial());
    when(() => mockApiCubit.stream).thenAnswer((_) => Stream.value(const ApiInitial()));

    final testRouter = GoRouter(
      initialLocation: '/prefs/new',
      routes: [
        GoRoute(
          path: '/prefs/new',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<PreferenceCubit>.value(value: mockPreferenceCubit),
              BlocProvider<ApiCubit>.value(value: mockApiCubit),
            ],
            child: const ItemFormPage(),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: testRouter,
      ),
    );

    // Escribir texto en el campo de nombre
    await tester.enterText(find.byType(TextField), 'Mi Pokémon favorito');

    // Verificar que el texto esté presente
    expect(find.text('Mi Pokémon favorito'), findsOneWidget);

    // Simular selección de Pokémon (cambiar el estado del cubit)
    final testPokemon = PokemonDto(
      id: 1,
      name: 'pikachu',
      sprites: Sprites(frontDefault: 'https://example.com/pikachu.png'),
      types: [PokemonTypeSlot(type: TypeInfo(name: 'eléctrico'))],
    );

    when(() => mockApiCubit.state).thenReturn(ApiInitial(selectedPokemon: testPokemon, formText: 'Mi Pokémon favorito'));
    when(() => mockApiCubit.stream).thenAnswer((_) => Stream.value(ApiInitial(selectedPokemon: testPokemon, formText: 'Mi Pokémon favorito')));

    // Reconstruir el widget (simulando navegación de vuelta)
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: testRouter,
      ),
    );

    // Verificar que el texto se mantiene
    expect(find.text('Mi Pokémon favorito'), findsOneWidget);
  });
}