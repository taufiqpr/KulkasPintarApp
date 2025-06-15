import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            const Text(
              '👋 Selamat Datang',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Obx(() {
              final user = controller.userData;
              return Text(
                user['username'] ?? '',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/unsplash_AEU9UZstCfs.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            _buildFruitItem(
              name: 'Apel',
              image: 'assets/images/Ellipse 1.png',
              status: 'Disarankan dibuang',
              freshness: 'Kesegaran : Buruk',
              description:
                  'Apel sudah mulai membusuk, sebaiknya dibuang untuk menghindari kontaminasi makanan lainnya.',
              days: '0 Hari',
              purchaseDate: '10 Mei 2025',
              expiryDate: '21 Mei 2025',
            ),
            _buildFruitItem(
              name: 'Wortel',
              image: 'assets/images/unsplash_R198mTymEFQ.png',
              status: 'kadaluwarsa dalam 6 hari',
              freshness: 'Kesegaran : Sangat Baik',
              description:
                  'Biar wortel nggak cepat layu, simpan dalam plastik berlubang di laci sayur kulkas, ya! Kupasnya nanti aja pas mau dimasak',
              days: '6 Hari',
              purchaseDate: '15 Mei 2025',
              expiryDate: '21 Mei 2025',
            ),
            _buildFruitItem(
              name: 'Tomat',
              image: 'assets/images/Ellipse 1-2.png',
              status: 'kadaluwarsa dalam 4 hari',
              freshness: 'Kesegaran : Cukup',
              description:
                  'Tomat sebaiknya disimpan di tempat sejuk, bukan di dalam kulkas. Jika sudah matang, bisa masuk kulkas agar lebih awet.',
              days: '4 Hari',
              purchaseDate: '17 Mei 2025',
              expiryDate: '21 Mei 2025',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: const Icon(Icons.home, color: Colors.teal),
                  onPressed: () => Get.offNamed('/home')),
              IconButton(
                  icon: const Icon(Icons.restaurant_menu, color: Colors.grey),
                  onPressed: () => Get.offNamed('/recipe')),
              const SizedBox(width: 40),
              IconButton(
                  icon:
                      const Icon(Icons.notifications_none, color: Colors.grey),
                  onPressed: () => Get.offNamed('/notifications')),
              IconButton(
                  icon: const Icon(Icons.person_outline, color: Colors.grey),
                  onPressed: () => Get.offNamed('/profile')),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Get.toNamed('/deteksi');
        },
        shape: CircleBorder(),
        child: const Icon(
          Icons.photo_camera_outlined,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFruitItem({
    required String name,
    required String image,
    required String status,
    required String freshness,
    required String description,
    required String days,
    required String purchaseDate,
    required String expiryDate,
  }) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/detail', arguments: {
          'name': name,
          'image': image,
          'status': status,
          'freshness': freshness,
          'description': description,
          'days': days,
          'purchaseDate': purchaseDate,
          'expiryDate': expiryDate,
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.teal.shade100),
          color: Colors.white,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                image,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                      fontSize: 12,
                      color: status.contains('buang')
                          ? Colors.red
                          : Colors.orange),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
