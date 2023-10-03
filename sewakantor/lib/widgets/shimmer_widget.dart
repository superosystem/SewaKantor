import 'package:sewakantor/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerLoading({
  required Widget child,
}) {
  return Shimmer.fromColors(
    baseColor: MyColor.neutral600,
    highlightColor: MyColor.neutral900,
    child: child,
  );
}
