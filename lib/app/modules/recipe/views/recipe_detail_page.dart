import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recipe_controller.dart';

class RecipeDetailPage extends StatelessWidget {
  final int recipeId;
  final controller = Get.find<RecipeController>();

  RecipeDetailPage({super.key, required this.recipeId});

  String extractNutrientFromSummary(String summary, String type) {
    final regexMap = {
      'Calories': RegExp(r'<b>(\d+)\s*calories</b>', caseSensitive: false),
      'Protein': RegExp(r'<b>(\d+)g of protein</b>', caseSensitive: false),
      'Fat': RegExp(r'<b>(\d+)g of fat</b>', caseSensitive: false),
      'Carbohydrates':
          RegExp(r'<b>(\d+)g of carbohydrates</b>', caseSensitive: false),
    };

    final match = regexMap[type]?.firstMatch(summary);
    if (match != null && match.groupCount >= 1) {
      switch (type) {
        case 'Calories':
          return "${match.group(1)} kcal";
        case 'Protein':
        case 'Fat':
        case 'Carbohydrates':
          return "${match.group(1)} g";
      }
    }
    return "-";
  }

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

        final nutrients = detail['nutrition']?['nutrients'] ?? [];
        String getNutrient(String name) {
          final item = nutrients.firstWhere(
            (e) => e['name']?.toLowerCase() == name.toLowerCase(),
            orElse: () => {},
          );

          if (item.isNotEmpty) {
            return "${item['amount']} ${item['unit']}";
          } else {
            return extractNutrientFromSummary(detail['summary'] ?? '', name);
          }
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _nutritionItem(
                              "Health",
                              "${detail['healthScore'] ?? '-'}%",
                              Icons.favorite),
                          _nutritionItem("Protein", getNutrient('Protein'),
                              Icons.fitness_center),
                          _nutritionItem("Calories", getNutrient('Calories'),
                              Icons.local_fire_department),
                          _nutritionItem("Fat", getNutrient('Fat'), Icons.egg),
                        ],
                      ),
                      const SizedBox(height: 24),
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: const Color(0xFFF2F4F7),
                              ),
                              child: TabBar(
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.black54,
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                unselectedLabelStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                                indicator: BoxDecoration(
                                  color: const Color(0xFF2C827F),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                dividerColor: Colors.transparent,
                                tabs: const [
                                  Tab(text: "Bahan-bahan"),
                                  Tab(text: "Cara Memasak"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 300,
                              child: TabBarView(
                                children: [
                                  ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    itemCount: ingredients.length,
                                    itemBuilder: (context, index) {
                                      final item = ingredients[index];
                                      final name = item['original'] ?? '';

                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF2C827F),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${index + 1}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    itemCount: steps.length,
                                    itemBuilder: (context, index) {
                                      final step = steps[index];
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 16),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF2C827F),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${step['number']}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                step['step'] ?? '',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black87,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
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
