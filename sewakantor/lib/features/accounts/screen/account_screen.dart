import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/core/page_validators.dart';
import 'package:sewakantor/features/accounts/view_model/account_view_model.dart';
import 'package:sewakantor/features/auth/view_model/login_view_models.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/widgets/default_appbar_widget.dart';
import 'package:sewakantor/widgets/dialog/custom_dialog.dart';
import 'package:sewakantor/widgets/divider_widget.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    final userProfile = Provider.of<LoginViewModels>(context, listen: false);
    Future.delayed(Duration.zero, () {
      userProfile.getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigasiProvider =
        Provider.of<NavigasiViewModel>(context, listen: false);
    final accountProvider =
        Provider.of<AccountViewModel>(context, listen: false);
    final userAccountProvider =
        Provider.of<LoginViewModels>(context, listen: false);
    final userAccountProviderListen =
        Provider.of<LoginViewModels>(context, listen: true);
    if (userAccountProviderListen.userModels == null) {
      Future.delayed(Duration.zero, () {
        userAccountProvider.getProfile();
      });
    }

    return Scaffold(
      appBar: defaultAppbarWidget(
        contexts: context,
        leadIconFunction: () {
          context.read<NavigasiViewModel>().navigasiPop(context);
        },
        centerTitle: true,
        isCenterTitle: true,
        titles: 'Profile',
      ),
      body: NetworkAware(
        offlineChild: const NoConnectionScreen(),
        onlineChild: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: AdaptSize.pixel16,
            left: AdaptSize.screenWidth * .016,
            right: AdaptSize.screenWidth * .016,
          ),
          child: Center(
            child: Column(
              children: [
                /// image profile
                SizedBox(
                  height: AdaptSize.screenWidth * .38,
                  width: AdaptSize.screenWidth * .38,
                  child: Stack(
                    children: [
                      /// image display
                      Consumer<LoginViewModels>(
                          builder: (context, value, child) {
                        return Container(
                          decoration: BoxDecoration(
                            color: MyColor.neutral800,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: MyColor.neutral600,
                              width: AdaptSize.screenHeight * .004,
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: value.imageProfile != null
                                  ? FileImage(value.imageProfile!)
                                  : value.userModels?.userProfileDetails
                                                  .userProfilePicture !=
                                              "" &&
                                          value.userModels?.userProfileDetails
                                                  .userProfilePicture !=
                                              null
                                      ? NetworkImage(value
                                          .userModels!
                                          .userProfileDetails
                                          .userProfilePicture)
                                      : const AssetImage(
                                          'assets/image_assets/default_image_profile.png',
                                        ) as ImageProvider,
                            ),
                          ),
                        );
                      }),

                      /// button pick image
                      Positioned(
                        bottom: AdaptSize.screenHeight * .01,
                        right: 0,
                        child: Consumer<LoginViewModels>(
                            builder: (context, value, child) {
                          return Container(
                            height: AdaptSize.screenWidth * .1,
                            width: AdaptSize.screenWidth * .1,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: MyColor.neutral600,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: MyColor.neutral900,
                                width: AdaptSize.screenWidth * .004,
                              ),
                            ),
                            child: InkWell(
                              /// unfinal
                              onTap: () async {
                                value.pickImageProfile(context,
                                    'Your profile has been updated successfully !',
                                    () {
                                  debugPrint("${value.pathImage}");

                                  /// note
                                  value.setUserProfilePicture(
                                      filePath: value.pathImage,
                                      fileName: value.pathImage);
                                  Future.delayed(Duration(seconds: 1), () {
                                    Navigator.pop(context);
                                  });
                                });
                              },
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: MyColor.neutral900,
                                size: AdaptSize.pixel18,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: AdaptSize.screenHeight * .008,
                ),

                /// username
                Consumer<LoginViewModels>(builder: (context, value, child) {
                  return Text(
                    value.userModels?.userProfileDetails.userName ??
                        'Loading..',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontSize: AdaptSize.pixel16,
                          color: MyColor.neutral200,
                        ),
                  );
                }),

                SizedBox(
                  height: AdaptSize.screenHeight * .004,
                ),

                /// email user
                Text(
                  userAccountProviderListen.userModels?.userEmail ??
                      "Loading..",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: AdaptSize.pixel14,
                        color: MyColor.neutral400,
                      ),
                ),

                /// item list
                itemContainer(
                  MediaQuery.removePadding(
                    context: context,
                    removeBottom: true,
                    removeTop: true,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: accountProvider.accountItem.length,
                        itemBuilder: (context, items) {
                          return menuItemAccount(
                              context: context,
                              onTap: () {
                                if (accountProvider.accountItem[items][2] ==
                                    3) {
                                  CustomDialog.doubleActionDialog(
                                    context: context,
                                    title: 'Are you sure want to Logout ?',
                                    imageAsset:
                                        'assets/svg_assets/heart_break.svg',
                                    onTap1: () async {
                                      await userAccountProvider
                                          .logoutWithTokens();
                                      isLogoutSuccess(
                                          context: context,
                                          logoutStatusCode:
                                              userAccountProviderListen
                                                  .logoutStatusCode,
                                          logoutConnectionState:
                                              userAccountProviderListen
                                                  .apiLogoutState);
                                    },
                                    onTap2: () {
                                      navigasiProvider.navigasiPop(context);
                                    },
                                  );
                                } else {
                                  navigasiProvider.navigasiSettingItem(context,
                                      accountProvider.accountItem[items][2]);
                                }
                              },
                              icon: accountProvider.accountItem[items][1],
                              itemName: accountProvider.accountItem[items][0],
                              item: items);
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// item canvas
  Widget itemContainer(Widget child) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AdaptSize.screenHeight * .016),
      margin: EdgeInsets.only(top: AdaptSize.screenHeight * .016),
      decoration: BoxDecoration(
        color: MyColor.neutral900,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: MyColor.neutral500.withOpacity(.6),
              blurStyle: BlurStyle.solid,
              blurRadius: 3)
        ],
      ),
      child: child,
    );
  }

  /// main menu item list on account screen
  Widget menuItemAccount({
    context,
    Function()? onTap,
    required IconData icon,
    required String itemName,
    required int item,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(icon, size: AdaptSize.pixel22),
              SizedBox(
                width: AdaptSize.screenWidth * .016,
              ),
              Text(
                itemName,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: AdaptSize.pixel14,
                    ),
              ),
              const Spacer(),
              item == 3
                  ? const SizedBox()
                  : Icon(
                      Icons.arrow_forward_ios,
                      color: MyColor.neutral500,
                      size: AdaptSize.pixel20,
                    ),
            ],
          ),
        ),
        SizedBox(
          height: AdaptSize.screenHeight * .01,
        ),
        item == 3
            ? const SizedBox()
            : dividerWdiget(
                width: double.infinity,
                opacity: .1,
              ),
        item == 3
            ? const SizedBox()
            : SizedBox(
                height: AdaptSize.screenHeight * .01,
              ),
      ],
    );
  }
}
