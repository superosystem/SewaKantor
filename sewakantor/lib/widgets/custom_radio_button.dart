import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customRadioButton({
  required BuildContext context,
  required ValueNotifier<int> customRadioController,
  required int controlledIdValue,
  double? outerCircleDiameter,
  double? innerCircleDiameter,
  double? circleBodyBorder,
}) {
  AdaptSize.size(context: context);

  return ValueListenableBuilder<int>(
    valueListenable: customRadioController,
    builder: ((context, value, child) {
      return InkWell(
        onTap: (() {
          customRadioController.value = controlledIdValue;
        }),
        child: SizedBox(
          height: outerCircleDiameter ?? AdaptSize.pixel40,
          width: outerCircleDiameter ?? AdaptSize.pixel40,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: outerCircleDiameter ?? AdaptSize.pixel40,
                  height: outerCircleDiameter ?? AdaptSize.pixel40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: customRadioController.value == controlledIdValue
                          ? MyColor.secondary900
                          : MyColor.neutral900),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: outerCircleDiameter ?? AdaptSize.pixel20,
                  height: outerCircleDiameter ?? AdaptSize.pixel20,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color:
                              customRadioController.value == controlledIdValue
                                  ? MyColor.secondary400
                                  : MyColor.primary700,
                          width: 2),
                      shape: BoxShape.circle,
                      color: customRadioController.value == controlledIdValue
                          ? MyColor.secondary900
                          : MyColor.neutral900),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: outerCircleDiameter ?? AdaptSize.pixel12,
                  height: outerCircleDiameter ?? AdaptSize.pixel12,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: customRadioController.value == controlledIdValue
                          ? MyColor.secondary400
                          : MyColor.neutral900),
                ),
              ),
            ],
          ),
        ),
      );
    }),
  );
}
