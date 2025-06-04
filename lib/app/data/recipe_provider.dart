import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class RecipeProvider extends GetConnect {
  static const String _baseURL = 'http://127.0.0.1:5000/get_recipes';

  Future<List<dynamic>> getRecipes(String query) async {
    final response = await http.get(Uri.parse('$_baseURL?query=$query'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Gagal mengambil data resep');
    }
  }

  Future<Map<String, dynamic>> getRecipeDetail(int id) async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:5000/get_recipe_detail?id=$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal mengambil detail resep');
    }
  }
}
