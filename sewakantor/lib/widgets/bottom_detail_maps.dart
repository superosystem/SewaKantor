import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/widgets/button_widget.dart';
import 'package:sewakantor/widgets/divider_widget.dart';
import 'package:sewakantor/widgets/line_dash_widget.dart';
import 'package:flutter/material.dart';

/// detial maps
Widget bottomDetailMaps({
  context,
  required String userAddress,
  required String officeAddress,
  required String distance,
  required Function()? onPressed,
}) {
  return Padding(
    padding: EdgeInsets.only(
      top: AdaptSize.screenHeight * .016,
      left: AdaptSize.screenHeight * .016,
      right: AdaptSize.screenHeight * .016,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current location',
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: MyColor.neutral400, fontSize: AdaptSize.pixel14),
        ),

        SizedBox(
          height: AdaptSize.screenHeight * .008,
        ),

        /// office location
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.location_on_outlined,
              color: MyColor.secondary400,
              size: AdaptSize.pixel22,
            ),
            SizedBox(
              width: AdaptSize.screenWidth * .012,
            ),
            Expanded(
              child: Text(
                userAddress,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
              ),
            ),
          ],
        ),

        SizedBox(
          height: AdaptSize.screenHeight * .008,
        ),

        LineDashWidget(
          color: MyColor.neutral500,
        ),

        SizedBox(
          height: AdaptSize.screenHeight * .008,
        ),

        Text(
          'Destination location',
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: MyColor.neutral400, fontSize: AdaptSize.pixel14),
        ),

        SizedBox(
          height: AdaptSize.screenHeight * .008,
        ),

        /// office location
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: MyColor.secondary400,
              size: AdaptSize.pixel22,
            ),
            SizedBox(
              width: AdaptSize.screenWidth * .012,
            ),
            Text(
              officeAddress,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(fontSize: AdaptSize.pixel14),
            ),
          ],
        ),

        SizedBox(
          height: AdaptSize.screenHeight * .016,
        ),

        buttonWidget(
          onPressed: onPressed,
          backgroundColor: MyColor.secondary400,
          sizeWidth: double.infinity,
          sizeheight: AdaptSize.pixel40,
          borderRadius: BorderRadius.circular(10),
          child: Text(
            'Go to location ($distance)',
            style: Theme.of(context).textTheme.button!.copyWith(
                color: MyColor.neutral900, fontSize: AdaptSize.pixel14),
          ),
        ),
        SizedBox(
          height: AdaptSize.pixel16,
        ),
      ],
    ),
  );
}

/// launch maps in bottom sheed
Widget goToGMaps({
  context,
  Function()? onPressed,
}) {
  return Padding(
    padding: EdgeInsets.only(
      left: AdaptSize.screenWidth * .016,
      right: AdaptSize.screenWidth * .016,
      bottom: AdaptSize.screenHeight * .008,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        dividerWdiget(
          width: AdaptSize.screenWidth * 0.1,
          opacity: .4,
        ),
        SizedBox(
          height: AdaptSize.screenHeight * .016,
        ),
        Text(
          'Want to location?',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontSize: AdaptSize.screenHeight * .02),
        ),
        SizedBox(
          height: AdaptSize.screenHeight * .016,
        ),
        Text(
          'You will be directed using Google Maps to the Office location',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: AdaptSize.screenHeight * .016,
                color: MyColor.neutral300,
              ),
        ),
        SizedBox(
          height: AdaptSize.screenHeight * .024,
        ),

        /// button open google maps widget
        buttonWidget(
          onPressed: onPressed,
          sizeheight: AdaptSize.pixel40,
          sizeWidth: double.infinity,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: MyColor.secondary400,
          child: Text(
            'Yes, Open Google Maps',
            style: Theme.of(context).textTheme.button!.copyWith(
                  color: MyColor.neutral900,
                  fontSize: AdaptSize.pixel14,
                ),
          ),
        ),

        SizedBox(
          height: AdaptSize.screenHeight * .03,
        ),
      ],
    ),
  );
}
