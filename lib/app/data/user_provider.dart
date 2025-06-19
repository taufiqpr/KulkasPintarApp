import 'dart:convert';
import 'package:fridgeeye/app/data/api_provider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  final _apiProvider = Get.find<ApiProvider>();
  final String baseUrl = "https://fridge-eye-flask.vercel.app";

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        if (_apiProvider.token != null)
          'Authorization': 'Bearer ${_apiProvider.token}',
      };

  Future<Map<String, dynamic>> getUser() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/profile'), headers: headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat profil: $e");
      rethrow;
    }
  }

  Future<bool> updateUser(
      String userId, Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/profile/$userId'),
        headers: headers,
        body: jsonEncode(updatedData),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        final message = jsonDecode(response.body)['message'];
        Get.snackbar("Gagal", message ?? 'Gagal update profil');
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal update profil: $e");
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/profile/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final message = jsonDecode(response.body)['message'];
        Get.snackbar("Gagal", message ?? 'Gagal menghapus akun');
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus akun: $e");
      return false;
    }
  }
}
