import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:lottie/lottie.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "👋 Selamat Datang",
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
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/Logo 1.png',
                    height: 48,
                    width: 48,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Lottie.asset(
                'assets/images/cooking.json',
                height: 230,
                width: double.infinity,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                repeat: true,
                animate: true,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Buah',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Arahkan ke halaman tambah buah
                    Get.toNamed('/add-fruit');
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    textStyle: const TextStyle(fontSize: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() {
              return Column(
                children: controller.fruits.map((fruit) {
                  return _buildFruitItem(
                    name: fruit['name'],
                    image: fruit['image'],

                    status: fruit['daysLeft'] <= 0
                        ? 'Disarankan dibuang'
                        : 'kadaluwarsa dalam ${fruit['daysLeft']} hari',
                    freshness: getFreshnessStatus(fruit['daysLeft']),
                    description: 'Deskripsi buah otomatis atau statis',
                    days: '${fruit['daysLeft']} Hari',
                    purchaseDate:
                        formatDate(fruit['purchaseDate']), // fungsi bantu
                    expiryDate: formatDate(fruit['expiryDate']),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          elevation: 0,
          color: Colors.white,
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.teal),
                  onPressed: () {
                    Get.toNamed('/home');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.restaurant_menu, color: Colors.grey),
                  onPressed: () {
                    Get.toNamed('/recipe');
                  },
                ),
                const SizedBox(width: 40),
                IconButton(
                  icon:
                      const Icon(Icons.notifications_none, color: Colors.grey),
                  onPressed: () {
                    Get.toNamed('/notifications');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline, color: Colors.grey),
                  onPressed: () {
                    Get.toNamed('/profile');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Get.toNamed('/realtime');
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

  String getFreshnessStatus(int daysLeft) {
    if (daysLeft >= 5) return 'Kesegaran : Sangat Baik';
    if (daysLeft >= 2) return 'Kesegaran : Cukup';
    return 'Kesegaran : Buruk';
  }

  String formatDate(DateTime date) {
    return '${date.day} ${_monthName(date.month)} ${date.year} - '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} WIB';
  }

  String _monthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
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
