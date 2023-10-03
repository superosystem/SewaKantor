import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardShimmerHomeLoading {
  /// shimmer card widget only home screen
  static Widget verticalShimmerHome = Container(
    height: AdaptSize.screenWidth / 3,
    width: double.infinity,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: MyColor.grayLightColor.withOpacity(.4),
          blurRadius: 3,
          blurStyle: BlurStyle.solid,
        ),
      ],
      borderRadius: BorderRadius.circular(16),
    ),
    child: SvgPicture.asset('assets/svg_assets/logo.svg'),
  );

  /// shimmer card load failed only home screen
  static Widget verticalFailedLoadShimmer(context) {
    return Container(
      height: AdaptSize.screenWidth / 3,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: MyColor.grayLightColor.withOpacity(.4),
            blurRadius: 3,
            blurStyle: BlurStyle.solid,
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.heart_broken_outlined,
              color: MyColor.danger400,
              size: AdaptSize.screenHeight * .1,
            ),
            SizedBox(
              height: AdaptSize.screenHeight * .016,
            ),
            Text(
              'sorry an error occurred',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: AdaptSize.pixel14,
                    color: MyColor.danger400,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// shimmer card horizontal load only home screen
  static Widget horizontalLoadShimmerHome = Container(
    height: AdaptSize.screenWidth / 1000 * 354,
    width: AdaptSize.screenWidth * .36,
    margin: EdgeInsets.only(
      bottom: AdaptSize.screenHeight * .008,
    ),
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: MyColor.grayLightColor.withOpacity(.4),
          blurRadius: 3,
          blurStyle: BlurStyle.solid,
        ),
      ],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Center(
      child: SvgPicture.asset('assets/svg_assets/logo.svg'),
    ),
  );

  /// shimmer card horizontal load failed only home screen
  static Widget horizontalFailedShimmerHome(context) {
    return Container(
      height: AdaptSize.screenWidth / 1000 * 354,
      width: AdaptSize.screenWidth * .36,
      margin: EdgeInsets.only(
        bottom: AdaptSize.screenHeight * .008,
      ),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: MyColor.grayLightColor.withOpacity(.4),
            blurRadius: 3,
            blurStyle: BlurStyle.solid,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.heart_broken_outlined,
              color: MyColor.danger400,
              size: AdaptSize.screenWidth / 1000 * 110,
            ),
            Text(
              'sorry an error occurred',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: AdaptSize.pixel12,
                    color: MyColor.danger400,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// common shimmer load
Widget commonShimmerLoadWidget({
  double? sizeHeight,
  double? sizeWidth,
}) {
  return Container(
    height: sizeHeight,
    width: sizeWidth,
    margin: const EdgeInsets.only(
      left: 5,
      right: 5,
      bottom: 10,
    ),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: MyColor.grayLightColor.withOpacity(.4),
          blurRadius: 3,
          blurStyle: BlurStyle.inner,
        ),
      ],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Center(
      child: SvgPicture.asset('assets/svg_assets/logo.svg'),
    ),
  );
}

/// common shimmer failed load
Widget commonShimmerFailedLoadWidget({
  required BuildContext context,
  double? sizeHeight,
  double? sizeWidth,
}) {
  return Container(
    height: sizeHeight,
    width: sizeWidth,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: MyColor.grayLightColor.withOpacity(.4),
          blurRadius: 3,
        ),
      ],
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.heart_broken_outlined,
            color: MyColor.danger400,
            size: AdaptSize.screenWidth / 1000 * 200,
          ),
          SizedBox(
            height: AdaptSize.screenHeight * .016,
          ),
          Text(
            'sorry an error occurred',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: AdaptSize.pixel14,
                  color: MyColor.danger400,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
