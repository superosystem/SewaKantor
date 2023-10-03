import 'package:sewakantor/utils/colors.dart';
import 'package:flutter/material.dart';

Widget dividerWdiget({
  double? width,
  double? opacity,
}) {
  return SizedBox(
    width: width,
    child: Divider(
      color: MyColor.grayLightColor.withOpacity(opacity!),
      thickness: 2,
    ),
  );
}
