import 'package:fridgeeye/app/data/api_provider.dart';
import 'package:fridgeeye/app/data/user_provider.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiProvider>(() => ApiProvider());
    Get.lazyPut<UserProvider>(() => UserProvider());
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
