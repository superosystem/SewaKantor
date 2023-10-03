import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/widgets/card_shimmer_widget.dart';
import 'package:sewakantor/widgets/shimmer_widget.dart';

Widget detailOrderCard({
  context,
  Function()? onTap,
  required String officeImage,
  required String officeName,
  required String officeLocation,
  required String officeApproxDistance,
  required String officePersonCapacity,
  required String officeArea,
  required String officeType,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: AdaptSize.screenWidth / 1000 * 360,
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: AdaptSize.screenHeight * .008,
      ),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: MyColor.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, 3),
            color: MyColor.grayLightColor.withOpacity(.4),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          /// space image
          CachedNetworkImage(
            imageUrl: officeImage,
            imageBuilder: (context, imageProvider) => Container(
              width: AdaptSize.screenWidth * .36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: imageProvider,
                ),
              ),
            ),
            placeholder: (context, url) => shimmerLoading(
              child: CardShimmerHomeLoading.horizontalLoadShimmerHome,
            ),
            errorWidget: (context, url, error) =>
                CardShimmerHomeLoading.horizontalFailedShimmerHome(context),
          ),

          /// jarak samping
          SizedBox(
            width: AdaptSize.screenWidth * .008,
          ),

          /// keterangan
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  officeName,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontSize: AdaptSize.pixel16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                /// jarak bawah
                SizedBox(
                  height: AdaptSize.screenHeight * .008,
                ),

                /// lokasi
                Text(
                  officeLocation,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontSize: AdaptSize.pixel14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                /// jarak bawah
                SizedBox(
                  height: AdaptSize.screenHeight * .01,
                ),

                /// icon keterangan
                Flexible(
                  child: Row(
                    children: [
                      /// icon lokasi
                      Icon(
                        Icons.location_on_outlined,
                        size: AdaptSize.pixel18,
                      ),

                      /// keterangan lokasi
                      Text(
                        officeApproxDistance,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: AdaptSize.pixel12),
                      ),

                      SizedBox(
                        width: AdaptSize.screenWidth * .008,
                      ),

                      const SizedBox(
                        width: 2,
                      ),

                      /// icon penggaris
                      SvgPicture.asset(
                        'assets/svg_assets/ruler.svg',
                        height: AdaptSize.pixel18,
                      ),

                      /// luas area lokasi
                      Text(
                        '${officeArea}m2',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: AdaptSize.pixel12),
                      ),

                      SizedBox(
                        width: AdaptSize.screenWidth * .008,
                      ),

                      /// total person asset
                      SvgPicture.asset(
                        'assets/svg_assets/available.svg',
                        height: AdaptSize.pixel18,
                      ),

                      const SizedBox(
                        width: 2,
                      ),

                      /// total person
                      Text(
                        officePersonCapacity,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: AdaptSize.pixel12),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: MyColor.primary700,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AdaptSize.pixel4),
                    child: Text(
                      officeType,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: MyColor.primary700,
                          fontSize: AdaptSize.pixel12),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
