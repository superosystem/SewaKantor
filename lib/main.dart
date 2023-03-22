import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(ChattpApp());
}

class ChattpApp extends StatelessWidget {
  final authController = Get.put(AuthController(), permanent: true);

  ChattpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Obx(
            () => GetMaterialApp(
              title: "Chatto",
              initialRoute: _bootRoutes(),
              getPages: AppPages.routes,
            ),
          );
        }
        return FutureBuilder(
          future: authController.bootInitialized(),
          builder: (context, snapshot) => SplashScreen(),
        );
      },
    );
  }

  String _bootRoutes() {
    String route = authController.skipIntroduction.isTrue
        ? authController.authenticate.isTrue
            ? Routes.HOME
            : Routes.LOGIN
        : Routes.INTRODUCTION;
    return route;
  }
}
