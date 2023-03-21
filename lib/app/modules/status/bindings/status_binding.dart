import 'package:get/get.dart';

import '../controllers/status_controller.dart';

class StatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatusController>(
      () => StatusController(),
    );
  }
}
