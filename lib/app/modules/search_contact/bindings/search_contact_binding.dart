import 'package:get/get.dart';

import '../controllers/search_contact_controller.dart';

class SearchContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchContactController>(
      () => SearchContactController(),
    );
  }
}
