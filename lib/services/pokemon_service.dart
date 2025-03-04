import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  static const String baseUrl = "https://pokeapi.co/api/v2/";

  Future<List<Pokemon>> fetchPokemonList() async {
    final response = await http.get(Uri.parse("${baseUrl}pokemon?limit=50"));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Pokemon> pokemonList = [];

      for (var item in data['results']) {
        final pokemonDetail = await fetchPokemonDetail(item['url']);
        if (pokemonDetail != null) {
          pokemonList.add(pokemonDetail);
        }
      }
      return pokemonList;
    } else {
      throw Exception("Error al obtener Pokémon");
    }
  }

  Future<Pokemon?> fetchPokemonDetail(String url) async {
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Pokemon.fromJson(data);
    }
    return null;
  }
}
