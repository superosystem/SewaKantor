import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/widgets/card_shimmer_widget.dart';
import 'package:sewakantor/widgets/shimmer_widget.dart';

Widget verticalCardHome({
  context,
  required Function() onTap,
  required String officeImage,
  required String officeName,
  required String officeLocation,
  required String officeStarRanting,
  required String officeApproxDistance,
  required String officePersonCapacity,
  required String officeArea,
  required String hours,
  required double officePricing,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      /// canvas
      margin: const EdgeInsets.only(
        left: 5,
        right: 5,
        bottom: 10,
      ),
      width: AdaptSize.screenWidth * .54,
      decoration: BoxDecoration(
        color: MyColor.neutral900,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, 3),
            color: MyColor.grayLightColor.withOpacity(.4),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: officeImage,
                imageBuilder: (context, imageProvider) => Container(
                  height: AdaptSize.screenWidth / 3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: imageProvider,
                    ),
                  ),
                ),
                placeholder: (context, url) => shimmerLoading(
                  child: CardShimmerHomeLoading.verticalShimmerHome,
                ),
                errorWidget: (context, url, error) =>
                    CardShimmerHomeLoading.verticalFailedLoadShimmer(context),
              ),

              /// image space

              Positioned(
                right: 10,
                top: 8,
                child: Stack(
                  children: [
                    /// ranting
                    Container(
                      height: AdaptSize.screenWidth / 1000 * 80,
                      width: AdaptSize.screenWidth / 1000 * 180,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                          left: AdaptSize.screenHeight * .005,
                          right: AdaptSize.screenHeight * .005),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: MyColor.grayLightColor.withOpacity(.6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: AdaptSize.pixel20,
                          ),
                          Text(
                            officeStarRanting,
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: MyColor.whiteColor,
                                      fontSize: AdaptSize.pixel14,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// keterangan
          Flexible(
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// space name
                  Text(
                    officeName,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: AdaptSize.pixel15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),

                  /// space lokasi
                  Text(
                    officeLocation,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: AdaptSize.pixel14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  /// keterangan kapasitas dan lokasi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// icon lokasi
                      Icon(Icons.location_on_outlined, size: AdaptSize.pixel18),

                      /// keterangan lokasi
                      Text(
                        officeApproxDistance,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: AdaptSize.pixel10),
                      ),

                      SizedBox(
                        width: AdaptSize.screenWidth * .004,
                      ),

                      /// keteranganan jarak
                      SvgPicture.asset(
                        'assets/svg_assets/ruler.svg',
                        height: AdaptSize.pixel18,
                      ),
                      Text(
                        '${officeArea}m2',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: AdaptSize.pixel10),
                      ),

                      SizedBox(
                        width: AdaptSize.screenWidth * .004,
                      ),

                      /// keterangan available
                      SvgPicture.asset(
                        'assets/svg_assets/available.svg',
                        height: AdaptSize.pixel18,
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          officePersonCapacity,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: AdaptSize.pixel10),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  /// harga
                  Row(
                    children: [
                      Text(
                        NumberFormat.currency(
                                locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                            .format(officePricing),
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: MyColor.darkBlueColor,
                              fontSize: AdaptSize.pixel14,
                            ),
                      ),
                      Text(
                        hours,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: AdaptSize.pixel10,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
