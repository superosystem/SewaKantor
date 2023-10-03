import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';

Future showExitDialog(BuildContext context) {
  return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(
            'Are you sure want to exit ?',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontSize: AdaptSize.pixel14),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: MyColor.darkBlueColor, fontSize: AdaptSize.pixel12),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                'Exit',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: MyColor.redColor, fontSize: AdaptSize.pixel12),
              ),
            ),
          ],
        );
      });
}
