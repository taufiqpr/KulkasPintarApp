import 'package:get/get.dart';
import 'package:fridgeeye/app/data/user_provider.dart';

class HomeController extends GetxController {
  final userData = {}.obs;
  final _userProvider = Get.find<UserProvider>();

  @override
  void onInit() {
    super.onInit();
    fetchUser(); 
  }

  void fetchUser() async {
    try {
      final user = await _userProvider.getUser();
      userData.value = user;
    } catch (e) {
      print("Error fetch user: $e");
    }
  }
}
