import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/features/auth/view_model/login_view_models.dart';
import 'package:sewakantor/features/splashscreen/splash_screen2.dart';

class SplashScreenOne extends StatefulWidget {
  const SplashScreenOne({super.key});

  @override
  State<SplashScreenOne> createState() => _SplashScreenOneState();
}

class _SplashScreenOneState extends State<SplashScreenOne> {
  @override
  @override
  Widget build(BuildContext context) {
    final providerClient = Provider.of<LoginViewModels>(context, listen: false);
    providerClient.validateTokenIsExist();
    return AnimatedSplashScreen(
      splash: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg_assets/logo.svg',
            ),
          ],
        ),
      ),
      nextScreen: const SplashScreenTwo(),
      splashIconSize: 250,
      //icon size
      duration: 800,
      //durasi splash
      splashTransition: SplashTransition.fadeTransition,
      //animasi transisi splash element
      pageTransitionType:
          PageTransitionType.topToBottom, //animasi transisi ganti page
    );
  }
}
