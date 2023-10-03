import 'package:flutter/material.dart';

Widget textButtonWidget({
  String? text,
  TextStyle? textStyle,
  Color? foregroundColor,
  Function()? onPressed,
}) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      foregroundColor: foregroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: Text(
      text!,
      style: textStyle,
    ),
  );
}
