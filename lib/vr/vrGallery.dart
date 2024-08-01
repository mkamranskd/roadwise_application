import 'package:flutter/material.dart';
import 'package:roadwise_application/vr/thumbnail.dart';
import '../global/style.dart';

class vrHomeScreen extends StatelessWidget {
  const vrHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Thumbnail> thumbList = [
      const Thumbnail(
        imagePath: "lib/vr/vr.jpg",
        thumbPath: "lib/vr/vr.jpg",
      ),const Thumbnail(
        imagePath: "lib/vr/vr1.jpg",
        thumbPath: "lib/vr/vr1.jpg",
      ),const Thumbnail(
        imagePath: "lib/vr/vr2.jpg",
        thumbPath: "lib/vr/vr2.jpg",
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VR Gallery',
          style: TextStyle(
              color: primaryBlueColor,
              fontFamily: 'Dubai',
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new, color: primaryBlueColor,size: 15,)),

      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            clipBehavior: Clip.antiAlias,
            children: thumbList,
          ),
        ),
      ),
    );
  }
}
