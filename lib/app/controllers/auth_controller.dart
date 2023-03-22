import 'package:chatto/app/routes/app_pages.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var skipIntroduction = false.obs;
  var authenticate = false.obs;

  void loginWithGoogle() {
    Get.offAllNamed(Routes.HOME);
  }

  void logout() {
    Get.offAllNamed(Routes.LOGIN);

  }
}
