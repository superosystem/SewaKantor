import 'package:flutter/material.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';

class BookingStatusWidget {
  /// widget status pada detail order dan booking history

  static Widget statusOnProcess(context) {
    return SizedBox(
      width: AdaptSize.screenWidth / 4,
      height: AdaptSize.screenWidth / 1000 * 80,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: MyColor.secondary900,
          border: Border.all(width: 1, color: MyColor.secondary400),
          borderRadius: BorderRadius.circular(42),
        ),
        child: Center(
          child: Text(
            "On Process",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: MyColor.secondary400,
                  fontSize: AdaptSize.pixel10,
                ),
          ),
        ),
      ),
    );
  }

  static Widget statusSuccess(context) {
    return SizedBox(
      width: AdaptSize.screenWidth / 4,
      height: AdaptSize.screenWidth / 1000 * 80,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: MyColor.success900,
          border: Border.all(width: 1, color: MyColor.success400),
          borderRadius: BorderRadius.circular(42),
        ),
        child: Center(
          child: Text(
            "Accepted",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: MyColor.success400,
                  fontSize: AdaptSize.pixel10,
                ),
          ),
        ),
      ),
    );
  }

  static Widget statusCancelled(context) {
    return SizedBox(
      width: AdaptSize.screenWidth / 4,
      height: AdaptSize.screenWidth / 1000 * 80,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: MyColor.danger900,
          border: Border.all(width: 1, color: MyColor.danger400),
          borderRadius: BorderRadius.circular(42),
        ),
        child: Center(
          child: Text(
            "Cancelled",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: MyColor.danger400,
                  fontSize: AdaptSize.pixel10,
                ),
          ),
        ),
      ),
    );
  }
}
