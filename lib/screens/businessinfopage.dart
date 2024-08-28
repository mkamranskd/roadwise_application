import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roadwise_application/screens/dashboard_screen.dart';
import '../features/presentation/pages/quiz/EditProfile.dart';
import '../global/Utils.dart';
import '../global/style.dart';
import '../vr/galleryVr.dart';
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

  Widget _buildExperienceSection(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Experience')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: primaryBlueColor));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('No experience data available'),
            ],
          );
        } else {
          final experienceDocs = snapshot.data!.docs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Experience',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(color: Colors.blue,thickness: 2.0,),
              ...experienceDocs.map((doc) {
                final experienceData = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(experienceData['position'] ?? 'No Title'),
                  subtitle: Text('${experienceData['institute'] ?? 'No Company'} [ ${experienceData['from'] ?? 'No Duration'} - ${experienceData['year'] ?? 'No Duration'}]'),
                );
              }).toList(),
            ],
          );
        }
      },
    );
  }


  Widget _buildEducationSection(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Education')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: primaryBlueColor);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('No education data available'),
            ],
          );
        } else {
          final educationDocs = snapshot.data!.docs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Education',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(color: Colors.blue,thickness: 2.0,),
              ...educationDocs.map((doc) {
                final educationData = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(educationData['degree'] ?? ''),
                  subtitle: Text('${educationData['from'] ?? ''} (${educationData['year'] ?? ''})'),
                );
              }).toList(),
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
          return CircularProgressIndicator(color: primaryBlueColor);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('No Courses available'),
            ],
          );
        } else {
          final coursesDocs = snapshot.data!.docs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Courses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(color: Colors.blue,thickness: 2.0,),
              ...coursesDocs.map((doc) {
                final courseData = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(courseData['course'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Duration: "+courseData['duration']),
                      Text("Year: "+courseData['year']),
                    ],
                  ),
                );
              }).toList(),
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
          return CircularProgressIndicator(color: primaryBlueColor);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('No Degrees available'),
            ],
          );
        } else {
          final coursesDocs = snapshot.data!.docs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Degree',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(color: Colors.blue,thickness: 2.0,),
              ...coursesDocs.map((doc) {
                final courseData = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(courseData['degree'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Duration: "+courseData['duration']),
                      Text("Year: "+courseData['year']),
                    ],
                  ),
                );
              }).toList(),
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

    String city = data['city'] ?? 'Unknown';
    String address = data['Address'] ?? 'Unknown';
    String bio = data['bio'] ?? 'Unknown';
    String province = data['province'] ?? 'Unknown';
    String phone = data['phoneNumber'] ?? '';

    String profilePicture = data['profilePicture'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: primaryBlueColor,
            fontFamily: 'Dubai',
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
              Icons.arrow_back_ios_new, color: primaryBlueColor, size: 15),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(profilePicture),
                  radius: 70,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  fullName,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
/*-------------------------------------------------------------------------------*/

              if (data["businessAccount"] == "true") ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [


                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: primaryBlueColor, // Background color
                            shape: BoxShape.circle, // Make the container round
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Clarity.phone_handset_solid, color: Colors.white,
                              size: 20,),
                            // Icon color
                            onPressed: (){
                              if(phone!=''){
                                makePhoneCall(phone);
                              }
                              else{
                                Utils.toastMessage(context, "Mobile Number Not Found", Icons.error);
                              }

                            },
                            iconSize: 30,
                            // Adjust the size as needed
                            padding: const EdgeInsets.all(16),
                            // Adjust the padding as needed
                            constraints: const BoxConstraints(),
                            splashRadius: 30, // Adjust the splash radius as needed
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          'Call',
                          style: TextStyle(
                            color: primaryBlueColor,
                            fontFamily: 'Dubai',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: primaryBlueColor, // Background color
                            shape: BoxShape.circle, // Make the container round
                          ),
                          child: IconButton(
                            icon: const Icon(
                              AntDesign.message_fill, color: Colors.white,
                              size: 20,),
                            // Icon color
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatScreen(
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
                            iconSize: 30,
                            // Adjust the size as needed
                            padding: const EdgeInsets.all(16),
                            // Adjust the padding as needed
                            constraints: const BoxConstraints(),
                            splashRadius: 30, // Adjust the splash radius as needed
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          'Message',
                          style: TextStyle(
                            color: primaryBlueColor,
                            fontFamily: 'Dubai',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: primaryBlueColor, // Background color
                            shape: BoxShape.circle, // Make the container round
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.vrpano, color: Colors.white, size: 20,),
                            // Icon color
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GalleryVr(businessData: businessData,),
                                ),
                              );
                            },
                            iconSize: 30,
                            // Adjust the size as needed
                            padding: const EdgeInsets.all(16),
                            // Adjust the padding as needed
                            constraints: const BoxConstraints(),
                            splashRadius: 30, // Adjust the splash radius as needed
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          'VR Image',
                          style: TextStyle(
                            color: primaryBlueColor,
                            fontFamily: 'Dubai',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: primaryBlueColor, // Background color
                            shape: BoxShape.circle, // Make the container round
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.star, color: Colors.white, size: 20,),
                            // Icon color
                            onPressed: () {
                              Utils.toastMessage(
                                  context, "Not Integrated Yet", Icons.warning);
                            },
                            iconSize: 30,
                            // Adjust the size as needed
                            padding: const EdgeInsets.all(16),
                            // Adjust the padding as needed
                            constraints: const BoxConstraints(),
                            splashRadius: 30, // Adjust the splash radius as needed
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          '3.5/5',
                          style: TextStyle(
                            color: primaryBlueColor,
                            fontFamily: 'Dubai',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: primaryBlueColor, // Background color
                            shape: BoxShape.circle, // Make the container round
                          ),
                          child: IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.plus, color: Colors.white,
                              size: 20,),
                            // Icon color
                            onPressed: () {
                              Utils.toastMessage(
                                  context, "Not Integrated Yet", Icons.warning);
                            },
                            iconSize: 30,
                            // Adjust the size as needed
                            padding: const EdgeInsets.all(16),
                            // Adjust the padding as needed
                            constraints: const BoxConstraints(),
                            splashRadius: 30, // Adjust the splash radius as needed
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          'Follow',
                          style: TextStyle(
                            color: primaryBlueColor,
                            fontFamily: 'Dubai',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'BIO',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(color: Colors.blue,thickness: 2.0,),
                Text(
                  "       $bio",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                const Text(
                  'City',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(color: Colors.blue,thickness: 2.0,),
                Text(
                  '    $city',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(color: Colors.blue,thickness: 2.0,),
                Text(
                  '    $address, $city, $province',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                _buildCoursesSection(data['userId']),
                _buildDegreeSection(data['userId']),
                /*------------------------------------------------------------------*/
              ] else
                ...[

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: primaryBlueColor, // Background color
                              shape: BoxShape
                                  .circle, // Make the container round
                            ),
                            child: IconButton(
                              icon: const Icon(
                                AntDesign.message_fill, color: Colors.white,
                                size: 20,),
                              // Icon color
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChatScreen(
                                          message: Message(
                                            image: data["profilePicture"],
                                            sender: fullName,
                                            message: "kamran",
                                            timestamp: DateTime.now()
                                                .toString(),
                                          ),
                                        ),
                                  ),
                                );
                              },
                              iconSize: 30,
                              // Adjust the size as needed
                              padding: const EdgeInsets.all(16),
                              // Adjust the padding as needed
                              constraints: const BoxConstraints(),
                              splashRadius: 30, // Adjust the splash radius as needed
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                            'Message',
                            style: TextStyle(
                              color: primaryBlueColor,
                              fontFamily: 'Dubai',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: primaryBlueColor, // Background color
                              shape: BoxShape
                                  .circle, // Make the container round
                            ),
                            child: IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.userPlus, color: Colors.white,
                                size: 20,),
                              // Icon color
                              onPressed: () {
                                Utils.toastMessage(
                                    context, "Not Integrated Yet",
                                    Icons.warning);
                              },
                              iconSize: 30,
                              // Adjust the size as needed
                              padding: const EdgeInsets.all(16),
                              // Adjust the padding as needed
                              constraints: const BoxConstraints(),
                              splashRadius: 30, // Adjust the splash radius as needed
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                            'Add Friend',
                            style: TextStyle(
                              color: primaryBlueColor,
                              fontFamily: 'Dubai',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'BIO',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(color: Colors.blue,thickness: 2.0,),
                        Text(
                          "       $bio",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'City',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(color: Colors.blue,thickness: 2.0,),
                        Text(
                          '    $city',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Location',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(color: Colors.blue,thickness: 2.0,),
                        Text(
                          '    $address, $city, $province',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        _buildEducationSection(data['userId']),
                        _buildExperienceSection(data['userId']),


                      ],
                    ),
                  ),


                ],
/*-------------------------------------------------------------------------------*/
            ],
          ),
        ),
      ),
    );
  }

}