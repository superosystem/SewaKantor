import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/core/parsers.dart';
import 'package:sewakantor/data/model/offices/office_dummy_data.dart';
import 'package:sewakantor/data/model/offices/office_dummy_models.dart';
import 'package:sewakantor/features/locations/view_model/get_location_view_model.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/features/offices/view_model/office_view_models.dart';
import 'package:sewakantor/features/offices/widget/card_review_widget.dart';
import 'package:sewakantor/features/reviews/view_model/review_view_model.dart';
import 'package:sewakantor/features/wishlists/view_model/whislist_view_model.dart';
import 'package:sewakantor/src/model/user_whislist/user_whislist.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/utils/enums.dart';
import 'package:sewakantor/utils/remove_trailing_zero.dart';
import 'package:sewakantor/widgets/bottom_sheed_widget.dart';
import 'package:sewakantor/widgets/button_widget.dart';
import 'package:sewakantor/widgets/card_shimmer_widget.dart';
import 'package:sewakantor/widgets/divider_widget.dart';
import 'package:sewakantor/widgets/icon_with_label.dart';
import 'package:sewakantor/widgets/shimmer_widget.dart';

import '../../../../utils/custom_icons.dart';

class OfficeDetailScreen extends StatefulWidget {
  final String officeID;

  const OfficeDetailScreen({
    super.key,
    required this.officeID,
  });

  @override
  State<OfficeDetailScreen> createState() => _OfficeDetailScreenState();
}

class _OfficeDetailScreenState extends State<OfficeDetailScreen> {
  @override
  void initState() {
    super.initState();
    final reviewProvider =
        Provider.of<ReviewViewModels>(context, listen: false);
    if (reviewProvider.listOfReviewOffice.isEmpty) {
      Future.delayed(Duration.zero, () {
        reviewProvider.getReviewByOffice(officeId: widget.officeID);
      });
    }

    final locationProvider =
        Provider.of<GetLocationViewModel>(context, listen: false);

    if (locationProvider.posisi == null) {
      locationProvider.checkAndGetPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dummyDataProviders =
        Provider.of<OfficeDummyDataViewModels>(context, listen: false);
    dummyDataProviders.addRecord(12);
    List<OfficeModels> listOfDummyOffice =
        dummyDataProviders.listOfOfficeModels;

    final officeListAlloffice =
        Provider.of<OfficeViewModels>(context, listen: false);
    List<OfficeModels> listOfAllOfficeContainers =
        officeListAlloffice.listOfAllOfficeModels;

    final officeById = officeModelFilterByOfficeId(
        listOfModels: listOfAllOfficeContainers,
        requestedOfficeId: widget.officeID);

    final officeReviewsProvider =
        Provider.of<ReviewViewModels>(context, listen: false);
    final reviewById = officeReviewsProvider.listOfReviewOffice;
    // .where(
    //     (element) => element.reviewedOfficeId == int.parse(widget.officeID))
    // .toList();

    return Scaffold(
      body: NetworkAware(
        offlineChild: const NoConnectionScreen(),
        onlineChild: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: AdaptSize.screenWidth * .016,
                    right: AdaptSize.screenWidth * .016,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// image header
                      CachedNetworkImage(
                        imageUrl: officeById?.officeLeadImage != null &&
                                officeById?.officeLeadImage != ''
                            ? officeById!.officeLeadImage
                            : listOfDummyOffice[0].officeLeadImage,
                        imageBuilder: (context, imageProvider) => Container(
                          height: AdaptSize.screenWidth / 1.3,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageProvider,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  onPressed: () {
                                    context
                                        .read<NavigasiViewModel>()
                                        .navigasiPop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    size: AdaptSize.pixel22,
                                    color: MyColor.neutral900,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Consumer<WhislistViewModel>(
                                    builder: (context, value, child) {
                                  return IconButton(
                                    onPressed: () {
                                      final addNewWhislist = UserWhislistModel(
                                        officeId: DateTime.now()
                                            .millisecondsSinceEpoch,
                                        officeName: officeById?.officeName ??
                                            listOfDummyOffice[0].officeName,
                                        officeRanting:
                                            officeById?.officeStarRating ??
                                                listOfDummyOffice[0]
                                                    .officeStarRating,
                                        officeImage:
                                            officeById?.officeLeadImage ??
                                                listOfDummyOffice[0]
                                                    .officeLeadImage,
                                        officeLocation:
                                            '${officeById?.officeLocation.district}, ${officeById?.officeLocation.city}',
                                        officeType: officeById?.officeType ??
                                            listOfDummyOffice[0].officeType,
                                      );

                                      value.addWhistlistOffice(addNewWhislist);
                                    },
                                    icon: Icon(
                                      value.onTaped
                                          ? Icons.bookmark
                                          : Icons.bookmark_outline,
                                      size: AdaptSize.pixel22,
                                      color: value.onTaped
                                          ? MyColor.secondary300
                                          : MyColor.neutral900,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        placeholder: (context, url) => shimmerLoading(
                          child: commonShimmerLoadWidget(),
                        ),
                        errorWidget: (context, url, error) =>
                            commonShimmerFailedLoadWidget(
                          context: context,
                          sizeHeight: AdaptSize.screenWidth / 1.3,
                          sizeWidth: double.infinity,
                        ),
                      ),

                      SizedBox(
                        height: AdaptSize.pixel8,
                      ),

                      /// gird image
                      SizedBox(
                        height: AdaptSize.screenWidth / 3.5,
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: officeById?.officeGridImage.length ??
                              listOfDummyOffice[0].officeGridImage.length,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: officeById?.officeGridImage[index] !=
                                          null &&
                                      officeById?.officeGridImage[index] != ''
                                  ? officeById?.officeGridImage[index]
                                  : listOfDummyOffice[0].officeGridImage[index],
                              imageBuilder: (context, imageProvider) => Padding(
                                padding:
                                    EdgeInsets.only(right: AdaptSize.pixel8),
                                child: SizedBox(
                                  height: AdaptSize.screenWidth / 3.25,
                                  width: AdaptSize.screenWidth / 3.25,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => shimmerLoading(
                                child: commonShimmerLoadWidget(
                                  sizeWidth: AdaptSize.screenWidth / 3.25,
                                  sizeHeight: AdaptSize.screenWidth / 3.25,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  commonShimmerFailedLoadWidget(
                                context: context,
                                sizeWidth: AdaptSize.screenWidth / 3.25,
                                sizeHeight: AdaptSize.screenWidth / 3.25,
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(
                        height: AdaptSize.pixel8,
                      ),

                      /// text header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              officeById?.officeName ??
                                  listOfDummyOffice[0].officeName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontSize: AdaptSize.pixel22),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: AdaptSize.screenWidth / 7.2,
                            height: AdaptSize.screenWidth / 15,
                            decoration: BoxDecoration(
                              color: MyColor.neutral300,
                              border: Border.all(
                                  width: 1, color: MyColor.neutral300),
                              borderRadius: BorderRadius.circular(42),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: MyColor.starYellow,
                                  size: AdaptSize.pixel16,
                                ),
                                Text(
                                  officeById?.officeStarRating.toString() ??
                                      "${listOfDummyOffice[0].officeStarRating}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: MyColor.neutral900,
                                          fontSize: AdaptSize.pixel14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: AdaptSize.pixel8,
                      ),

                      /// keterangan lokasi
                      Row(
                        children: [
                          Icon(
                            Icons.domain,
                            color: MyColor.neutral100,
                            size: AdaptSize.pixel20,
                          ),
                          SizedBox(
                            width: AdaptSize.screenWidth * .005,
                          ),
                          Expanded(
                            child: Text(
                              '${officeById?.officeLocation.district ?? listOfDummyOffice[0].officeLocation.city}, ${officeById?.officeLocation.city ?? listOfDummyOffice[0].officeLocation.district}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: MyColor.neutral100,
                                    fontSize: AdaptSize.pixel14,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),

                      /// office detail description
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// location
                          Consumer<GetLocationViewModel>(
                              builder: (context, value, child) {
                            return IconWithLabel().asrow(
                                contexts: context,
                                usedIcon: Icons.location_on_outlined,
                                labelText: value.posisi != null
                                    ? value.calculateDistances(
                                        value.lat,
                                        value.lng,
                                        officeById
                                            ?.officeLocation.officeLatitude,
                                        officeById
                                            ?.officeLocation.officeLongitude,
                                      )!
                                    : '-',
                                spacer: AdaptSize.pixel4);
                          }),

                          const Spacer(),

                          /// office area
                          SvgPicture.asset(
                            'assets/svg_assets/ruler.svg',
                            height: AdaptSize.pixel18,
                          ),
                          SizedBox(
                            width: AdaptSize.pixel4,
                          ),
                          Text(
                            '${officeById?.officeArea.toString().replaceAll(RemoveTrailingZero.regex, '') ?? listOfDummyOffice[0].officeArea.toString()}m2',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: MyColor.neutral100,
                                    fontSize: AdaptSize.pixel14),
                          ),

                          const Spacer(),

                          /// totoal checkin
                          SvgPicture.asset(
                            'assets/svg_assets/available.svg',
                            height: AdaptSize.pixel18,
                          ),
                          SizedBox(
                            width: AdaptSize.pixel4,
                          ),
                          Text(
                              officeById?.officePersonCapacity
                                      .toString()
                                      .replaceAll(
                                          RemoveTrailingZero.regex, '') ??
                                  listOfDummyOffice[0]
                                      .officePersonCapacity
                                      .toString()
                                      .replaceAll(RemoveTrailingZero.regex, ''),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: MyColor.neutral100,
                                      fontSize: AdaptSize.pixel14)),

                          const Spacer(),

                          /// date open - close
                          IconWithLabel().asrow(
                              contexts: context,
                              usedIcon: Icons.access_time,
                              labelText: officeById != null
                                  ? "${officeById.officeOpenTime.hour}:00-${officeById.officeCloseTime.hour}:00"
                                  : "08:00-23:00",
                              fontSizes: AdaptSize.pixel14,
                              spacer: AdaptSize.pixel4),
                        ],
                      ),

                      SizedBox(
                        height: AdaptSize.pixel8,
                      ),

                      /// deskripsi
                      Text(
                        "Description",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: MyColor.neutral100,
                            fontSize: AdaptSize.pixel16),
                      ),
                      SizedBox(
                        height: AdaptSize.pixel8,
                      ),
                      Text(
                        officeById?.officeDescription ??
                            listOfDummyOffice[0].officeDescription,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: MyColor.neutral200,
                              fontSize: AdaptSize.pixel14,
                            ),
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.justify,
                      ),

                      SizedBox(
                        height: AdaptSize.pixel8,
                      ),

                      Text(
                        "Capacity",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: MyColor.neutral100,
                              fontSize: AdaptSize.pixel16,
                            ),
                      ),

                      /// list capacity
                      MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: AdaptSize.pixel8),
                          shrinkWrap: true,
                          itemCount: (officeById?.listOfOfficeCapcityModels ??
                                  listOfDummyOffice[0]
                                      .listOfOfficeCapcityModels)
                              .length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    /// icon
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: AdaptSize.pixel8),
                                      child: officeById
                                                      ?.listOfOfficeCapcityModels[
                                                          index]
                                                      .capacityIconSlug !=
                                                  null &&
                                              officeById
                                                      ?.listOfOfficeCapcityModels[
                                                          index]
                                                      .capacityIconSlug !=
                                                  ''
                                          ? customSVGIconParsers(
                                              size: AdaptSize.pixel22,
                                              iconSlug: officeById
                                                  ?.listOfOfficeCapcityModels[
                                                      index]
                                                  .capacityIconSlug)
                                          : Icon(
                                              CupertinoIcons
                                                  .rectangle_arrow_up_right_arrow_down_left,
                                              color: MyColor.secondary400,
                                              size: AdaptSize.pixel18,
                                            ),
                                    ),

                                    /// text keterangan
                                    Text(
                                      officeById
                                              ?.listOfOfficeCapcityModels[index]
                                              .capacityTitle ??
                                          "Can Accomodate",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: MyColor.neutral200,
                                              fontSize: AdaptSize.pixel14),
                                    ),
                                    const Spacer(),

                                    /// detail person
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: officeById
                                                    ?.listOfOfficeCapcityModels[
                                                        index]
                                                    .capacityValue
                                                    .toString()
                                                    .replaceAll(
                                                        RemoveTrailingZero
                                                            .regex,
                                                        '') ??
                                                listOfDummyOffice[0]
                                                    .listOfOfficeCapcityModels[
                                                        index]
                                                    .capacityTitle,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: MyColor.secondary400,
                                                    fontSize:
                                                        AdaptSize.pixel14),
                                          ),
                                          TextSpan(
                                            text:
                                                ' ${officeById?.listOfOfficeCapcityModels[index].capacityUnits ?? 'Units'}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: MyColor.neutral200,
                                                    fontSize:
                                                        AdaptSize.pixel14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                dividerWdiget(
                                    width: double.infinity, opacity: .1),
                              ],
                            );
                          },
                        ),
                      ),

                      SizedBox(
                        height: AdaptSize.pixel8,
                      ),

                      Text(
                        "Facilities",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: MyColor.neutral100,
                            fontSize: AdaptSize.pixel16,
                            fontWeight: FontWeight.bold),
                      ),

                      /// list facility
                      MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: AdaptSize.pixel8),
                          shrinkWrap: true,
                          itemCount:
                              (officeById?.listOfOfficeFacilitiesModels ??
                                              listOfDummyOffice[0]
                                                  .listOfOfficeFacilitiesModels)
                                          .length >=
                                      5
                                  ? 5
                                  : (officeById?.listOfOfficeFacilitiesModels ??
                                          listOfDummyOffice[0]
                                              .listOfOfficeFacilitiesModels)
                                      .length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                index >= 4
                                    ? InkWell(
                                        splashColor: MyColor.transparanColor,
                                        onTap: () {
                                          modalBottomSheed(
                                            context,
                                            listFacilityItem(
                                                context: context,
                                                officeFacility: officeById
                                                        ?.listOfOfficeFacilitiesModels ??
                                                    []),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: AdaptSize.pixel8),
                                              child: Icon(
                                                Icons.grid_view_outlined,
                                                size: AdaptSize.pixel22,
                                                color: MyColor.secondary400,
                                              ),
                                            ),
                                            SizedBox(
                                              width: AdaptSize.pixel8,
                                            ),
                                            Text(
                                              'See more facilities (${(officeById?.listOfOfficeFacilitiesModels ?? listOfDummyOffice[0].listOfOfficeFacilitiesModels).length})',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: MyColor.neutral200,
                                                      fontSize:
                                                          AdaptSize.pixel14),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          /// icon
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: AdaptSize.pixel8),
                                            child: officeById
                                                            ?.listOfOfficeFacilitiesModels[
                                                                index]
                                                            .facilitiesIconSlug !=
                                                        null &&
                                                    officeById
                                                            ?.listOfOfficeFacilitiesModels[
                                                                index]
                                                            .facilitiesIconSlug !=
                                                        ''
                                                ? customSVGIconParsers(
                                                    size: AdaptSize.pixel22,
                                                    iconSlug: officeById
                                                        ?.listOfOfficeFacilitiesModels[
                                                            index]
                                                        .facilitiesIconSlug)
                                                : Icon(
                                                    CupertinoIcons
                                                        .rectangle_arrow_up_right_arrow_down_left,
                                                    color: MyColor.secondary400,
                                                    size: AdaptSize.pixel18,
                                                  ),
                                          ),

                                          /// text keterangan
                                          Text(
                                            officeById
                                                    ?.listOfOfficeFacilitiesModels[
                                                        index]
                                                    .facilitiesTitle ??
                                                "Can Accomodate",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: MyColor.neutral200,
                                                    fontSize:
                                                        AdaptSize.pixel14),
                                          ),
                                        ],
                                      ),
                                dividerWdiget(
                                    width: double.infinity, opacity: .1),
                              ],
                            );
                          },
                        ),
                      ),

                      /// text alamat office
                      Text(
                        "Address",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: MyColor.neutral100,
                              fontSize: AdaptSize.pixel16,
                            ),
                      ),

                      SizedBox(
                        height: AdaptSize.pixel8,
                      ),

                      /// detail alamat office
                      Text(
                        '${officeById?.officeLocation.city ?? listOfDummyOffice[0].officeLocation.city}, ${officeById?.officeLocation.district ?? listOfDummyOffice[0].officeLocation.district}',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: MyColor.neutral200,
                              fontSize: AdaptSize.pixel14,
                            ),
                      ),

                      /// fitur google maaps
                      InkWell(
                        onTap: () {
                          context
                              .read<GetLocationViewModel>()
                              .permissionLocationGMap(context, officeById!);
                        },
                        splashColor: MyColor.transparanColor,
                        child: Container(
                          height: AdaptSize.screenHeight * .18,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(1, 2),
                                color: MyColor.neutral600.withOpacity(.5),
                                blurRadius: 3,
                              ),
                            ],
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/image_assets/mapimage.jpg'),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: AdaptSize.pixel8,
                      ),

                      /// card review
                      Consumer<ReviewViewModels>(
                          builder: (context, reviewModels, child) {
                        if (reviewModels.connectionState ==
                            stateOfConnections.isLoading) {
                          return reviewModels.listOfReviewOffice.isNotEmpty
                              ? shimmerLoading(
                                  child: commonShimmerLoadWidget(
                                    sizeHeight:
                                        AdaptSize.screenWidth / 1000 * 470,
                                    sizeWidth: double.infinity,
                                  ),
                                )
                              : const SizedBox();
                        }
                        if (reviewModels.connectionState ==
                            stateOfConnections.isReady) {
                          return reviewModels.listOfReviewOffice.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Review",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                            color: MyColor.neutral100,
                                            fontSize: AdaptSize.pixel16,
                                          ),
                                    ),
                                    SizedBox(
                                      height:
                                          AdaptSize.screenWidth / 1000 * 470,
                                      width: double.infinity,
                                      child: ListView.builder(
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  AdaptSize.screenHeight * .01),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: reviewModels
                                              .listOfReviewOffice.length,
                                          itemBuilder: (context, index) {
                                            final currentReviewModel =
                                                reviewModels
                                                    .listOfReviewOffice[index];
                                            return cardReview(
                                              context: context,
                                              userImage: currentReviewModel
                                                  .reviewComment,
                                              userNameReview: currentReviewModel
                                                  .reviewComment,
                                              dateReview: DateFormat('MMM y')
                                                  .format(currentReviewModel
                                                      .createdAt!)
                                                  .toString(),
                                              descriptionReview:
                                                  currentReviewModel
                                                      .reviewComment,
                                              totalHelpful:
                                                  Random().nextInt(10),
                                              reviewStarLength:
                                                  currentReviewModel
                                                      .reviewRating
                                                      .toInt(),
                                            );
                                          }),
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  height: AdaptSize.screenHeight * .01,
                                );
                        }
                        if (reviewModels.connectionState ==
                            stateOfConnections.isFailed) {
                          return reviewById.isNotEmpty
                              ? commonShimmerFailedLoadWidget(
                                  context: context,
                                  sizeHeight:
                                      AdaptSize.screenWidth / 1000 * 470,
                                  sizeWidth: double.infinity,
                                )
                              : const SizedBox();
                        }
                        return const SizedBox();
                      }),

                      /// card review

                      SizedBox(
                        height: AdaptSize.screenWidth / 1000 * 180,
                      ),
                    ],
                  ),
                ),
              ),

              /// footer widget
              /// total harga
              Align(
                alignment: Alignment.bottomCenter,
                child: footerDetail(
                  context: context,
                  officePrice: officeById?.officePricing.officePrice ??
                      Random().nextDouble() * 400000,
                  bookingButton: () {
                    context
                        .read<NavigasiViewModel>()
                        .navigasiToCheckOut(context, widget.officeID);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///split
  /// ------------------------------------------------------------------------

  /// list facility item
  Widget listFacilityItem({
    required BuildContext context,
    required List<OfficeFacilitiesModels> officeFacility,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: AdaptSize.screenWidth * .016,
        right: AdaptSize.screenWidth * .016,
        bottom: AdaptSize.screenHeight * .008,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: dividerWdiget(
              width: AdaptSize.screenWidth * 0.1,
              opacity: .4,
            ),
          ),
          SizedBox(
            height: AdaptSize.screenHeight * .016,
          ),
          Text(
            'More Facilities',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: AdaptSize.screenHeight * .016,
                ),
          ),
          SizedBox(
            height: AdaptSize.screenHeight * .016,
          ),
          ListView.builder(
              itemCount: officeFacility.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: AdaptSize.pixel8),
                          child: officeFacility[index].facilitiesIconSlug !=
                                      null &&
                                  officeFacility[index].facilitiesIconSlug != ''
                              ? customSVGIconParsers(
                                  size: AdaptSize.pixel22,
                                  iconSlug:
                                      officeFacility[index].facilitiesIconSlug)
                              : Icon(
                                  CupertinoIcons
                                      .rectangle_arrow_up_right_arrow_down_left,
                                  color: MyColor.secondary400,
                                  size: AdaptSize.pixel18,
                                ),
                        ),
                        SizedBox(
                          width: AdaptSize.pixel8,
                        ),
                        Text(
                          officeFacility[index].facilitiesTitle,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: MyColor.neutral200,
                                  fontSize: AdaptSize.pixel14),
                        ),
                      ],
                    ),
                    dividerWdiget(width: double.infinity, opacity: .1),
                  ],
                );
              }),
        ],
      ),
    );
  }

  /// ------------------------------------------------------------------------

  /// split footer content
  Widget footerDetail({
    context,
    Function()? bookingButton,
    required double officePrice,
  }) {
    return Container(
      height: AdaptSize.screenHeight * .09,
      width: double.infinity,
      margin: EdgeInsets.only(top: AdaptSize.pixel8),
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        left: AdaptSize.pixel16,
        right: AdaptSize.pixel16,
      ),
      decoration: BoxDecoration(
        color: MyColor.neutral900,
        boxShadow: [
          BoxShadow(
            color: MyColor.neutral300.withOpacity(.5),
            blurRadius: 4,
            blurStyle: BlurStyle.solid,
          )
        ],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Start From',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: MyColor.darkBlueColor,
                      fontSize: AdaptSize.pixel16,
                    ),
              ),
              Text(
                NumberFormat.currency(
                        locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                    .format(officePrice),
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: MyColor.darkBlueColor,
                      fontSize: AdaptSize.pixel14,
                    ),
              ),
            ],
          ),
          buttonWidget(
            onPressed: bookingButton,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: MyColor.secondary400,
            foregroundColor: MyColor.secondary400,
            child: Text(
              'Book Now',
              style: Theme.of(context).textTheme.button!.copyWith(
                    fontSize: AdaptSize.pixel14,
                    color: MyColor.neutral900,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
