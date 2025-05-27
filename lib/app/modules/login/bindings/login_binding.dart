import 'package:fridgeeye/app/data/api_provider.dart';
import 'package:get/get.dart';
import 'package:fridgeeye/app/modules/login/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiProvider>(() => ApiProvider());
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
