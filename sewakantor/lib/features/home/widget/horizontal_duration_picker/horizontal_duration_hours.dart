import 'package:flutter/material.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';

/// update 13 12 22
/// mengubah border radius, background warna dan warna border
Widget horizontalHoursPicker({
  required BuildContext contexts,
  required ValueNotifier<int> isSelected,
  int? initialHour,
  int? hoursFinalOffset,
  int? hoursInitOffset,
}) {
  AdaptSize.size(context: contexts);
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: hoursFinalOffset ?? 13,
    itemBuilder: ((context, index) {
      int hoursIndex = index + (hoursInitOffset ?? 1);
      return ValueListenableBuilder<int>(
        valueListenable: isSelected,
        builder: ((context, value, child) {
          return Padding(
            padding: EdgeInsets.only(right: AdaptSize.pixel8),
            child: ElevatedButton(
              onPressed: () {
                isSelected.value = hoursIndex;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected.value == hoursIndex
                    ? MyColor.secondary400
                    : MyColor.neutral900,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(16),
                  ),
                  side: BorderSide(
                    color: isSelected.value == hoursIndex
                        ? MyColor.secondary600
                        : MyColor.neutral400,
                    width: AdaptSize.pixel1,
                  ),
                ),
              ),
              child: Text(
                "$hoursIndex hours",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: isSelected.value == hoursIndex
                          ? MyColor.neutral900
                          : MyColor.neutral400,
                    ),
              ),
            ),
          );
        }),
      );
    }),
  );
}
