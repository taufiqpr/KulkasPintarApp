import 'package:fridgeeye/app/data/user_provider.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final userProvider = Get.find<UserProvider>();
  var userData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      final data = await userProvider.getUser();
      userData.value = data;
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", e.toString());
    }
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    final userId = userData['_id']; 
    if (userId == null) {
      Get.snackbar("Error", "ID user tidak ditemukan");
      return;
    }

    final success = await userProvider.updateUser(userId, data);
    if (success) {
      fetchUser();
      Get.snackbar("Berhasil", "Data berhasil diupdate");
    } else {
      Get.snackbar("Gagal", "Gagal update data");
    }
  }

  Future<void> deleteUser() async {
    final success = await userProvider.deleteUser();
    if (success) {
      Get.offAllNamed('/login');
      Get.snackbar("Akun Dihapus", "Sampai jumpa lagi!");
    } else {
      Get.snackbar("Gagal", "Gagal menghapus akun");
    }
  }

  void logout() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Yakin ingin logout?",
      textCancel: "Batal",
      textConfirm: "Logout",
      confirmTextColor: Get.theme.colorScheme.onPrimary,
      onConfirm: () {
        Get.offAllNamed('/login');
      },
    );
  }
}
