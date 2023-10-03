import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/data/model/onboard/onboarding_model.dart';
import 'package:sewakantor/features/locations/view_model/get_location_view_model.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/features/onboard/screen/on_board_screen.dart';
import 'package:sewakantor/features/onboard/view_model/onboard_view_models.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/widgets/button_widget.dart';
import 'package:sewakantor/widgets/dialog/custom_dialog.dart';
import 'package:sewakantor/widgets/text_button_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardView extends StatefulWidget {
  const OnBoardView({Key? key}) : super(key: key);

  @override
  State<OnBoardView> createState() => _OnBoardViewState();
}

class _OnBoardViewState extends State<OnBoardView> {
  final PageController _pageController = PageController();
  String text1 = 'Allow ';
  String text2 = 'Better Space App ';
  String text3 =
      'requires permission to access your phone\'s location, used to Calculate the distance of the office from your current position';

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      CustomDialog.singleActionDialogWithoutImage(
          context: context,
          title: 'text permission',
          text1: text1,
          text2: text2,
          text3: text3,
          withTextRich: true,
          onPressed: () async {
            Provider.of<GetLocationViewModel>(context, listen: false)
                .checkAndGetPosition();
            await Provider.of<NavigasiViewModel>(context, listen: false)
                .navigasiBackCheckPermission(context);
          });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// inisialisasi media query
    AdaptSize.size(context: context);

    return Scaffold(
      body: Stack(
        children: [
          /// view
          Consumer<OnboardViewModels>(builder: (context, value, child) {
            return PageView.builder(
              controller: _pageController,
              itemCount: value.onboardList.length,
              onPageChanged: (index) {
                value.getStarted(index == 2);
              },
              itemBuilder: (context, index) {
                final OnboardingModel onboard = value.onboardList[index];
                return OnBoardScreen(
                  image: onboard.image,
                  title: onboard.title,
                  description: onboard.description,
                );
              },
            );
          }),

          /// animasi smooth indicator
          Positioned(
            top: AdaptSize.screenHeight * .56,
            left: AdaptSize.screenWidth * .4,
            right: AdaptSize.screenWidth * .4,
            child: _buildIndicator(),
          ),

          /// button
          Positioned(
            bottom: AdaptSize.screenHeight * .07,
            left: AdaptSize.screenWidth * .05,
            right: AdaptSize.screenWidth * .05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// skip
                textButtonWidget(
                  text: 'Skip',
                  textStyle: Theme.of(context).textTheme.button!.copyWith(
                        color: MyColor.grayLightColor,
                        fontSize: AdaptSize.pixel14,
                      ),
                  onPressed: () {
                    context
                        .read<NavigasiViewModel>()
                        .navigasiToLoginScreen(context);
                  },
                ),

                const Spacer(),

                /// button next
                Consumer<OnboardViewModels>(builder: (context, value, child) {
                  return value.lastPage
                      ? buttonWidget(
                          onPressed: () {
                            context
                                .read<NavigasiViewModel>()
                                .navigasiToLoginScreen(context);
                          },
                          sizeWidth: AdaptSize.screenWidth * .4,
                          sizeheight: AdaptSize.screenHeight * .06,
                          backgroundColor: MyColor.darkBlueColor,
                          borderRadius: BorderRadius.circular(10),
                          child: Text(
                            'Get Started',
                            style: Theme.of(context).textTheme.button!.copyWith(
                                  color: MyColor.whiteColor,
                                  fontSize: AdaptSize.pixel14,
                                ),
                          ),
                        )
                      : buttonWidget(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.ease,
                            );
                          },
                          sizeWidth: AdaptSize.screenWidth * .3,
                          sizeheight: AdaptSize.screenHeight * .06,
                          backgroundColor: MyColor.darkBlueColor,
                          borderRadius: BorderRadius.circular(10),
                          child: Text(
                            'Next',
                            style: Theme.of(context).textTheme.button!.copyWith(
                                  color: MyColor.whiteColor,
                                  fontSize: AdaptSize.pixel14,
                                ),
                          ),
                        );
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    final pageIndex = Provider.of<OnboardViewModels>(context, listen: false);
    AdaptSize.size(context: context);
    return SmoothPageIndicator(
      controller: _pageController,
      count: pageIndex.onboardList.length,
      effect: ExpandingDotsEffect(
        dotWidth: AdaptSize.screenWidth * .021,
        dotHeight: AdaptSize.screenHeight * .011,
        dotColor: MyColor.grayLightColor,
        activeDotColor: MyColor.darkColor,
      ),
    );
  }
}
