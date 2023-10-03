import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:flutter/material.dart';

class IconWithLabel {
  Row asrow({
    required BuildContext contexts,
    required IconData usedIcon,
    required String labelText,
    double? iconSize,
    double? spacer,
    double? fontSizes,
    Color? iconColor,
    Color? fontColor,
    TextStyle? textStyles,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: spacer ?? 2),
          child: Icon(
            usedIcon,
            size: iconSize ?? AdaptSize.pixel20,
            color: iconColor ?? MyColor.primary700,
          ),
        ),
        Text(
          labelText,
          style: textStyles ??
              (Theme.of(contexts).textTheme.bodyText1!.copyWith(
                    color: fontColor ?? MyColor.neutral100,
                    fontSize: fontSizes ?? AdaptSize.pixel14,
                  )),
        ),
      ],
    );
  }
}
