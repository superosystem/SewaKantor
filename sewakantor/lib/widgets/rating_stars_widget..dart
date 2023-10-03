import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget ratingStarBadge({
  required BuildContext contexts,
  double? contentPositionTop,
  double? contentPositionbottom,
  double? contentPositionLeft,
  double? contentPositionRight,
  double? contentWidth,
  double? contentHeight,
  double? badgeWidth,
  double? badgeHeight,
  Color? badgeColor,
  double? badgeBorderWidth,
  double? badgeBorderRadius,
  Color? badgeBorderColor,
  required Text contentTexts,
  double? iconSize,
}) {
  AdaptSize.size(context: contexts);
  return Container(
    width: badgeWidth ?? AdaptSize.screenWidth / 7.2,
    height: badgeHeight ?? AdaptSize.screenWidth / 15,
    decoration: BoxDecoration(
      color: badgeColor ?? MyColor.neutral300,
      border: Border.all(
          width: badgeBorderWidth ?? 1,
          color: badgeBorderColor ?? MyColor.neutral300),
      borderRadius: BorderRadius.circular(badgeBorderRadius ?? 42),
    ),
    child: Stack(
      children: [
        /// penilaian
        Positioned(
          top: contentPositionTop ?? AdaptSize.pixel4,
          bottom: contentPositionbottom ?? AdaptSize.pixel4,
          right: contentPositionRight ?? AdaptSize.pixel8,
          left: contentPositionLeft ?? AdaptSize.pixel6,
          child: SizedBox(
            height: contentHeight ?? AdaptSize.pixel16,
            width: contentWidth ?? AdaptSize.pixel34,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.star_rounded,
                  color: MyColor.starYellow,
                  size: iconSize ?? AdaptSize.pixel16,
                ),
                contentTexts,
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
