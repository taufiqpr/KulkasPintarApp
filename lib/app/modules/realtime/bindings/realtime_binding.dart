import 'package:get/get.dart';

import '../controllers/realtime_controller.dart';

class RealtimeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RealtimeController>(
      () => RealtimeController(),
    );
  }
}
