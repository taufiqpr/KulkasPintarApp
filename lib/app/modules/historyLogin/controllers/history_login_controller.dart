import 'package:fridgeeye/app/data/api_provider.dart';
import 'package:get/get.dart';

class HistoryLoginController extends GetxController {
  var loginHistory = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory(); 
  }

  void fetchHistory() async {
    isLoading.value = true;
    try {
      final data = await ApiProvider().fetchLoginHistory();
      loginHistory.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat login history");
    } finally {
      isLoading.value = false;
    }
  }
}
