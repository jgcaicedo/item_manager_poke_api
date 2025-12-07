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
  testWidgets('Crear item muestra error si no hay nombre ni Pokémon', (WidgetTester tester) async {
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
    await tester.tap(find.text('Guardar Item'));
    await tester.pump();
    expect(find.textContaining('Por favor'), findsOneWidget);
  });

  testWidgets('Crear item funciona cuando se llena el nombre y selecciona Pokémon', (WidgetTester tester) async {
    final mockPreferenceCubit = MockPreferenceCubit();
    final mockApiCubit = MockApiCubit();
    when(() => mockPreferenceCubit.state).thenReturn(PreferenceInitial());
    when(() => mockPreferenceCubit.stream).thenAnswer((_) => Stream.value(PreferenceInitial()));

    // Creamos un Pokémon de prueba
    final testPokemon = PokemonDto(
      id: 1,
      name: 'bulbasaur',
      sprites: Sprites(frontDefault: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png'),
      types: [PokemonTypeSlot(type: TypeInfo(name: 'planta'))],
    );

    when(() => mockApiCubit.state).thenReturn(ApiInitial(selectedPokemon: testPokemon));
    when(() => mockApiCubit.stream).thenAnswer((_) => Stream.value(ApiInitial(selectedPokemon: testPokemon)));

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
        GoRoute(
          path: '/prefs',
          builder: (context, state) => const SizedBox(), // dummy for navigation
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: testRouter,
      ),
    );
    await tester.enterText(find.byType(TextField), 'Mi item');

    await tester.tap(find.text('Guardar Item'));
    await tester.pump();
    expect(find.textContaining('Por favor'), findsNothing);
  });
}
