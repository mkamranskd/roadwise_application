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
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        leading: IconButton( onPressed: () {
          Navigator.pop(context);
          },
          style:const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
          ),
          icon: const Icon(Icons.arrow_back_ios_new),color: primaryBlueColor,
        ),
      ),
      body: PanoramaViewer(
        animSpeed: 1,
        sensorControl: SensorControl.absoluteOrientation,
        child: image,
      ),
    );
  }
}


