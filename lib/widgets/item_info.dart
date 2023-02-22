import 'package:flutter/material.dart';

class ItemInfo extends StatelessWidget {
  const ItemInfo({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(title),
      ],
    );
  }
}
