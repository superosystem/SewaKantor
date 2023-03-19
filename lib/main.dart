import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/widgets/screen/error_screen.dart';
import 'app/widgets/screen/loading_screen.dart';
import 'app/widgets/screen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(ChattoApplication());
}

class ChattoApplication extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final authController = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder(
              future: Future.delayed(Duration(seconds: 3)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Obx(
                    () => GetMaterialApp(
                      title: "Chatto",
                      initialRoute: bootRoutes(),
                      getPages: AppPages.routes,
                    ),
                  );
                }
                return SplashScreen();
              },
            );
          }
          return LoadingScreen();
        });
  }

  String bootRoutes() {
    String route = authController.skipIntroduction.isTrue
        ? authController.authenticate.isTrue
            ? Routes.HOME
            : Routes.LOGIN
        : Routes.INTRODUCTION;

    return route;
  }
}
