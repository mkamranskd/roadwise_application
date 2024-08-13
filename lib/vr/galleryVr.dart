import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:roadwise_application/vr/thumbnail.dart';
import '../global/style.dart';
import 'cameraScreen.dart';



class GalleryVr extends StatefulWidget {
  final DocumentSnapshot businessData;

  GalleryVr({required this.businessData});

  @override
  State<GalleryVr> createState() => _GalleryVrState();
}

class _GalleryVrState extends State<GalleryVr> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late List<Thumbnail> thumbList = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _showCameraIcon = false;

  @override
  void initState() {
    super.initState();
    _loadBusinessImages();
  }

  Future<void> _loadBusinessImages() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        print('Current User ID: ${currentUser.uid}');
        final userRef = FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);
        final docSnapshot = await userRef.get();
        final userIdFromFirestore = docSnapshot.data()?['userId'] as String?;

        if (docSnapshot.exists) {
          print('User ID from Firestore: $userIdFromFirestore');

          if (userIdFromFirestore == currentUser.uid) {
            print('User IDs match. Showing camera icon.');
            setState(() {
              _showCameraIcon = true;
            });
          } else {
            print('User IDs do not match. Hiding camera icon.');
            setState(() {
              _showCameraIcon = false;
            });
          }
        } else {
          setState(() {
            _errorMessage = 'User document not found.';
          });
        }

        // Cast businessData to a Map<String, dynamic> before accessing its keys
        final data = widget.businessData.data() as Map<String, dynamic>;
        final List<dynamic>? images = data['businessVrImages'] as List<dynamic>?;

        if (images != null && images.isNotEmpty) {
          setState(() {
            thumbList = images.map((imageUrl) => Thumbnail(imagePath: imageUrl, thumbPath: imageUrl)).toList();
          });
        } else {
          setState(() {
            _errorMessage = 'No images found for this business.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'You need to be logged in to access the camera.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load images. Please try again later.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.businessData.data() as Map<String, dynamic>;


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
        actions: [
          if (_showCameraIcon && _auth.currentUser?.uid.toString() == data["userId"]) ...[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(),
                  ),
                );
              },
              icon: Icon(Clarity.camera_solid, color: primaryBlueColor, size: 15,),
            ),
          ],
        ],
        leading: IconButton(
          onPressed: () { Navigator.pop(context); },
          icon: Icon(Icons.arrow_back_ios_new, color: primaryBlueColor, size: 15,),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            itemCount: thumbList.length,
            itemBuilder: (context, index) {
              return thumbList[index];
            },
          ),
        ),
      ),
    );
  }
}
