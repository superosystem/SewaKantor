import 'package:flutter/material.dart';

dynamic transparentAppbarWidget(
    {required BuildContext context,
    Text? titles,
    double? titleSpacer,
    Widget? leadingIcon,
    List<IconButton>? actionIcon}) {
  return AppBar(
    titleSpacing: titleSpacer,
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: leadingIcon,
    title: titles,
    actions: actionIcon,
  );
}
