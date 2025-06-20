import 'package:flutter/material.dart';
import 'package:fridgeeye/app/modules/recipe/controllers/recipe_controller.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../controllers/profile_controller.dart';
import 'package:get_storage/get_storage.dart';

class ProfileView extends GetView<ProfileController> {
  final recipeController = Get.find<RecipeController>();

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final photoUrl = box.read('photo') ?? '';
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profil Saya', style: TextStyle(color: Colors.black)),
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
          if (controller.userData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final user = controller.userData;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: photoUrl.isNotEmpty
                            ? NetworkImage(photoUrl)
                            : AssetImage('assets/images/minion.png')
                                as ImageProvider,
                      ),
                      Positioned(
                        child: GestureDetector(
                          onTap: () => _showUpdateDialog(context, controller),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.teal,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user['username'] ?? '',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user['email'] ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Resep Favorit",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    final favorites =
                        recipeController.likedRecipes.values.toList();

                    if (favorites.isEmpty) {
                      return const Text("Belum ada resep favorit.");
                    }

                    return Column(
                      children: favorites.map((recipe) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  recipe['image'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(recipe['title'],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text(recipe['duration'],
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.favorite, color: Colors.red),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  _menuTile(Icons.notifications, "Notifikasi",
                      () => Get.toNamed('/notifications')),
                  _menuTile(Icons.question_answer_sharp, "FAQ",
                      () => Get.toNamed('/FAQ')),
                  _menuTile(Icons.insights_sharp, "Visualisasi",
                      () => Get.toNamed('/webview')),
                  _menuTile(Icons.history_toggle_off_outlined, "Riwayat Login",
                      () => Get.toNamed('/history-login')),
                  _menuTile(Icons.delete_outline, "Hapus Akun", () async {
                    final confirm = await Get.dialog(AlertDialog(
                      title: Text('Konfirmasi'),
                      content: Text('Apakah kamu yakin ingin menghapus akun?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Get.back(result: true),
                          child: Text('Hapus',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ));

                    if (confirm == true) {
                      await controller
                          .deleteUser(); // ini akan memicu logout dan navigasi
                    }
                  }),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      controller.logout();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.logout, color: Colors.red, size: 28),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              "Keluar dari Akun",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.red, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
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
                      const Icon(Icons.notifications_none, color: Colors.grey),
                  onPressed: () {
                    Get.toNamed('/notifications');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline, color: Colors.teal),
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

  Widget _menuTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showUpdateDialog(BuildContext context, ProfileController controller) {
    final usernameController =
        TextEditingController(text: controller.userData['username']);
    final emailController =
        TextEditingController(text: controller.userData['email']);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Update Profile',
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Update Profile",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: "Username"),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("Batal"),
                        ),
                        TextButton(
                          onPressed: () {
                            if (usernameController.text.trim().isEmpty ||
                                emailController.text.trim().isEmpty) {
                              Get.snackbar("Peringatan",
                                  "Username dan Email tidak boleh kosong");
                              return;
                            }
                            final updatedData = {
                              'username': usernameController.text.trim(),
                              'email': emailController.text.trim(),
                            };
                            controller.updateUser(updatedData);
                            Get.back();
                          },
                          child: const Text("Simpan"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
