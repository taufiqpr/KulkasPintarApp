import 'package:get/get.dart';
import 'package:fridgeeye/app/data/api_provider.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  final apiProvider = Get.find<ApiProvider>();

  Future<void> login() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar("Error", "Email dan Password harus diisi!");
      return;
    }

    try {
      isLoading(true);
      final response = await apiProvider.login(email.value, password.value);
      Get.snackbar("Success", response['message']);

      String token = response['token'];
      print("JWT Token: $token");

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
