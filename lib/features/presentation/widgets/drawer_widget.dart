import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:roadwise_application/const/app_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/sign_in_page.dart';
import 'package:roadwise_application/features/presentation/pages/user/user_profile.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:roadwise_application/screens/Test.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool isBusinessProfile = false;
  final _auth = FirebaseAuth.instance;
  String firstName = '';

  @override
  void initState() {
    super.initState();
    fetchFirstName();
    _loadProfilePicture();
  }

  File? _image;

  Future<void> _loadProfilePicture() async {
    final userRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser!.uid);
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

  Future<void> fetchFirstName() async {
    try {
      String? currentUserId = _auth.currentUser?.uid;
      if (currentUserId != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUserId)
            .get();
        if (snapshot.exists) {
          Map<String, dynamic> userData =
              snapshot.data() as Map<String, dynamic>;
          setState(() {
            firstName = userData['firstName'] + " " + userData['lastName'] ??
                'First Name Not Provided';
          });
        } else {
          print('Document does not exist');
          // Handle the case when the document does not exist
        }
      } else {
        print('Current user is null');
        // Handle the case when the current user is null
      }
    } catch (e) {
      print('Error: $e');
      // Handle other potential errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sizeVer(40),
                          SizedBox(
                            width: 90,
                            height: 90,
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : const AssetImage('assets/default_avatar.jpg')
                                      as ImageProvider,
                            ),
                          ),
                          sizeVer(10),
                          Text(
                            firstName != ''
                                ? firstName.toUpperCase()
                                : '- - - - - - - - - - - - - ',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Dubai',
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Clarity.user_line),
                      title: const Text(
                        'My Profile' ,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserProfileScreen(user: _auth.currentUser!)),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Clarity.home_line),
                      title: const Text('Profile'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Clarity.email_line),
                      title: const Text('Email'),
                      onTap: () {
                        // Handle Email settings
                      },
                    ),
                    ListTile(
                      leading: const Icon(Clarity.lock_line),
                      title: const Text('Password'),
                      onTap: () {
                        // Handle Password settings
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: const Text('Privacy'),
                      onTap: () {
                        // Handle Privacy settings
                      },
                    ),
                    ListTile(
                      leading: const Icon(Clarity.notification_line),
                      title: const Text('Notifications'),
                      onTap: () {
                        // Handle Notification settings
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 0),
            child: Column(
              children: [
                //sizeVer(20),
                ListTile(
                  leading: const Icon(Clarity.squid_line),
                  title: const Text('Business Profile'),
                  onTap: () {
                    // Handle Notification settings
                  },
                  trailing: Transform.scale(
                    scale: 0.6,
                    child: Switch(
                      value: isBusinessProfile,
                      onChanged: (value) {
                        setState(() {
                          isBusinessProfile = value;
                        });
                      },
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Clarity.settings_line),
                  title: const Text('Settings'),
                  onTap: () {
                    // Handle Notification settings
                  },
                ),

                ListTile(
                  leading: const Icon(Clarity.logout_line),
                  title: const Text('Logout'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content:
                              const Text('Are you sure you want to logout?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _auth.signOut().then((value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignInScreen()));
                                }).onError((error, stackTrace) {
                                  Utils.toastMessage(context, error.toString(),
                                      Icons.warning_amber_rounded);
                                });
                              },
                              child: const Text('Logout'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
