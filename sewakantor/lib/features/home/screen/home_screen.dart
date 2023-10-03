import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/features/auth/view_model/login_view_models.dart';
import 'package:sewakantor/features/home/widget/home_screen_widget/all_populer.dart';
import 'package:sewakantor/features/home/widget/home_screen_widget/carousel_widget.dart';
import 'package:sewakantor/features/home/widget/search_field.dart';
import 'package:sewakantor/features/locations/view_model/get_location_view_model.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/features/offices/screen/all_offices/all_coworking_screen.dart';
import 'package:sewakantor/features/offices/screen/all_offices/all_meeting_room_screen.dart';
import 'package:sewakantor/features/offices/screen/all_offices/all_recomendation_screen.dart';
import 'package:sewakantor/features/offices/screen/all_offices/all_rent_office_screen.dart';
import 'package:sewakantor/features/offices/view_model/office_view_models.dart';
import 'package:sewakantor/features/offices/widget/horizontal_card_home.dart';
import 'package:sewakantor/features/offices/widget/vertical_card_home.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/utils/enums.dart';
import 'package:sewakantor/utils/remove_trailing_zero.dart';
import 'package:sewakantor/widgets/card_shimmer_widget.dart';
import 'package:sewakantor/widgets/divider_widget.dart';
import 'package:sewakantor/widgets/shimmer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final providerOfUser = Provider.of<LoginViewModels>(context, listen: false);
    final userAccountProvider =
        Provider.of<LoginViewModels>(context, listen: false);
    if (userAccountProvider.userModels == null) {
      Future.delayed(Duration.zero, () {
        userAccountProvider.getProfile();
      });
    }

    final locationProvider =
        Provider.of<GetLocationViewModel>(context, listen: false);

    if (locationProvider.posisi == null) {
      locationProvider.checkAndGetPosition();
    }

    final officeData = Provider.of<OfficeViewModels>(context, listen: false);
    Future.delayed(Duration.zero, () {
      if (officeData.listOfCoworkingSpace.isEmpty ||
          officeData.listOfMeetingRoom.isEmpty ||
          officeData.listOfOfficeRoom.isEmpty ||
          officeData.listOfOfficeByRecommendation.isEmpty ||
          providerOfUser.userModels == null) {
        officeData.fetchCoworkingSpace();
        officeData.fetchOfficeRoom();
        officeData.fetchMeetingRoom();
        officeData.fetchOfficeByRecommendation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    final locationProvider =
        Provider.of<GetLocationViewModel>(context, listen: false);

    return Scaffold(
      body: NetworkAware(
        offlineChild: const NoConnectionScreen(),
        onlineChild: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
              top: AdaptSize.paddingTop,
              left: AdaptSize.screenWidth * .016,
              right: AdaptSize.screenWidth * .016,
            ),
            child: Column(
              children: [
                /// header
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    left: AdaptSize.screenWidth * .01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer<LoginViewModels>(
                                builder: (context, value, child) {
                              return Text(
                                value.userModels != null &&
                                        value.userModels?.userProfileDetails !=
                                            null
                                    ? "Hi ${value.userModels!.userProfileDetails.userName}"
                                    : 'Hi User',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(fontSize: AdaptSize.pixel18),
                              );
                            }),
                            Text(
                              'Find your best workspace!',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontSize: AdaptSize.pixel17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),

                      /// notification
                      IconButton(
                        onPressed: () {
                          context
                              .read<NavigasiViewModel>()
                              .navigasiToNotification(context);
                        },
                        icon: Icon(
                          Icons.notifications_none,
                          size: AdaptSize.pixel20,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: AdaptSize.screenHeight * .016,
                ),

                /// search text field
                searchPlace(
                  /// search field
                  context: context,
                  hintText: 'Where do you want to work today?',
                  onTap: () {
                    context
                        .read<NavigasiViewModel>()
                        .navigasiToSearchSpaces(context);
                  },
                  prefixIcon: Icon(
                    Icons.search,
                    color: MyColor.darkColor.withOpacity(.8),
                  ),
                  readOnly: true,
                ),

                SizedBox(
                  height: AdaptSize.screenHeight * .016,
                ),

                /// promo
                carouselWidget(context),

                SizedBox(
                  height: AdaptSize.screenHeight * .005,
                ),

                /// divider
                dividerWdiget(
                  width: double.infinity,
                  opacity: .1,
                ),

                SizedBox(
                  height: AdaptSize.screenHeight * .008,
                ),

                /// all coworking text
                allSpaces(context, 'Popular Coworking Space', () {
                  context.read<NavigasiViewModel>().navigasiAllOffice(
                        context,
                        const AllCoworkingScreen(),
                      );
                }),

                SizedBox(
                  height: AdaptSize.screenHeight * .016,
                ),

                ///  coworking space
                Consumer<OfficeViewModels>(builder: (context, value, child) {
                  if (value.connectionState == stateOfConnections.isLoading) {
                    return shimmerLoading(
                      child: commonShimmerLoadWidget(
                        sizeHeight: AdaptSize.screenWidth / 2800 * 2000,
                        sizeWidth: double.infinity,
                      ),
                    );
                  }
                  if (value.connectionState == stateOfConnections.isReady) {
                    return SizedBox(
                      height: AdaptSize.screenWidth / 2800 * 2000,
                      width: double.infinity,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: value.listOfCoworkingSpace.length >= 5
                              ? 5
                              : value.listOfCoworkingSpace.length,
                          itemBuilder: (context, index) {
                            return verticalCardHome(
                              context: context,
                              onTap: () {
                                if (value.connectionState ==
                                    stateOfConnections.isReady) {
                                  context
                                      .read<NavigasiViewModel>()
                                      .navigasiToDetailSpace(
                                        context: context,
                                        officeId: value
                                            .listOfCoworkingSpace[index]
                                            .officeID,
                                      );
                                }
                              },
                              officeImage: value
                                  .listOfCoworkingSpace[index].officeLeadImage,
                              officeName:
                                  value.listOfCoworkingSpace[index].officeName,
                              officeLocation:
                                  '${value.listOfCoworkingSpace[index].officeLocation.district}, ${value.listOfCoworkingSpace[index].officeLocation.city}',
                              officeStarRanting: value
                                  .listOfCoworkingSpace[index].officeStarRating
                                  .toString(),
                              officeApproxDistance:
                                  locationProvider.posisi != null
                                      ? locationProvider
                                          .homeScreenCalculateDistances(
                                              locationProvider.lat,
                                              locationProvider.lng,
                                              value
                                                  .listOfCoworkingSpace[index]
                                                  .officeLocation
                                                  .officeLatitude,
                                              value
                                                  .listOfCoworkingSpace[index]
                                                  .officeLocation
                                                  .officeLongitude)!
                                      : '-',
                              officePersonCapacity: value
                                  .listOfCoworkingSpace[index]
                                  .officePersonCapacity
                                  .toString()
                                  .replaceAll(RemoveTrailingZero.regex, ''),
                              officeArea: value
                                  .listOfCoworkingSpace[index].officeArea
                                  .toString()
                                  .replaceAll(RemoveTrailingZero.regex, ''),
                              hours: '/Hours',
                              officePricing: value.listOfCoworkingSpace[index]
                                  .officePricing.officePrice,
                            );
                          }),
                    );
                  }
                  if (value.connectionState == stateOfConnections.isFailed) {
                    return commonShimmerFailedLoadWidget(
                      context: context,
                      sizeHeight: AdaptSize.screenWidth / 2800 * 2000,
                      sizeWidth: double.infinity,
                    );
                  }
                  return SizedBox(
                    height: AdaptSize.screenWidth / 2800 * 2000,
                    width: double.infinity,
                  );
                }),

                SizedBox(
                  height: AdaptSize.screenHeight * .008,
                ),

                /// all office rent text
                allSpaces(context, 'Office for Rent', () {
                  context.read<NavigasiViewModel>().navigasiAllOffice(
                        context,
                        const AllRentOfficeScreen(),
                      );
                }),

                SizedBox(
                  height: AdaptSize.screenHeight * .016,
                ),

                /// office rent space
                Consumer<OfficeViewModels>(builder: (context, value, child) {
                  if (value.connectionState == stateOfConnections.isLoading) {
                    return shimmerLoading(
                      child: commonShimmerLoadWidget(
                        sizeHeight: AdaptSize.screenWidth / 2800 * 2000,
                        sizeWidth: double.infinity,
                      ),
                    );
                  }
                  if (value.connectionState == stateOfConnections.isReady) {
                    return SizedBox(
                      height: AdaptSize.screenWidth / 2800 * 2000,
                      width: double.infinity,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: value.listOfOfficeRoom.length >= 5
                              ? 5
                              : value.listOfOfficeRoom.length,
                          itemBuilder: (context, index) {
                            return verticalCardHome(
                              context: context,
                              onTap: () {
                                if (value.connectionState ==
                                    stateOfConnections.isReady) {
                                  context
                                      .read<NavigasiViewModel>()
                                      .navigasiToDetailSpace(
                                        context: context,
                                        officeId: value
                                            .listOfOfficeRoom[index].officeID,
                                      );
                                }
                              },
                              officeImage:
                                  value.listOfOfficeRoom[index].officeLeadImage,
                              officeName:
                                  value.listOfOfficeRoom[index].officeName,
                              officeLocation:
                                  '${value.listOfOfficeRoom[index].officeLocation.district}, ${value.listOfOfficeRoom[index].officeLocation.city}',
                              officeStarRanting: value
                                  .listOfOfficeRoom[index].officeStarRating
                                  .toString(),
                              officeApproxDistance:
                                  locationProvider.posisi != null
                                      ? locationProvider
                                          .homeScreenCalculateDistances(
                                              locationProvider.lat,
                                              locationProvider.lng,
                                              value
                                                  .listOfOfficeRoom[index]
                                                  .officeLocation
                                                  .officeLatitude,
                                              value
                                                  .listOfOfficeRoom[index]
                                                  .officeLocation
                                                  .officeLongitude)!
                                      : '-',
                              officePersonCapacity: value
                                  .listOfOfficeRoom[index].officePersonCapacity
                                  .toString()
                                  .replaceAll(RemoveTrailingZero.regex, ''),
                              officeArea: value
                                  .listOfOfficeRoom[index].officeArea
                                  .toString()
                                  .replaceAll(RemoveTrailingZero.regex, ''),
                              hours: '/Month',
                              officePricing: value.listOfOfficeRoom[index]
                                  .officePricing.officePrice,
                            );
                          }),
                    );
                  }
                  if (value.connectionState == stateOfConnections.isFailed) {
                    return commonShimmerFailedLoadWidget(
                      context: context,
                      sizeHeight: AdaptSize.screenWidth / 2800 * 2000,
                      sizeWidth: double.infinity,
                    );
                  }
                  return SizedBox(
                    height: AdaptSize.screenWidth / 2800 * 2000,
                    width: double.infinity,
                  );
                }),

                SizedBox(
                  height: AdaptSize.screenHeight * .008,
                ),

                /// all meeting room card
                allSpaces(context, 'Meeting Rooms', () {
                  context.read<NavigasiViewModel>().navigasiAllOffice(
                        context,
                        const AllMeetingRoomScreen(),
                      );
                }),

                SizedBox(
                  height: AdaptSize.screenHeight * .016,
                ),

                /// meeting space
                Consumer<OfficeViewModels>(builder: (context, value, child) {
                  if (value.connectionState == stateOfConnections.isLoading) {
                    return shimmerLoading(
                      child: commonShimmerLoadWidget(
                          sizeHeight: AdaptSize.screenWidth / 2800 * 2000,
                          sizeWidth: double.infinity),
                    );
                  }
                  if (value.connectionState == stateOfConnections.isReady) {
                    return SizedBox(
                      height: AdaptSize.screenWidth / 2800 * 2000,
                      width: double.infinity,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: value.listOfMeetingRoom.length >= 5
                              ? 5
                              : value.listOfMeetingRoom.length,
                          itemBuilder: (context, index) {
                            return verticalCardHome(
                              context: context,
                              onTap: () {
                                if (value.connectionState ==
                                    stateOfConnections.isReady) {
                                  context
                                      .read<NavigasiViewModel>()
                                      .navigasiToDetailSpace(
                                        context: context,
                                        officeId: value
                                            .listOfMeetingRoom[index].officeID,
                                      );
                                }
                              },
                              officeImage: value
                                  .listOfMeetingRoom[index].officeLeadImage,
                              officeName:
                                  value.listOfMeetingRoom[index].officeName,
                              officeLocation:
                                  '${value.listOfMeetingRoom[index].officeLocation.district}, ${value.listOfMeetingRoom[index].officeLocation.city}',
                              officeStarRanting: value
                                  .listOfMeetingRoom[index].officeStarRating
                                  .toString(),
                              officeApproxDistance:
                                  locationProvider.posisi != null
                                      ? locationProvider
                                          .homeScreenCalculateDistances(
                                              locationProvider.lat,
                                              locationProvider.lng,
                                              value
                                                  .listOfMeetingRoom[index]
                                                  .officeLocation
                                                  .officeLatitude,
                                              value
                                                  .listOfMeetingRoom[index]
                                                  .officeLocation
                                                  .officeLongitude)!
                                      : '-',
                              officePersonCapacity: value
                                  .listOfMeetingRoom[index].officePersonCapacity
                                  .toString()
                                  .replaceAll(RemoveTrailingZero.regex, ''),
                              officeArea: value
                                  .listOfMeetingRoom[index].officeArea
                                  .toString()
                                  .replaceAll(RemoveTrailingZero.regex, ''),
                              hours: '/Hours',
                              officePricing: value.listOfMeetingRoom[index]
                                  .officePricing.officePrice,
                            );
                          }),
                    );
                  }
                  if (value.connectionState == stateOfConnections.isFailed) {
                    return commonShimmerFailedLoadWidget(
                      context: context,
                      sizeHeight: AdaptSize.screenWidth / 2800 * 2000,
                      sizeWidth: double.infinity,
                    );
                  }
                  return SizedBox(
                    height: AdaptSize.screenWidth / 2800 * 2000,
                    width: double.infinity,
                  );
                }),

                SizedBox(
                  height: AdaptSize.screenHeight * .008,
                ),

                /// divider
                dividerWdiget(
                  width: double.infinity,
                  opacity: .1,
                ),

                SizedBox(
                  height: AdaptSize.screenHeight * .008,
                ),

                /// text recomended spaces
                allSpaces(context, 'Recommendation', () {
                  context.read<NavigasiViewModel>().navigasiAllOffice(
                        context,
                        const AllRecomendationOfficeScreen(),
                      );
                }),

                SizedBox(
                  height: AdaptSize.screenHeight * .016,
                ),

                /// recomended spaces
                Consumer<OfficeViewModels>(builder: (context, value, child) {
                  if (value.connectionState == stateOfConnections.isLoading) {
                    return shimmerLoading(
                      child: commonShimmerLoadWidget(
                        sizeHeight: AdaptSize.screenWidth / 1000 * 360,
                        sizeWidth: double.infinity,
                      ),
                    );
                  }
                  if (value.connectionState == stateOfConnections.isReady) {
                    return MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              value.listOfOfficeByRecommendation.length >= 5
                                  ? 5
                                  : value.listOfOfficeByRecommendation.length,
                          itemBuilder: (context, index) {
                            return horizontalCardHome(
                              context: context,
                              onTap: () {
                                if (value.connectionState ==
                                    stateOfConnections.isReady) {
                                  context
                                      .read<NavigasiViewModel>()
                                      .navigasiToDetailSpace(
                                        context: context,
                                        officeId: value
                                            .listOfOfficeByRecommendation[index]
                                            .officeID,
                                      );
                                }
                              },
                              officeImage: value
                                  .listOfOfficeByRecommendation[index]
                                  .officeLeadImage,
                              officeName: value
                                  .listOfOfficeByRecommendation[index]
                                  .officeName,
                              officeLocation:
                                  '${value.listOfOfficeByRecommendation[index].officeLocation.district}, ${value.listOfOfficeByRecommendation[index].officeLocation.city}',
                              officeStarRanting: value
                                  .listOfOfficeByRecommendation[index]
                                  .officeStarRating
                                  .toString(),
                              officeApproxDistance:
                                  locationProvider.posisi != null
                                      ? locationProvider
                                          .homeScreenCalculateDistances(
                                              locationProvider.lat!,
                                              locationProvider.lng!,
                                              value
                                                  .listOfOfficeByRecommendation[
                                                      index]
                                                  .officeLocation
                                                  .officeLatitude,
                                              value
                                                  .listOfOfficeByRecommendation[
                                                      index]
                                                  .officeLocation
                                                  .officeLongitude)!
                                      : '-',
                              officePersonCapacity: value
                                  .listOfOfficeByRecommendation[index]
                                  .officePersonCapacity
                                  .toString()
                                  .replaceAll(RemoveTrailingZero.regex, ''),
                              officeArea: value
                                  .listOfOfficeByRecommendation[index]
                                  .officeArea
                                  .toString()
                                  .replaceAll(RemoveTrailingZero.regex, ''),
                              hours: '/Hours',
                              officePricing: value
                                  .listOfOfficeByRecommendation[index]
                                  .officePricing
                                  .officePrice,
                            );
                          }),
                    );
                  }
                  if (value.connectionState == stateOfConnections.isFailed) {
                    return commonShimmerFailedLoadWidget(
                      context: context,
                      sizeHeight: AdaptSize.screenWidth / 1000 * 360,
                      sizeWidth: double.infinity,
                    );
                  }
                  return const SizedBox();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
