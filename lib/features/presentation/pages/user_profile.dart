import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roadwise_application/features/presentation/pages/quiz/starting_page.dart';
import 'package:roadwise_application/global/style.dart';

final _auth = FirebaseAuth.instance;
class UserProfileScreen extends StatefulWidget {
  final User user;

  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _updateProfilePicture(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _updateProfilePicture(File? image) async {
    if (image != null) {
      final userRef = FirebaseFirestore.instance.collection('Users').doc(widget.user.uid);
      await userRef.update({
        'profilePicture': image.path, // Assuming the path is stored in Firestore
      });
    }
  }

  Future<void> _loadProfilePicture() async {
    final userRef = FirebaseFirestore.instance.collection('Users').doc(widget.user.uid);
    final snapshot = await userRef.get();
    final userData = snapshot.data();
    if (userData != null) {
      final profilePicturePath = userData['profilePicture'];
      if (profilePicturePath != null) {
        setState(() {
          _image = File(profilePicturePath);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfilePicture(); // Load profile picture when the screen initializes
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 45,
        title: Text(
          'Profile',
          style: TextStyle(
            color: primaryBlueColor,
            fontFamily: 'Dubai',
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompleteProfile()),
              );
            },
            child: const Text(
              "Complete Profile",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('Users').doc(widget.user.uid).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryBlueColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          } else {
            final userData = snapshot.data!.data();
            if (userData == null) {
              return const Center(child: Text('User data is null'));
            }
            final firstName = userData['firstName'] ?? '';
            final lastName = userData['lastName'] ?? '';
            final fullName = '$firstName $lastName';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: _image != null
                              ? FileImage(_image!) as ImageProvider<Object>
                              : NetworkImage(
                            userData['profilePicture']??  'assets/icons/person_icon.png',
                          ),
                          radius: 64,
                        ),

                        Positioned(
                          bottom: -18,
                          left: 97,
                          child: IconButton(
                            onPressed: _getImage,
                            icon:  Icon(Clarity.camera_solid,color: primaryBlueColor,size: 15,),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //H3(title: "Personal Information", clr: primaryBlueColor),
                  const SizedBox(height: 20),

                  const CAPTION(title: 'Full Name'),
                  Field(
                      title: fullName != ''
                          ? fullName
                          : 'First Name Not Provided'),

                  const SizedBox(height: 20),
                  const CAPTION(title: 'Age'),
                  Field(title: userData['age'] ?? 'Not Updated Yet'),

                  const SizedBox(height: 20),
                  const CAPTION(title: 'Phone Number'),
                  Field(title: userData['phoneNumber'] ?? 'Not Updated Yet'),

                  const SizedBox(height: 20),
                  const CAPTION(title: 'Email'),
                  Field(title: _auth.currentUser!.email.toString()),

                  const SizedBox(height: 20),
                  const CAPTION(title: 'Province'),
                  Field(title: userData['province'] ?? 'Not Updated Yet'),

                  const SizedBox(height: 20),
                  const CAPTION(title: 'City'),
                  Field(title: userData['city'] ?? 'Not Updated Yet'),

                  const SizedBox(height: 20),
                  const CAPTION(title: 'Address'),
                  Field(title: userData['Address'] ?? 'Not Updated Yet'),

                  Row(
                    children: [
                      H3(title: "Education", clr: primaryBlueColor),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Clarity.plus_line,
                            size: 15,
                            color: primaryBlueColor,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      H3(title: "Experience", clr: primaryBlueColor),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Clarity.plus_line,
                            size: 15,
                            color: primaryBlueColor,
                          )),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
