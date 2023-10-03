import 'package:flutter/material.dart';

Future modalBottomSheed(context, Widget widget) {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(16),
        topLeft: Radius.circular(16),
      ),
    ),
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return widget;
    },
  );
}