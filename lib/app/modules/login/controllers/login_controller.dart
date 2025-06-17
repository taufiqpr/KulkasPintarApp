import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fridgeeye/app/data/api_provider.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  final apiProvider = Get.find<ApiProvider>();
  final box = GetStorage();

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        '465809809624-mtch196j1bvb016kar2l734daqat5kla.apps.googleusercontent.com',
    scopes: ['email'],
  );

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

  Future<void> loginWithGoogle() async {
    try {
      isLoading(true);

      
      await googleSignIn.signOut();


      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        isLoading(false);
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        Get.snackbar("Error", "Gagal mendapatkan token dari Google");
        isLoading(false);
        return;
      }

      final response = await apiProvider.googleSignIn(
        idToken,
        googleUser.displayName,
        googleUser.email,
        googleUser.photoUrl,
      );

      if (response['status'] == 'success') {
        Get.snackbar("Sukses",
            "Login Google berhasil sebagai ${response['user']['email']}");
        print("JWT Token: ${response['token']}");
        Get.offAllNamed('/home');
      } else {
        Get.snackbar("Error", "Login Google gagal");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading(false);
    }
  }


  Future<void> logoutGoogle() async {
    try {
      await googleSignIn.signOut();
      print("Google user logged out");
    } catch (e) {
      print("Error saat logout Google: $e");
    }
  }

  
  Future<void> logout() async {
    await logoutGoogle();
    box.erase(); 
    Get.offAllNamed('/login');
  }
}
