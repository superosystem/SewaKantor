import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.red,
                    Colors.amber,
                  ]),
              borderRadius: BorderRadius.circular(60)),
        ),
        Container(
          width: 95,
          height: 95,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              image: const DecorationImage(
                  image: NetworkImage("https://picsum.photos/536/354"),
                  fit: BoxFit.cover,
              ),
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(60)),
        ),
      ],
    );
  }
}
