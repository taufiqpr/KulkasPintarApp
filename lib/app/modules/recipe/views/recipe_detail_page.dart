import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recipe_controller.dart';

class RecipeDetailPage extends StatelessWidget {
  final int recipeId;
  final controller = Get.find<RecipeController>();

  RecipeDetailPage({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    controller.fetchRecipeDetail(recipeId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isDetailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final detail = controller.recipeDetail;

        if (detail.isEmpty) {
          return const Center(child: Text("Data tidak ditemukan."));
        }

        // Ambil nutrisi dari list nutrients
        final nutrients = detail['nutrition']?['nutrients'] ?? [];
        String getNutrient(String name) {
          final item = nutrients.firstWhere(
            (e) => e['name']?.toLowerCase() == name.toLowerCase(),
            orElse: () => {},
          );
          return item.isNotEmpty ? "${item['amount']} ${item['unit']}" : '-';
        }

        final ingredients = detail['extendedIngredients'] ?? [];
        final steps = detail['analyzedInstructions']?.isNotEmpty == true
            ? detail['analyzedInstructions'][0]['steps'] as List
            : [];

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.network(
                      detail['image'] ?? '',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          'https://example.com/default-image.jpg',
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),

                // Card Detail
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 8),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              detail['title'] ?? '',
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Obx(() => IconButton(
                                icon: Icon(
                                  controller.isRecipeLiked(recipeId)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: controller.isRecipeLiked(recipeId)
                                      ? Colors.red
                                      : Colors.grey,
                                  size: 28,
                                ),
                                onPressed: () {
                                  controller.toggleLike({
                                    'id': recipeId,
                                    'title': detail['title'],
                                    'image': detail['image'],
                                    'duration':
                                        '${detail['readyInMinutes']} Menit',
                                  });

                                  if (controller.isRecipeLiked(recipeId)) {
                                    Get.snackbar("Disukai",
                                        "Resep ditambahkan ke favorit ❤️",
                                        backgroundColor: Colors.white,
                                        colorText: Colors.black,
                                        snackPosition: SnackPosition.BOTTOM);
                                  } else {
                                    Get.snackbar("Dihapus",
                                        "Resep dihapus dari favorit 🤍",
                                        backgroundColor: Colors.white,
                                        colorText: Colors.black,
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                },
                              ))
                        ],
                      ),

                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.timer, size: 18),
                          const SizedBox(width: 4),
                          Text("${detail['readyInMinutes']} Menit"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (detail['summary'] ?? '')
                            .replaceAll(RegExp(r'<[^>]*>'), ''),
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),

                      // Nutrition Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _nutritionItem("Carbs", getNutrient('Carbohydrates'),
                              Icons.local_dining),
                          _nutritionItem("Protein", getNutrient('Protein'),
                              Icons.fitness_center),
                          _nutritionItem("Calories", getNutrient('Calories'),
                              Icons.local_fire_department),
                          _nutritionItem("Fat", getNutrient('Fat'), Icons.egg),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Tabs
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xFFF2F4F7),
                              ),
                              child: const TabBar(
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.black54,
                                indicator: BoxDecoration(
                                  color: Color(0xFF2C827F),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                tabs: [
                                  Tab(text: "Bahan-bahan"),
                                  Tab(text: "Cara Memasak"),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 250,
                              child: TabBarView(
                                children: [
                                  // Bahan-bahan
                                  ListView.builder(
                                    padding: const EdgeInsets.only(top: 12),
                                    itemCount: ingredients.length,
                                    itemBuilder: (context, index) {
                                      final item = ingredients[index];
                                      final name = item['original'] ?? '';

                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              const Color(0xFF2C827F),
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                        title: Text(name),
                                      );
                                    },
                                  ),

                                  // Cara Memasak
                                  ListView.builder(
                                    padding: const EdgeInsets.only(top: 12),
                                    itemCount: steps.length,
                                    itemBuilder: (context, index) {
                                      final step = steps[index];
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              const Color(0xFF2C827F),
                                          child: Text(
                                            '${step['number']}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                        title: Text(step['step'] ?? ''),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _nutritionItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.teal),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
