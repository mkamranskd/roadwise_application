import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../global/style.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription>? cameras;
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      await _initializeCamera();
      setState(() {
        _isPermissionGranted = true;
      });
    } else {
      setState(() {
        _isPermissionGranted = false;
      });
    }
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras!.isNotEmpty) {
      _controller = CameraController(
        cameras![0],
        ResolutionPreset.high,
      );
      _initializeControllerFuture = _controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      await _controller!.takePicture().then((file) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmPictureScreen(imagePath: file.path),
          ),
        );
      });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        'Camera',
        style: TextStyle(
            color: primaryBlueColor,
            fontFamily: 'Dubai',
            fontSize: 15,
            fontWeight: FontWeight.bold),
      ),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new, color: primaryBlueColor,size: 15,)),

      ),

      body: _isPermissionGranted
          ? Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Wrap CameraPreview in a Container with a wide aspect ratio for panoramic view
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 16 / 9, // Adjust this ratio to suit panoramic needs
                    child: CameraPreview(_controller!),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(Clarity.camera_solid,size: 30, color:primaryBlueColor,),
                onPressed: () async {
                  await _takePicture();
                },
              ),
            ),
          ),
        ],
      )
          : const Center(
        child: Text('Camera permission is required to use this feature.'),
      ),
    );
  }
}




class ConfirmPictureScreen extends StatelessWidget {
  final String imagePath;

  const ConfirmPictureScreen({required this.imagePath});

  Future<void> _loadImage() async {
    // Simulate image loading time
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirm Picture',
          style: TextStyle(
              color: Colors.blue, // Replace with primaryBlueColor if defined
              fontFamily: 'Dubai',
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.blue, size: 15), // Replace with primaryBlueColor if defined
        ),
      ),
      body: FutureBuilder<void>(
        future: _loadImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox(height: 20,)),
                Transform.rotate(
                  angle: 1.5708, // 90 degrees in radians
                  child: Image.file(File(imagePath), fit: BoxFit.cover,),
                ),
                const SizedBox(height: 120,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Clarity.refresh_line, size: 30, color: Colors.blue), // Replace with primaryBlueColor if defined
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 80,),
                    IconButton(
                      icon: const Icon(Clarity.check_line, size: 35, color: Colors.blue), // Replace with primaryBlueColor if defined
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UploadPictureScreen(imagePath: imagePath),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const Expanded(child: SizedBox(height: 20,)),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}





class UploadPictureScreen extends StatefulWidget {
  final String imagePath;

  const UploadPictureScreen({required this.imagePath});

  @override
  _UploadPictureScreenState createState() => _UploadPictureScreenState();
}

class _UploadPictureScreenState extends State<UploadPictureScreen> {
  bool _isUploading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _uploadPicture(File(widget.imagePath));
  }

  Future<void> _uploadPicture(File image) async {
    setState(() {
      _isUploading = true;
    });

    try {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('businessVrImages/${_auth.currentUser!.uid}/${DateTime.now().toIso8601String()}.png');
      final UploadTask uploadTask = storageRef.putFile(image);

      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String imageUrl = await snapshot.ref.getDownloadURL();

      final userRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth.currentUser!.uid);
      await userRef.update({
        'businessVrImages': FieldValue.arrayUnion([imageUrl]),
      });

      Navigator.of(context).pop();
    } catch (e) {
      print('Error uploading profile picture: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Picture',
          style: TextStyle(
              color: Colors.blue, // Replace with primaryBlueColor if defined
              fontFamily: 'Dubai',
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.blue, size: 15), // Replace with primaryBlueColor if defined
        ),
      ),
      body: Center(
        child: _isUploading
            ?  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator( color: primaryBlueColor,),
            const SizedBox(height: 10),
            const Text('Image is uploading, please wait...',
              style: TextStyle(
                color: Colors.blue, // Replace with primaryBlueColor if defined
                fontFamily: 'Dubai',
                fontSize: 15,
                fontWeight: FontWeight.bold),),
          ],
        )
            : const Text('Upload complete'),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display Picture')),
      body: Center(
        child: Image.network(imagePath),
      ),
    );
  }
}
