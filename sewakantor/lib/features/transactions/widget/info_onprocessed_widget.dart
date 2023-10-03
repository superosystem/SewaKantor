import 'package:flutter/material.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';

Widget infoOnProcess(context) {
  return Card(
    color: MyColor.secondary900,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: MyColor.secondary300),
    ),
    child: Padding(
      padding: EdgeInsets.all(AdaptSize.pixel8),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: AdaptSize.pixel22,
            color: MyColor.secondary400,
          ),
          SizedBox(
            width: AdaptSize.screenWidth * .01,
          ),
          Expanded(
            child: Text(
              "Check the booking status until it changes to done on the booking history menu to check in",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: MyColor.secondary400,
                    fontSize: AdaptSize.pixel14,
                  ),
            ),
          ),
        ],
      ),
    ),
  );
}
