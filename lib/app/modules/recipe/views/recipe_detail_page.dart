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
      appBar: AppBar(title: const Text('Detail Resep')),
      body: Obx(() {
        if (controller.isDetailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final detail = controller.recipeDetail;

        if (detail.isEmpty) {
          return const Center(child: Text("Data tidak ditemukan."));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                detail['image'] ?? '',
                errorBuilder: (context, error, stackTrace) {
                  return Image.network('https://example.com/default-image.jpg');
                },
              ),
              const SizedBox(height: 16),
              Text(
                detail['title'] ?? '',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Waktu Masak: ${detail['readyInMinutes']} menit"),
              Text("Porsi: ${detail['servings']} orang"),
              const SizedBox(height: 8),
              Text(
                (detail['summary'] ?? '').replaceAll(RegExp(r'<[^>]*>'), ''),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      }),
    );
  }
}
