import 'package:fridgeeye/app/data/api_provider.dart';
import 'package:get/get.dart';

import '../controllers/history_login_controller.dart';

class HistoryLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryLoginController>(
      () => HistoryLoginController(),
    );
    Get.lazyPut<ApiProvider>(
      () => ApiProvider(),
    );
  }
}
