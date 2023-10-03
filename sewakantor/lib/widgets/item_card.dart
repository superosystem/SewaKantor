import 'package:flutter/material.dart';

Widget itemCards({
  required Widget childWidgets,
  required double cardBottomPadding,
  double? cardBorderRadius,
  double? elevations,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: cardBottomPadding),
    child: Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius ?? 24)),
      elevation: elevations ?? 2,
      child: childWidgets,
    ),
  );
}
