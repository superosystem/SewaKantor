import 'package:flutter/material.dart';
import 'package:sewakantor/utils/adapt_size.dart';

Widget searchMapWidget({
  required BuildContext context,
  required String allOfficeCity,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Flexible(
        fit: FlexFit.tight,
        child: Image.asset('assets/image_assets/image_maps.png'),
      ),
      Padding(
        padding: EdgeInsets.all(
          AdaptSize.screenHeight * 0.008,
        ),
        child: Text(
          allOfficeCity,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: AdaptSize.screenHeight * 0.016,
              ),
        ),
      ),
    ],
  );
}
