import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:roadwise_application/screens/dashboard_screen.dart';
import 'package:roadwise_application/vr/galleryVr.dart';
import '../features/presentation/pages/user/user_edit_profile.dart';
import 'chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

final _auth = FirebaseAuth.instance;

Future<void> makePhoneCall(String phoneNumber) async {
  var status = await Permission.phone.status;
  if (status.isDenied) {
    // You can request the permission here
    if (await Permission.phone.request().isGranted) {
      _launchCaller(phoneNumber);
    }
  } else if (status.isGranted) {
    _launchCaller(phoneNumber);
  } else {
    // Handle other cases
    throw 'Permission denied';
  }
}

void _launchCaller(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  if (await canLaunch(launchUri.toString())) {
    await launch(launchUri.toString());
  } else {
    throw 'Could not launch $launchUri';
  }
}

class BusinessPageScreen extends StatelessWidget {
  final DocumentSnapshot businessData;

  BusinessPageScreen({required this.businessData});

  Widget _buildEducationSection(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Education')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: LoadingAnimationWidget.inkDrop(
            color: primaryBlueColor,
            size: 25,
          ));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const BusinessProfileCustomSmallHeading(
            title: 'EDUCATION',
            value: 'No Educational Details Available',
          );
        } else {
          final educationDocs = snapshot.data!.docs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'EDUCATION',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: primaryBlueColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...educationDocs.map((doc) {
                          final educationData =
                              doc.data() as Map<String, dynamic>;
                          return ListTile(
                            title: Text(educationData['degree'] ?? ''),
                            subtitle: Text(
                                '${educationData['from'] ?? ''} (${educationData['year'] ?? ''})'),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildExperienceSection(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Experience')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: LoadingAnimationWidget.inkDrop(
            color: primaryBlueColor,
            size: 25,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const BusinessProfileCustomSmallHeading(
            title: 'EXPERIENCE',
            value: 'No Experience Details Available',
          );
        } else {
          final experienceDocs = snapshot.data!.docs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'EXPERIENCE',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: primaryBlueColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...experienceDocs.map((doc) {
                          final experienceData =
                              doc.data() as Map<String, dynamic>;
                          return ListTile(
                            title:
                                Text(experienceData['position'] ?? 'No Title'),
                            subtitle: Text(
                                '${experienceData['institute'] ?? 'No Company'} [ ${experienceData['from'] ?? 'No Duration'} - ${experienceData['year'] ?? 'No Duration'}]'),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildCoursesSection(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Courses')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: LoadingAnimationWidget.inkDrop(
            color: primaryBlueColor,
            size: 25,
          ));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const BusinessProfileCustomSmallHeading(
            title: 'COURSES',
            value: 'No Course Details Available',
          );
        } else {
          final coursesDocs = snapshot.data!.docs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'COURSES',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: primaryBlueColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...coursesDocs.map((doc) {
                          final courseData = doc.data() as Map<String, dynamic>;
                          return ListTile(
                            title: Text(courseData['course'] ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Duration: " + courseData['duration']),
                                Text("Year: " + courseData['year']),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildDegreeSection(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Degree')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: LoadingAnimationWidget.inkDrop(
            color: primaryBlueColor,
            size: 25,
          ));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const BusinessProfileCustomSmallHeading(
            title: 'DEGREES',
            value: 'No Degree Details Available',
          );
        } else {
          final coursesDocs = snapshot.data!.docs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'DEGREES',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: primaryBlueColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...coursesDocs.map((doc) {
                          final courseData = doc.data() as Map<String, dynamic>;
                          return ListTile(
                            title: Text(courseData['degree'] ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Duration: " + courseData['duration']),
                                Text("Year: " + courseData['year']),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ifBusinessAccount();
    Map<String, dynamic> data = businessData.data() as Map<String, dynamic>;
    String fullName = data['fullName'] ?? 'Unknown';
    String address = data['Address'] ?? 'Unknown';
    String bio = data['bio'] ?? 'Unknown';
    String since = data['since'] ?? 'Unknown';
    String phone = data['phoneNumber'] ?? '';
    String profilePicture = data['profilePicture'] ?? '';
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlueColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new,
            color: Colors.white,
              ),
        ),
        actions: [
          if (_auth.currentUser?.uid.toString() == data["userId"]) ...[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfile()),
                );
              },
              child: Icon(Clarity.edit_line, color: primaryBlueColor, size: 15),
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: primaryBlueColor,
              ),
              width: screenWidth,
              height: 300,
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(profilePicture),
                        radius: 64,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 90,
                        child: Container(
                          /*padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),*/
                          //child: Text("Active"),
                          child: const Icon(Icons.circle,
                              color: Colors.green, size: 30),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      fullName,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (data["businessAccount"] == "true") ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                color: Colors.white,
                                Clarity.phone_handset_solid,
                              ),
                              // Icon color
                              onPressed: () {
                                if (phone != '') {
                                  makePhoneCall(phone);
                                } else {
                                  Utils.toastMessage(context,
                                      "Mobile Number Not Found", Icons.error);
                                }
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Call',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                color: Colors.white,
                                AntDesign.message_fill,
                              ),
                              // Icon color
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      message: Message(
                                        image: data["profilePicture"],
                                        sender: fullName,
                                        message: "kamran",
                                        timestamp: DateTime.now().toString(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Message',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                color: Colors.white,
                                Icons.vrpano,
                              ),
                              // Icon color
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GalleryVr(
                                      businessData: businessData,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'VR Image',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                color: Colors.white,
                                Clarity.star_solid,
                              ),
                              // Icon color
                              onPressed: () {
                                Utils.toastMessage(context,
                                    "Not Integrated Yet", Icons.warning);
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              '3.5',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                color: Colors.white,
                                FontAwesomeIcons.plus,
                              ),
                              // Icon color
                              onPressed: () {
                                Utils.toastMessage(context,
                                    "Not Integrated Yet", Icons.warning);
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Follow',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ] else ...[
                    /////////////////////////////////////////////////////////For User Accounts
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                color: Colors.white,
                                AntDesign.message_fill,
                              ),
                              // Icon color
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      message: Message(
                                        image: data["profilePicture"],
                                        sender: fullName,
                                        message: "kamran",
                                        timestamp: DateTime.now().toString(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Message',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                color: Colors.white,
                                FontAwesomeIcons.userPlus,
                              ),
                              // Icon color
                              onPressed: () {
                                Utils.toastMessage(context,
                                    "Not Integrated Yet", Icons.warning);
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Add Friend',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    /////////////////////////////////////////////////////////For User Accounts
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  /*-------------------------------------------------------------------------------*/
                  if (data["businessAccount"] == "true") ...[
                    BusinessProfileCustomSmallHeading(
                      title: 'BIO',
                      value: bio,
                    ),
                    const SizedBox(height: 20),
                    BusinessProfileCustomSmallHeading(
                      title: 'Since',
                      value: since,
                    ),
                    const SizedBox(height: 20),
                    BusinessProfileCustomSmallHeading(
                      title: 'Address',
                      value: address,
                    ),
                    const SizedBox(height: 20),
                    BusinessProfileCustomSmallHeading(
                        title: 'City',
                        value:
                            '${data['city'] ?? 'City In'}, ${data['states'] ?? 'State In'}, ${data['country'] ?? 'Country'}'),
                    const SizedBox(height: 20),
                    _buildDegreeSection(data['userId']),
                    const SizedBox(height: 20),
                    _buildCoursesSection(data['userId']),
                    /*------------------------------------------------------------------*/
                  ] else ...[
                    BusinessProfileCustomSmallHeading(
                      title: 'Address',
                      value: address,
                    ),
                    const SizedBox(height: 20),
                    BusinessProfileCustomSmallHeading(
                      title: 'BIO',
                      value: bio,
                    ),
                    const SizedBox(height: 20),
                    BusinessProfileCustomSmallHeading(
                        title: 'City',
                        value:
                            '${data['city'] ?? 'City In'}, ${data['states'] ?? 'State In'}, ${data['country'] ?? 'Country'}'),
                    const SizedBox(height: 20),
                    _buildEducationSection(data['userId']),
                    const SizedBox(height: 20),
                    _buildExperienceSection(data['userId']),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
            /*-------------------------------------------------------------------------------*/
          ],
        ),
      ),
    );
  }
}
