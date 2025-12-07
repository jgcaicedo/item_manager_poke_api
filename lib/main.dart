import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:item_manager_poke_api/app.dart';
import 'package:item_manager_poke_api/data/sources/pokemon_api.dart';
import 'package:item_manager_poke_api/cubit/api_cubit/api_cubit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/item.dart';
import 'data/repositories/hive_item_repository.dart';
import 'cubit/preference_cubit/preference_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ItemAdapter());
  final repository = HiveItemRepository();
  await repository.init();

  runApp(
  MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => PreferenceCubit(repository)..loadItems(),
      ),
      BlocProvider(
        create: (_) => ApiCubit(PokemonApi())..fetchPokemons(),
      ),
    ],
    child: const ItemManagerPokeApiApp(),
  ),
);

}
