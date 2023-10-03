import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';

class ResponseDialog {
  /// dialog login success
  static Future<Object?> dialogSuccess({
    context,
    required String description,
  }) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
    return showGeneralDialog(
        context: context,
        barrierLabel: "Response Success",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) {
          return Center(
            child: Container(
              height: AdaptSize.screenHeight * .2,
              width: AdaptSize.screenWidth * .45,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(AdaptSize.pixel10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: MyColor.neutral900,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(1, 3),
                    color: MyColor.primary800,
                    blurRadius: 4,
                  )
                ],
              ),
              child: Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg_assets/check_list.svg',
                      height: AdaptSize.screenHeight * .07,
                      width: AdaptSize.screenWidth * .15,
                    ),
                    SizedBox(
                      height: AdaptSize.screenHeight * .01,
                    ),
                    Text(
                      description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: AdaptSize.pixel12),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        transitionBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: anim,
            child: child,
          );
        });
  }

  /// dialog login failed
  static Future<Object?> dialogFailed({
    context,
    required String title,
    required String description,
  }) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
    return showGeneralDialog(
        context: context,
        barrierLabel: "Response Failed",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) {
          return Center(
            child: Container(
              height: AdaptSize.screenHeight * .4,
              width: AdaptSize.screenWidth * .7,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(AdaptSize.pixel10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: MyColor.neutral900,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(1, 3),
                    color: MyColor.primary800,
                    blurRadius: 4,
                  )
                ],
              ),
              child: Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/image_assets/close_up.png',
                      height: AdaptSize.screenHeight * .2,
                      width: AdaptSize.screenWidth * .5,
                    ),
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: AdaptSize.pixel14),
                    ),
                    SizedBox(
                      height: AdaptSize.screenHeight * .01,
                    ),
                    Text(
                      description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: AdaptSize.pixel12),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        transitionBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: anim,
            child: child,
          );
        });
  }

  /// dialog register success
  static Future<Object?> dialogRegisterSuccess({
    context,
    required String title,
    required String description,
  }) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
    return showGeneralDialog(
        context: context,
        barrierLabel: "Response Failed",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) {
          return Center(
            child: Container(
              height: AdaptSize.screenHeight * .4,
              width: AdaptSize.screenWidth * .7,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(AdaptSize.pixel10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: MyColor.neutral900,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(1, 3),
                    color: MyColor.primary800,
                    blurRadius: 4,
                  )
                ],
              ),
              child: Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/image_assets/register_success_dialog.png',
                      height: AdaptSize.screenHeight * .2,
                      width: AdaptSize.screenWidth * .5,
                    ),
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: AdaptSize.pixel14),
                    ),
                    SizedBox(
                      height: AdaptSize.screenHeight * .01,
                    ),
                    Text(
                      description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: AdaptSize.pixel12),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        transitionBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: anim,
            child: child,
          );
        });
  }

  /// dialog login success
  static Future<Object?> dialogLoginSuccess({
    context,
    required String title,
    required String description,
  }) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
    return showGeneralDialog(
        context: context,
        barrierLabel: "Response Failed",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) {
          return Center(
            child: Container(
              height: AdaptSize.screenHeight * .4,
              width: AdaptSize.screenWidth * .7,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(AdaptSize.pixel10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: MyColor.neutral900,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(1, 3),
                    color: MyColor.primary800,
                    blurRadius: 4,
                  )
                ],
              ),
              child: Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/image_assets/register_success_dialog.png',
                      height: AdaptSize.screenHeight * .2,
                      width: AdaptSize.screenWidth * .5,
                    ),
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: AdaptSize.pixel14),
                    ),
                    SizedBox(
                      height: AdaptSize.screenHeight * .01,
                    ),
                    Text(
                      description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: AdaptSize.pixel12),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        transitionBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: anim,
            child: child,
          );
        });
  }
}
