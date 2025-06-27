import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/notif_controller.dart';

class NotifView extends GetView<NotifController> {
  const NotifView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Notifikasi', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey.shade300,
              height: 1.0,
            )),
      ),
      body: SafeArea(
        child: Obx(() {
          final sudah = controller.alreadyExpired;
          final hampir = controller.almostExpired;

          if (sudah.isEmpty && hampir.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada notifikasi',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              ...sudah.map((item) => _buildNotificationCard(
                    icon: Icons.warning_amber_rounded,
                    iconColor: Colors.red,
                    title: '$item sudah busuk!',
                    description:
                        'Segera buang atau manfaatkan sebelum membusuk lebih lanjut!',
                  )),
              const SizedBox(height: 12),
              ...hampir.map((item) => _buildNotificationCard(
                    icon: Icons.info_outline,
                    iconColor: Colors.orange,
                    title: '$item hampir busuk',
                    description: 'Coba diolah hari ini, yuk!',
                  )),
            ],
          );
        }),
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
                  icon: const Icon(Icons.home, color: Colors.grey),
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
                      const Icon(Icons.notifications_none, color: Colors.teal),
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

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
