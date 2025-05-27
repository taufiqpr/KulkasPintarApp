import 'package:get/get.dart';
import 'package:fridgeeye/app/data/api_provider.dart';

class RegisterController extends GetxController {
  final apiProvider = Get.find<ApiProvider>();
  var isLoading = false.obs;

  var email = ''.obs;
  var username = ''.obs;
  var password = ''.obs;

  Future<void> registerUser(String user, String mail, String pass) async {
    if (user.isEmpty || mail.isEmpty || pass.isEmpty) {
      Get.snackbar("Error", "Semua field harus diisi");
      return;
    }

    isLoading(true);
    final message = await apiProvider.registerUser(mail, user, pass);

    if (message == null) {
      username.value = user;
      email.value = mail;
      password.value = pass;

      Get.snackbar("OTP Terkirim", "Silakan cek email Anda");
      Get.toNamed('/verify-otp');
    } else {
      Get.snackbar("Error", message);
    }
    isLoading(false);
  }

  Future<void> verifyOtp(String otp) async {
    if (otp.isEmpty) {
      Get.snackbar("Error", "OTP harus diisi");
      return;
    }

    isLoading(true);
    final message = await apiProvider.verifyOtp(email.value, otp);

    if (message == null) {
      Get.snackbar("Sukses", "Registrasi Berhasil!");
      Get.offAllNamed('/login');
    } else {
      Get.snackbar("Gagal", message);
    }

    isLoading(false);
  }
}
