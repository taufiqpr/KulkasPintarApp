import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fridgeeye/app/data/user_provider.dart';

class HomeController extends GetxController {
  final String baseUrl = "http://127.0.0.1:5000";
  final userData = {}.obs;
  final _userProvider = Get.find<UserProvider>();
  var fruits = <Map<String, dynamic>>[].obs;

  void addFruit(Map<String, dynamic> fruitData) {
    fruits.add(fruitData);
  }

  @override
  void onInit() {
    super.onInit();
    fetchUser();
    fetchFruits();
  }

  Future<void> fetchFruits() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/fruits'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        fruits.value = List<Map<String, dynamic>>.from(data.map((item) {
          final expiry = DateTime.parse(item['expiryDate']);
          final today = DateTime.now();
          final todayOnly = DateTime(today.year, today.month, today.day);
          final daysLeft = expiry.difference(todayOnly).inDays;

          return {
            'name': item['name'],
            'image': item['image'],
            'purchaseDate': DateTime.parse(item['purchaseDate']),
            'expiryDate': expiry,
            'daysLeft': daysLeft,
          };
        }));
      } else {
        print("❌ Gagal mengambil buah: ${response.body}");
      }
    } catch (e) {
      print("❌ Error fetch: $e");
    }
  }

  Future<void> addFruitToBackend(Map<String, dynamic> fruitData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/fruits'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(fruitData),
      );

      if (response.statusCode == 201) {
        print('✅ Buah berhasil ditambahkan');
        await fetchFruits(); // refresh data
      } else {
        print('❌ Gagal menambahkan: ${response.body}');
      }
    } catch (e) {
      print('❌ Error add: $e');
    }
  }

  void fetchUser() async {
    try {
      final user = await _userProvider.getUser();
      userData.value = user;
    } catch (e) {
      print("Error fetch user: $e");
    }
  }
}
