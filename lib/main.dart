import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/screen/error_screen.dart';
import 'app/screen/loading_screen.dart';
import 'app/screen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(ChattpApp());
}

class ChattpApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final authController = AuthController();

  ChattpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return GetMaterialApp(
              title: "Chatto",
              initialRoute: Routes.CHANGE_PROFILE,
              getPages: AppPages.routes,
            );
            // return FutureBuilder(
            //   future: Future.delayed(Duration(seconds: 3)),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.done) {
            //       return Obx(
            //         () => GetMaterialApp(
            //           title: "Chatto",
            //           initialRoute: bootRoutes(),
            //           getPages: AppPages.routes,
            //         ),
            //       );
            //     }
            //     return SplashScreen();
            //   },
            // );
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
