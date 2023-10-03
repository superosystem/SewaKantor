import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget richTextWidget(
{ String? text1,
  String? text2,
  String? text3,
  TextStyle? textStyle2,
  TextStyle? textStyle1,
  TextStyle? textStyle3,
  GestureRecognizer? recognizer,}
) {
  return RichText(
    text: TextSpan(
      text: text1,
      style: textStyle1,
      children: <TextSpan>[
        TextSpan(
          text: text2,
          style: textStyle2,
          recognizer: recognizer,
        ),
        TextSpan(
          text: text3,
          style: textStyle3,
        ),
      ],
    ),
  );
}
