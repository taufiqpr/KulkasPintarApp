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
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildNotificationCard(
              icon: Icons.warning_amber_rounded,
              iconColor: Colors.red,
              title: 'Pisang kamu tinggal 1 hari lagi!',
              description: 'Segera olah jadi banana muffin sebelum busuk!',
            ),
            const SizedBox(height: 12),
            _buildNotificationCard(
              icon: Icons.info_outline,
              iconColor: Colors.orange,
              title: 'Wortel kamu mulai layu nih...',
              description: 'Bikin tumisan yuk?',
            ),
            const SizedBox(height: 12),
            _buildNotificationCard(
              icon: Icons.info_outline,
              iconColor: Colors.orange,
              title: 'Brokoli kamu mulai tampak menguning',
              description: 'Coba bikin sup hangat?',
            ),
            const SizedBox(height: 12),
            _buildNotificationCard(
              icon: Icons.check_circle_outline,
              iconColor: Colors.teal,
              title: 'Selamat kamu sudah menyelamatkan 2 bahan minggu ini!',
              description: '',
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
                icon: const Icon(Icons.notifications_none, color: Colors.teal),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {},
        child: const Icon(Icons.add),
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
