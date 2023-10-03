import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// update 13 12 22
/// mengubah border radius, background warna dan warna border
Widget horizontalMonthPicker({
  required BuildContext contexts,
  required ValueNotifier<int> isSelected,
  int? initialMonth,
  int? monthFinalOffset,
  int? monthInitOffset,
}) {
  AdaptSize.size(context: contexts);
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: monthFinalOffset ?? 15,
    itemBuilder: ((context, index) {
      int monthIndex = index + (monthInitOffset ?? 1);
      if (monthIndex <= 12 && monthIndex > 0) {
        return ValueListenableBuilder<int>(
          valueListenable: isSelected,
          builder: ((context, value, child) {
            return Padding(
              padding: EdgeInsets.only(right: AdaptSize.pixel8),
              child: ElevatedButton(
                onPressed: () {
                  isSelected.value = monthIndex;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected.value == monthIndex
                      ? MyColor.secondary400
                      : MyColor.neutral900,
                  shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                      side: BorderSide(
                          color: isSelected.value == monthIndex
                              ? MyColor.secondary600
                              : MyColor.neutral400,
                          width: AdaptSize.pixel1)),
                ),
                child: Text(
                  monthIndex.toString() + " month",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: isSelected.value == monthIndex
                            ? MyColor.neutral900
                            : MyColor.neutral400,
                      ),
                ),
              ),
            );
          }),
        );
      } else {
        return ValueListenableBuilder<int>(
          valueListenable: isSelected,
          builder: ((context, value, child) {
            return Padding(
              padding: EdgeInsets.only(right: AdaptSize.pixel8),
              child: ElevatedButton(
                onPressed: () {
                  isSelected.value = ((monthIndex - 12) + 1) * 12;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSelected.value == ((monthIndex - 12) + 1) * 12
                          ? MyColor.secondary400
                          : MyColor.neutral900,
                  shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                      side: BorderSide(
                          color:
                              isSelected.value == ((monthIndex - 12) + 1) * 12
                                  ? MyColor.secondary600
                                  : MyColor.neutral400,
                          width: AdaptSize.pixel1)),
                ),
                child: Text(
                  ((monthIndex - 12) + 1).toString() + " year",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: isSelected.value == ((monthIndex - 12) + 1) * 12
                            ? MyColor.neutral900
                            : MyColor.neutral400,
                      ),
                ),
              ),
            );
          }),
        );
      }
    }),
  );
}
