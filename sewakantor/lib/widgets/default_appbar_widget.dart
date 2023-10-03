import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget defaultAppbarWidget({
  String? titles,
  required BuildContext contexts,
  List<Widget>? actionWidget,
  Function()? leadIconFunction,
  Widget? appbarBottomWidget,
  double? bottomHeight,
  bool? isCenterTitle,
  bool? centerTitle,
  Widget? leadingIcon,
}) {
  AdaptSize.size(context: contexts);
  return AppBar(
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(bottomHeight ?? 2),
      child: appbarBottomWidget ??
          Container(
            color: MyColor.neutral800,
            height: 2.0,
          ),
    ),
    backgroundColor: MyColor.neutral900,
    elevation: 0,
    centerTitle: centerTitle,
    titleSpacing: AdaptSize.pixel10,
    leading: isCenterTitle!
        ? const SizedBox()
        : IconButton(
            padding: EdgeInsets.zero,
            onPressed: leadIconFunction,
            splashRadius: 1,
            icon: Icon(
              Icons.arrow_back,
              color: MyColor.neutral200,
              size: AdaptSize.pixel24,
            ),
          ),
    title: Text(
      titles ?? "",
      style: Theme.of(contexts).textTheme.headline5!.copyWith(
            color: MyColor.neutral100,
            fontSize: AdaptSize.pixel18,
          ),
    ),
    actions: actionWidget,
  );
}
