import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:roadwise_application/vr/thumbnail.dart';
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
  bool _isRemoving = false;
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
        final userRef =
            FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);
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
        final List<dynamic>? images =
            data['businessVrImages'] as List<dynamic>?;

        if (images != null && images.isNotEmpty) {
          setState(() {
            thumbList = images
                .map((imageUrl) =>
                    Thumbnail(imagePath: imageUrl, thumbPath: imageUrl))
                .toList();
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

  Future<void> _refreshGallery() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    await _loadBusinessImages();
  }

  Future<void> _removeImage(String imageUrl) async {
    setState(() {
      _isRemoving = true;
    });

    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final userRef =
            FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);

        final data = widget.businessData.data() as Map<String, dynamic>;
        final List<dynamic>? images =
            data['businessVrImages'] as List<dynamic>?;

        if (images != null && images.isNotEmpty) {
          images.remove(imageUrl);
          await userRef.update({'businessVrImages': images});
          setState(() {
            thumbList.removeWhere((thumb) => thumb.imagePath == imageUrl);
            Utils.toastMessage(
                context, "Image Deleted Successfully", Icons.check);
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to remove the image. Please try again later.';
      });
    } finally {
      setState(() {
        _isRemoving = false;
      });
    }
  }

  void _showDeleteDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Image'),
        content: const Text('Are you sure you want to remove this image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeImage(imageUrl);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        widget.businessData.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VR Gallery',
        ),
        actions: [
          if (_showCameraIcon &&
              _auth.currentUser?.uid.toString() == data["userId"]) ...[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(),
                  ),
                );
              },
              icon: const Icon(
                Clarity.camera_solid,
              ),
            ),
          ],
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _isLoading
                  ?  Center(child: LoadingAnimationWidget.inkDrop(
                                color: Colors.blue,
                                size: 25,
                              ))
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : RefreshIndicator(
                          onRefresh: _refreshGallery,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 50,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: thumbList.length,
                            itemBuilder: (context, index) {
                              final imageUrl = thumbList[index].imagePath;
                              return GestureDetector(
                                onLongPress: () => _showDeleteDialog(imageUrl),
                                child: thumbList[index],
                              );
                            },
                          ),
                        ),
            ),
          ),
          if (_isRemoving)
            Center(
              child: Container(
                color: Colors.black54,
                child:  LoadingAnimationWidget.inkDrop(
                                color: Colors.blue,
                                size: 25,
                              ),
              ),
            ),
          const Positioned(
            bottom: 10,
            right: 0,
            left: 0,
            child: Text(
              'Note: Long press to remove Image',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
