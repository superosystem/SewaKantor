import 'package:flutter/material.dart';
import 'package:sewakantor/utils/adapt_size.dart';

Widget allSpaces(context, String text, Function() onTap) {
  return Row(
    children: [
      Text(
        text,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(fontSize: AdaptSize.pixel16),
      ),
      const Spacer(),
      InkWell(
        onTap: onTap,
        child: Text(
          'All',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontSize: AdaptSize.pixel16),
        ),
      ),
      Icon(
        Icons.arrow_forward_ios_outlined,
        size: AdaptSize.pixel16,
      )
    ],
  );
}
