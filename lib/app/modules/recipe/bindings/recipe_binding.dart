import 'package:fridgeeye/app/data/recipe_provider.dart';
import 'package:get/get.dart';

import '../controllers/recipe_controller.dart';

class RecipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecipeProvider>(()=> RecipeProvider());
    Get.lazyPut<RecipeController>(
      () => RecipeController(),
    );
  }
}
