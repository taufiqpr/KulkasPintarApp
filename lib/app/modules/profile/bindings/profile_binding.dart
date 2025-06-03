import 'package:fridgeeye/app/data/api_provider.dart';
import 'package:fridgeeye/app/data/user_provider.dart';
import 'package:fridgeeye/app/modules/recipe/controllers/recipe_controller.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiProvider>(() => ApiProvider());
    Get.lazyPut<UserProvider>(() => UserProvider());
    Get.lazyPut<RecipeController>(() => RecipeController());
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
