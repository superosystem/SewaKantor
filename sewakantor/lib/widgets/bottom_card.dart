import 'package:sewakantor/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget partialRoundedCard({
  required Widget childWidgets,
  required double cardBottomPadding,
  double? cardTopRightRadius,
  double? cardTopLeftRadius,
  double? cardBottomRightRadius,
  double? cardBottomLeftRadius,
  double? elevations,
}) {
  return Container(
      decoration: BoxDecoration(
        color: MyColor.neutral900,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(cardTopLeftRadius ?? 0),
          topRight: Radius.circular(cardTopRightRadius ?? 0),
          bottomLeft: Radius.circular(cardBottomLeftRadius ?? 0),
          bottomRight: Radius.circular(cardBottomRightRadius ?? 0),
        ),
        boxShadow: [
          BoxShadow(
            /// update 13 11 22 menyamakan dengan detail screen
            color: MyColor.neutral300.withOpacity(.5),
            blurRadius: 4,
            blurStyle: BlurStyle.solid,
          ),
        ],
      ),
      child: childWidgets);
}
