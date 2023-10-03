import 'package:flutter/cupertino.dart';

Widget imageItemFrameRounded(
    {required double itemHeight,
    required double itemWidth,
    required Image Images,
    required double frameRadius,
    required EdgeInsets imagePadding}) {
  return Padding(
    padding: imagePadding,
    child: SizedBox(
      width: itemWidth,
      height: itemWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(frameRadius),
        child: Images,
      ),
    ),
  );
}
