
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'image_screen.dart';

class Thumbnail extends StatelessWidget {
  final String imagePath;
  final String thumbPath;
  const Thumbnail(
      {required this.imagePath, required this.thumbPath, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double thumbWidth = screenWidth;
    if (kIsWeb) {
      thumbWidth = 100;
    }
    return InkWell(
      child: Transform.rotate(
        angle: 1.5708, // 90 degrees in radians
        child: Image.network(
          thumbPath,
          cacheWidth: thumbWidth.toInt(),
          cacheHeight: (thumbWidth ~/ 2),
        ),
      ),
      onTap: () {
        // move to image screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ImageScreen(
              Image.network(imagePath),
            ),
          ),
        );
      },
    );
  }
}
