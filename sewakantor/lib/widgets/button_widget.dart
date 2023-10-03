import 'package:flutter/material.dart';

Widget buttonWidget({
  Color? backgroundColor,
  Color? foregroundColor,
  Function()? onPressed,
  Widget? child,
  double? sizeheight,
  double? sizeWidth,
  Color? onPrimary,
  double? elevation,
  BorderSide? borderSide,
  BorderRadiusGeometry? borderRadius,
  EdgeInsetsGeometry? margin,
}) {
  return Container(
    width: sizeWidth,
    height: sizeheight,
    margin: margin,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        side: borderSide,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius!,
        ),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      child: child,
    ),
  );
}
