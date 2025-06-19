import 'package:flutter/material.dart';
import 'package:fridgeeye/app/modules/recipe/views/recipe_detail_page.dart';
import 'package:get/get.dart';
import '../controllers/recipe_controller.dart';

class RecipeView extends GetView<RecipeController> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:
            const Text('Resep Masakan', style: TextStyle(color: Colors.black)),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          controller.fetchRecipes(value);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Masak apa hari ini?",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.tune),
                          onPressed: () {
                            if (searchController.text.isNotEmpty) {
                              controller.fetchRecipes(searchController.text);
                            }
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kami temukan 2 bahan yang harus segera dipakai!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          controller.fetchRecipes('apple');
                        },
                        child: Text(
                          "Lihat Resep",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                        child: Text("Cek Semua Resep",
                            style: TextStyle(color: Colors.teal))),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // List Resep
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                }

                if (controller.recipes.isEmpty) {
                  return const Center(
                      child: Text('Tidak ada resep ditemukan.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: controller.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = controller.recipes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            recipe['image'] ??
                                'https://via.placeholder.com/150',
                          ),
                          onBackgroundImageError: (_, __) {},
                        ),
                        title: Text(recipe['title'] ?? '-',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Row(
                          children: [
                            Icon(Icons.timer, size: 16),
                            SizedBox(width: 4),
                            Text(recipe['duration']),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () {
                          final id = recipe[
                              'id']; // Pastikan kamu juga simpan ID-nya di list recipe!
                          Get.to(() => RecipeDetailPage(recipeId: id));
                        },
                      ),
                    );
                  },
                );
              }),
            ),
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
                  icon: const Icon(Icons.home, color: Colors.grey),
                  onPressed: () {
                    Get.toNamed('/home');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.restaurant_menu, color: Colors.teal),
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
}
