import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  final String baseUrl = "https://fridge-eye-flask-ten.vercel.app";
  final box = GetStorage();

  Future<String?> registerUser(
      String email, String username, String password) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return null;
    } else {
      return jsonDecode(response.body)['message'];
    }
  }

  Future<String?> verifyOtp(String email, String otp) async {
    final url = Uri.parse('$baseUrl/verify_otp_register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
    );

    if (response.statusCode == 201) {
      final token = jsonDecode(response.body)['token'];
      print("Token berhasil: $token");
      return null;
    } else {
      return jsonDecode(response.body)['message'];
    }
  }

  Future<String?> resendOtp(String email) async {
    final url = Uri.parse('$baseUrl/resend_otp');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return null;
    } else {
      return jsonDecode(response.body)['message'];
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        box.write('token', data['token']);
        return data;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      Get.snackbar("Error", "Login gagal");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchLoginHistory() async {
    try {
      final token = box.read('token');
      final response = await http.get(
        Uri.parse('$baseUrl/login-history'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> googleSignIn(
      String idToken, String? name, String? email, String? photoUrl) async {
    final url = Uri.parse('$baseUrl/google_auth');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'id_token': idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        box.write('token', data['token']);
        box.write('name', name ?? '');
        box.write('email', email ?? '');
        box.write('photo', photoUrl ?? '');

        return data;
      } else {
        throw jsonDecode(response.body)['message'] ?? "Login Google gagal";
      }
    } catch (e) {
      Get.snackbar("Error", "Login Google gagal");
      rethrow;
    }
  }

  String? get token => box.read('token');
}
