import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class NotifController extends GetxController {
  final box = GetStorage();
  var alreadyExpired = <String>[].obs;
  var almostExpired = <String>[].obs;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    _initNotification();
    fetchNotifications();
  }

  void _initNotification() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'fruit_channel', // ID channel
      'Notifikasi Buah', // Nama channel
      channelDescription: 'Notifikasi untuk buah yang hampir atau sudah busuk',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> fetchNotifications() async {
    final token = box.read('token');
    try {
      final response = await http.get(
        Uri.parse('https://modelfridgeye-production.up.railway.app/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        alreadyExpired.value = List<String>.from(data['sudah_busuk']);
        almostExpired.value = List<String>.from(data['hampir_busuk']);

        for (final fruit in data['sudah_busuk']) {
          showNotification(
              '❌ $fruit sudah busuk!', 'Sebaiknya segera dibuang.');
        }

        for (final fruit in data['hampir_busuk']) {
          showNotification(
              '⚠️ $fruit hampir busuk', 'Ayo segera diolah sebelum basi!');
        }
      } else {
        print('❌ Gagal fetch notifikasi: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetch: $e');
    }
  }
}
