import 'package:get/get.dart';

import '../controllers/add_fruit_controller.dart';

class AddFruitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddFruitController>(
      () => AddFruitController(),
    );
  }
}
