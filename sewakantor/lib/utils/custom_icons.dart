import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget customSVGIconParsers({double? size, Color? color, String? iconSlug}) {
  return SizedBox(
    height: size ?? AdaptSize.pixel16,
    width: size ?? AdaptSize.pixel16,
    child: SvgPicture.asset(
      "assets/svg_assets/icons/${iconSlug ?? "accomodate"}.svg",
      color: color ?? MyColor.secondary400,
    ),
  );
}
