import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../../../routes/app_pages.dart';
import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          _pageViewModel(
              "Ease of Communication",
              "You can do it anywhere to make new friends.",
              "assets/lottie/main-laptop-duduk.json"),
          _pageViewModel(
              "Find New Friends",
              "Having lots of friends will make your life better.",
              "assets/lottie/ojek.json"),
          _pageViewModel(
              "Free Application",
              "You don't need to worry, this application is free of any fees.",
              "assets/lottie/payment.json"),
          _pageViewModel(
              "Join Now",
              "Register yourself to be part of us. We will connect with 1000's of other friends.",
              "assets/lottie/register.json"),
        ],
        onDone: () => Get.offAllNamed(Routes.LOGIN),
        showSkipButton: true,
        skip: const Text(
          "Skip",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        next: const Text(
          "Next",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        done: const Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }

  PageViewModel _pageViewModel(String title, String body, String asset) {
    return PageViewModel(
      decoration: const PageDecoration(
          bodyAlignment: Alignment.bottomCenter,
          imageAlignment: Alignment.bottomCenter,
          imagePadding: EdgeInsets.only(top: 50.0, bottom: 0),
          imageFlex: 2),
      title: title,
      body: body,
      image: SizedBox(
        width: Get.width * 20,
        height: Get.width * 20,
        child: Center(
          child: Lottie.asset(asset),
        ),
      ),
    );
  }
}
