import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import '../global/style.dart';

class ImageScreen extends StatelessWidget {
  final Image image;
  const ImageScreen(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(
          'VR Image',
          style: TextStyle(
              color: primaryBlueColor,
              fontFamily: 'Dubai',
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        //backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new, color: primaryBlueColor,size: 15,)),
      ),
      body: PanoramaViewer(
        animSpeed: 1,
        sensorControl: SensorControl.absoluteOrientation,
        child: image,
      ),
    );
  }
}


