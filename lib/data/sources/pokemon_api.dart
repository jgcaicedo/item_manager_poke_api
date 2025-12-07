import 'package:dio/dio.dart';
import '../models/pokemon_dto.dart';

/// Clase encargada de realizar las peticiones a la PokéAPI.
class PokemonApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2/'));

  // Obtiene lista de Pokémon (resumen)
  Future<List<PokemonDto>> getPokemonList({int limit = 20}) async {
    final response = await _dio.get('pokemon?limit=$limit');

    final List results = response.data['results'];
    
    // Obtener detalles de cada Pokémon individualmente
    final List<Future<PokemonDto>> futures = results.map((item) {
      final url = item['url']; // url completa del Pokémon
      return _dio.get(url).then((res) => PokemonDto.fromJson(res.data));
    }).toList();

    return await Future.wait(futures);
  }
}
