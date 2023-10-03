import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// update 13 12 22
/// mengubah border radius, background warna dan warna border
dynamic horizontalTimePicker({
  required BuildContext contexts,
  required ValueNotifier<int> isSelected,
  int? initialHour,
  int? hourStartOffset,
  int? hourFinalOffset,
}) {
  AdaptSize.size(context: contexts);
  TimeOfDay timeOfThisDay = TimeOfDay.now();
  //ValueNotifier<int> isSelected = ValueNotifier<int>(initialHour ?? 8);

  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: hourFinalOffset ?? 13,
    itemBuilder: ((context, index) {
      int hourFinal = index + (hourStartOffset ?? 8);
      if (hourFinal < 10 && hourFinal > 7) {
        return ValueListenableBuilder<int>(
          valueListenable: isSelected,
          builder: ((context, value, child) {
            return Padding(
              padding: EdgeInsets.only(right: AdaptSize.pixel8),
              child: ElevatedButton(
                onPressed: () {
                  isSelected.value = hourFinal;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected.value == hourFinal
                      ? MyColor.secondary400
                      : MyColor.neutral900,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                      side: BorderSide(
                          color: isSelected.value == hourFinal
                              ? MyColor.secondary600
                              : MyColor.neutral400,
                          width: AdaptSize.pixel1)),
                ),
                child: Text(
                  "0" + hourFinal.toString() + " : 00",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: isSelected.value == hourFinal
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
                  isSelected.value = hourFinal;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected.value == hourFinal
                      ? MyColor.secondary400
                      : MyColor.neutral900,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                      side: BorderSide(
                          color: isSelected.value == hourFinal
                              ? MyColor.secondary600
                              : MyColor.neutral400,
                          width: AdaptSize.pixel1)),
                ),
                child: Text(
                  hourFinal.toString() + " : 00",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: isSelected.value == hourFinal
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
