import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:roadwise_application/features/presentation/pages/user/user_complete_profile.dart';
import 'package:roadwise_application/features/presentation/pages/user/user_edit_profile.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:roadwise_application/global/svg_illustrations.dart';
import 'package:roadwise_application/vr/galleryVr.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';


class UserProfileScreen extends StatefulWidget {
  final User user;

  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? _image;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _navigateToGallery() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userRef =
      FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);
      final docSnapshot = await userRef.get();
      if (docSnapshot.exists) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryVr(businessData: docSnapshot),
          ),
        );
      } else {
        // Handle user document not found
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User document not found.'),
        ));
      }
    } else {
      // Handle user not logged in
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You need to be logged in to access the gallery.'),
      ));
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _updateProfilePicture(_image!);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _updateProfilePicture(File image) async {
    final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('profilePictures/${widget.user.uid}');
    final UploadTask uploadTask = storageRef.putFile(image);
    try {
      await uploadTask.whenComplete(() async {
        final String imageUrl = await storageRef.getDownloadURL();
        final userRef =
        FirebaseFirestore.instance.collection('Users').doc(widget.user.uid);
        await userRef.update({
          'profilePicture': imageUrl,
        });
        setState(() {
          _image = null;
        });
        Navigator.of(context).pop();
      });
    } catch (e) {
      Navigator.of(context).pop();
      print('Error uploading profile picture: $e');
    }
  }

  void _showEducationDialog({DocumentSnapshot? document}) {
    final TextEditingController degreeController = TextEditingController();
    final TextEditingController fromController = TextEditingController();
    final TextEditingController yearController = TextEditingController();

    if (document != null) {
      final educationData = document.data() as Map<String, dynamic>;
      degreeController.text = educationData['degree'] ?? '';
      fromController.text = educationData['from'] ?? '';
      yearController.text = educationData['year'] ?? '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(document == null ? "Add Education" : "Edit Education"),
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TEXTBOX(
                title: "Degree",
                controller: degreeController,
              ),
              TEXTBOX(
                title: "From",
                controller: fromController,
              ),
              TEXTBOX(
                title: "Year",
                controller: yearController,
              ),
              CustomButton(
                title: document == null ? "Add" : "Update",
                clr1: primaryBlueColor,
                clr2: primaryBlueColor,
                onTap: () async {
                  final degree = degreeController.text;
                  final from = fromController.text;
                  final year = yearController.text;

                  if (degree.isNotEmpty && from.isNotEmpty && year.isNotEmpty) {
                    final userRef = FirebaseFirestore.instance
                        .collection('Users')
                        .doc(widget.user.uid)
                        .collection('Education');

                    if (document == null) {
                      await userRef.add({
                        'degree': degree,
                        'from': from,
                        'year': year,
                      });
                    } else {
                      await userRef.doc(document.id).update({
                        'degree': degree,
                        'from': from,
                        'year': year,
                      });
                    }

                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showExperienceDialog({DocumentSnapshot? document}) {
    final TextEditingController instituteController = TextEditingController();
    final TextEditingController positionController = TextEditingController();
    final TextEditingController fromController = TextEditingController();
    final TextEditingController yearController = TextEditingController();

    if (document != null) {
      final experienceData = document.data() as Map<String, dynamic>;
      instituteController.text = experienceData['institute'] ?? '';
      positionController.text = experienceData['position'] ?? '';
      fromController.text = experienceData['from'] ?? '';
      yearController.text = experienceData['year'] ?? '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(document == null ? "Add Experience" : "Edit Experience"),
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TEXTBOX(
                title: "Institute",
                controller: instituteController,
              ),
              TEXTBOX(
                title: "Position",
                controller: positionController,
              ),
              TEXTBOX(
                title: "From",
                controller: fromController,
              ),
              TEXTBOX(
                title: "Year",
                controller: yearController,
              ),
              CustomButton(
                title: document == null ? "Add" : "Update",
                clr1: primaryBlueColor,
                clr2: primaryBlueColor,
                onTap: () async {
                  final institute = instituteController.text;
                  final position = positionController.text;
                  final from = fromController.text;
                  final year = yearController.text;

                  if (institute.isNotEmpty &&
                      position.isNotEmpty &&
                      from.isNotEmpty &&
                      year.isNotEmpty) {
                    final userRef = FirebaseFirestore.instance
                        .collection('Users')
                        .doc(widget.user.uid)
                        .collection('Experience');

                    if (document == null) {
                      await userRef.add({
                        'institute': institute,
                        'position': position,
                        'from': from,
                        'year': year,
                      });
                    } else {
                      await userRef.doc(document.id).update({
                        'institute': institute,
                        'position': position,
                        'from': from,
                        'year': year,
                      });
                    }

                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCourseDialog({DocumentSnapshot? document}) {
    final TextEditingController courseController = TextEditingController();
    final TextEditingController durationController = TextEditingController();
    final TextEditingController yearController = TextEditingController();

    if (document != null) {
      final courseData = document.data() as Map<String, dynamic>;
      courseController.text = courseData['course'] ?? '';
      durationController.text = courseData['duration'] ?? '';
      yearController.text = courseData['year'] ?? '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(document == null ? "Add Course" : "Edit Course"),
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TEXTBOX(
                title: "Course",
                controller: courseController,
              ),
              TEXTBOX(
                title: "Duration",
                controller: durationController,
              ),
              TEXTBOX(
                title: "Year",
                controller: yearController,
              ),
              CustomButton(
                title: document == null ? "Add" : "Update",
                clr1: primaryBlueColor,
                clr2: primaryBlueColor,
                onTap: () async {
                  final course = courseController.text;
                  final duration = durationController.text;
                  final year = yearController.text;

                  if (course.isNotEmpty &&
                      duration.isNotEmpty &&
                      year.isNotEmpty) {
                    final userRef = FirebaseFirestore.instance
                        .collection('Users')
                        .doc(widget.user.uid)
                        .collection('Courses');

                    if (document == null) {
                      await userRef.add({
                        'course': course,
                        'duration': duration,
                        'year': year,
                      });
                    } else {
                      await userRef.doc(document.id).update({
                        'course': course,
                        'duration': duration,
                        'year': year,
                      });
                    }

                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDegreeDialog({DocumentSnapshot? document}) {
    final TextEditingController degreeController = TextEditingController();
    final TextEditingController durationController = TextEditingController();
    final TextEditingController yearController = TextEditingController();

    if (document != null) {
      final degreeData = document.data() as Map<String, dynamic>;
      degreeController.text = degreeData['degree'] ?? '';
      durationController.text = degreeData['duration'] ?? '';
      yearController.text = degreeData['year'] ?? '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(document == null ? "Add Degree" : "Edit Degree"),
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TEXTBOX(
                title: "Degree",
                controller: degreeController,
              ),
              TEXTBOX(
                title: "Duration",
                controller: durationController,
              ),
              TEXTBOX(
                title: "Year",
                controller: yearController,
              ),
              CustomButton(
                title: document == null ? "Add" : "Update",
                clr1: primaryBlueColor,
                clr2: primaryBlueColor,
                onTap: () async {
                  final degree = degreeController.text;
                  final institution = durationController.text;
                  final year = yearController.text;

                  if (degree.isNotEmpty &&
                      institution.isNotEmpty &&
                      year.isNotEmpty) {
                    final userRef = FirebaseFirestore.instance
                        .collection('Users')
                        .doc(widget.user.uid)
                        .collection('Degree');

                    if (document == null) {
                      await userRef.add({
                        'degree': degree,
                        'duration': institution,
                        'year': year,
                      });
                    } else {
                      await userRef.doc(document.id).update({
                        'degree': degree,
                        'duration': institution,
                        'year': year,
                      });
                    }

                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteCourse(String docId) async {
    final userRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user.uid)
        .collection('Courses');
    await userRef.doc(docId).delete();
  }

  Future<void> _deleteDegree(String docId) async {
    final userRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user.uid)
        .collection('Degree');
    await userRef.doc(docId).delete();
  }

  Future<void> _deleteEducation(String docId) async {
    final userRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user.uid)
        .collection('Education');
    await userRef.doc(docId).delete();
  }

  Future<void> _deleteExperience(String docId) async {
    final userRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user.uid)
        .collection('Experience');
    await userRef.doc(docId).delete();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _refreshScreen(UserProfileScreen(user: _auth.currentUser!));
        },
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.user.uid)
              .get(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: primaryBlueColor,
                  size: 25,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data available'));
            } else {
              final userData = snapshot.data!.data();
              if (userData == null) {
                return InformationScreen(
                  svgString: voidd, // Provide your SVG string here
                  title: 'Incomplete Profile',
                  subtitle: 'Tell Us Something About Yourself, Complete your Profile!',
                  buttonText: 'Complete your Profile',
                  onButtonPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UserCompleteProfile()),
                    );
                  },
                );
              }
              final fullName = userData['fullName'] ?? '';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (userData["businessAccount"] == "true") ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              ZoomTapAnimation(
                                child: GestureDetector(
                                  onTap: _getImage,
                                  child: CircleAvatar(
                                    backgroundImage: _image != null
                                        ? FileImage(_image!)
                                    as ImageProvider<Object>
                                        : userData['profilePicture'] != null
                                        ? NetworkImage(
                                        userData['profilePicture'])
                                        : const AssetImage(
                                      "assets/icons/user1.png",)
                                    as ImageProvider<Object>,
                                    radius: 64,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -18,
                                left: 97,
                                child: ZoomTapAnimation(
                                  child: IconButton(
                                    onPressed: _getImage,
                                    icon: Icon(Clarity.camera_solid,
                                        color: primaryBlueColor, size: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          GestureDetector(
                            onTap: _navigateToGallery,
                            child: const Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(
                                    'assets/icons/addVr.png',
                                  ) as ImageProvider<Object>,
                                  radius: 35,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      BusinessProfileCustomSmallHeading(
                        title: 'Full Name',
                        value: fullName.isNotEmpty
                            ? fullName
                            : 'First Name Not Provided',
                      ),

                      const SizedBox(height: 20),
                      BusinessProfileCustomSmallHeading(
                        title: 'Since',
                        value: userData['since'] ?? 'Not Updated Yet',
                      ),

                      const SizedBox(height: 20),
                      BusinessProfileCustomSmallHeading(
                        title: 'Bio',
                        value: userData['bio'] ?? 'Not Updated Yet',
                      ),
                      const SizedBox(height: 20),
                      BusinessProfileCustomSmallHeading(
                        title: 'Address',
                        value: '${userData['Address'] ??
                            'Address In'}, ${userData['city'] ??
                            ' City In'}, ${userData['states'] ??
                            'State In'}, ${userData['country'] ??
                            'Country'}',
                      ),
                      const SizedBox(height: 20),
                      BusinessProfileCustomSmallHeading(
                        title: 'Office Number',
                        value: userData['phoneNumber'] ??
                            'Not Updated Yet',
                      ),
                      const SizedBox(height: 20),
                      BusinessProfileCustomSmallHeading(
                        title: 'Email',
                        value:  _auth.currentUser?.email ??
                            'Not Updated Yet',
                      ),
                      const SizedBox(height: 20),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(widget.user.uid)
                            .collection('Degree')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: LoadingAnimationWidget.inkDrop(
                                  color: primaryBlueColor,
                                  size: 25,
                                ));
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'DEGREE',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: 'Dubai',
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Expanded(child: SizedBox(width: 10)),
                                    IconButton(
                                      onPressed: () {
                                        _showDegreeDialog();
                                      },
                                      icon: const Icon(
                                        Clarity.plus_circle_solid,
                                      ),
                                    ),
                                  ],
                                ),
                                const Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text('No Degree Details available'),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            final educationDocs = snapshot.data!.docs;
                            return Column(
                              children: [
                                ListTile(
                                  title: Row(
                                    children: [
                                      const Text(
                                        'DEGREE',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontFamily: 'Dubai',
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Expanded(
                                          child: SizedBox(width: 10)),
                                      IconButton(
                                        onPressed: () {
                                          _showDegreeDialog();
                                        },
                                        icon: const Icon(
                                          Clarity.plus_circle_solid,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: educationDocs.length,
                                  itemBuilder: (context, index) {
                                    final courseData = educationDocs[index]
                                        .data() as Map<String, dynamic>;
                                    return ListTile(
                                      title: Text(courseData['degree'] ?? ''),
                                      subtitle: Text(
                                          '${courseData['duration'] ??
                                              ''} (${courseData['year'] ??
                                              ''})'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Clarity.edit_line,
                                              color: Colors.blue,
                                              size: 15,
                                            ),
                                            onPressed: () {
                                              _showDegreeDialog(
                                                  document:
                                                  educationDocs[index]);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Clarity.trash_line,
                                              color: Colors.red,
                                              size: 15,
                                            ),
                                            onPressed: () async {
                                              await _deleteDegree(
                                                  educationDocs[index].id);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(widget.user.uid)
                            .collection('Courses')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: LoadingAnimationWidget.inkDrop(
                                  color: primaryBlueColor,
                                  size: 25,
                                ));
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'COURSES',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: 'Dubai',
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Expanded(child: SizedBox(width: 10)),
                                    IconButton(
                                      onPressed: () {
                                        _showCourseDialog();
                                      },
                                      icon: const Icon(
                                        Clarity.plus_circle_solid,
                                      ),
                                    ),
                                  ],
                                ),
                                const Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text('No Course Details available'),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            final educationDocs = snapshot.data!.docs;
                            return Column(
                              children: [
                                ListTile(
                                  title: Row(
                                    children: [
                                      const Text(
                                        'COURSES',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontFamily: 'Dubai',
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Expanded(
                                          child: SizedBox(width: 10)),
                                      IconButton(
                                        onPressed: () {
                                          _showCourseDialog();
                                        },
                                        icon: const Icon(
                                          Clarity.plus_circle_solid,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: educationDocs.length,
                                  itemBuilder: (context, index) {
                                    final courseData = educationDocs[index]
                                        .data() as Map<String, dynamic>;
                                    return ListTile(
                                      title: Text(courseData['course'] ?? ''),
                                      subtitle: Text(
                                          '${courseData['duration'] ??
                                              ''} (${courseData['year'] ??
                                              ''})'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Clarity.edit_line,
                                              color: primaryBlueColor,
                                              size: 15,
                                            ),
                                            onPressed: () {
                                              _showCourseDialog(
                                                  document:
                                                  educationDocs[index]);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Clarity.trash_line,
                                              color: Colors.red,
                                              size: 15,
                                            ),
                                            onPressed: () async {
                                              await _deleteCourse(
                                                  educationDocs[index].id);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ZoomTapAnimation(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    CustomPageRoute(child: EditProfile()),
                                  );
                                },
                                child: const Text(
                                  "Edit Personal Information ",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ] else
                      ...[
                        Center(
                          child: Stack(
                            children: [
                              ZoomTapAnimation(
                                child: GestureDetector(
                                  onTap: _getImage,
                                  child: CircleAvatar(
                                    backgroundImage: _image != null
                                        ? FileImage(_image!) as ImageProvider<
                                        Object>
                                        : userData['profilePicture'] != null
                                        ? NetworkImage(userData['profilePicture'])
                                        : const AssetImage(
                                      "assets/icons/user1.png",)
                                    as ImageProvider<Object>,
                                    radius: 64,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -18,
                                left: 97,
                                child: ZoomTapAnimation(
                                  child: IconButton(
                                    onPressed: _getImage,
                                    icon: Icon(Clarity.camera_solid,
                                        color: primaryBlueColor, size: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        BusinessProfileCustomSmallHeading(
                          title: 'Full Name',
                          value: fullName.isNotEmpty
                              ? fullName
                              : 'First Name Not Provided',
                        ),

                        const SizedBox(height: 20),
                        BusinessProfileCustomSmallHeading(
                          title: 'Age',
                          value: userData['age'] ?? 'Not Updated Yet',
                        ),

                        const SizedBox(height: 20),
                        BusinessProfileCustomSmallHeading(
                          title: 'Bio',
                          value: userData['bio'] ?? 'Not Updated Yet',
                        ),
                        const SizedBox(height: 20),
                        BusinessProfileCustomSmallHeading(
                          title: 'Address',
                          value: '${userData['Address'] ??
                              'Address In'}, ${userData['city'] ??
                              ' City In'}, ${userData['states'] ??
                              'State In'}, ${userData['country'] ??
                              'Country'}',
                        ),
                        const SizedBox(height: 20),
                        BusinessProfileCustomSmallHeading(
                          title: 'Office Number',
                          value: userData['phoneNumber'] ??
                              'Not Updated Yet',
                        ),
                        const SizedBox(height: 20),
                        BusinessProfileCustomSmallHeading(
                          title: 'Email',
                          value:  _auth.currentUser?.email ??
                              'Not Updated Yet',
                        ),
                        const SizedBox(height: 20),

                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .doc(widget.user.uid)
                              .collection('Education')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: LoadingAnimationWidget.inkDrop(
                                    color: primaryBlueColor,
                                    size: 25,
                                  ));
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'EDUCATION',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontFamily: 'Dubai',
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Expanded(
                                          child: SizedBox(width: 10)),
                                      IconButton(
                                        onPressed: () {
                                          _showEducationDialog();
                                        },
                                        icon: const Icon(
                                          Clarity.plus_circle_solid,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text('No Education Details available'),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              final educationDocs = snapshot.data!.docs;
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'EDUCATION',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontFamily: 'Dubai',
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Expanded(
                                          child: SizedBox(width: 10)),
                                      IconButton(
                                        onPressed: () {
                                          _showEducationDialog();
                                        },
                                        icon: Icon(
                                          Clarity.plus_circle_solid,
                                          size: 20,
                                          color: primaryBlueColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: educationDocs.length,
                                    itemBuilder: (context, index) {
                                      final educationData = educationDocs[index]
                                          .data() as Map<String, dynamic>;
                                      return ListTile(
                                        title:
                                        Text(educationData['degree'] ?? ''),
                                        subtitle: Text(
                                            '${educationData['from'] ??
                                                ''} (${educationData['year'] ??
                                                ''})'),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Clarity.edit_line,
                                                color: primaryBlueColor,
                                                size: 15,
                                              ),
                                              onPressed: () {
                                                _showEducationDialog(
                                                    document:
                                                    educationDocs[index]);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Clarity.trash_line,
                                                color: Colors.red,
                                                size: 15,
                                              ),
                                              onPressed: () async {
                                                await _deleteEducation(
                                                    educationDocs[index].id);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .doc(widget.user.uid)
                              .collection('Experience')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: LoadingAnimationWidget.inkDrop(
                                    color: primaryBlueColor,
                                    size: 25,
                                  ));
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'EXPERIENCE',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontFamily: 'Dubai',
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Expanded(
                                          child: SizedBox(width: 10)),
                                      IconButton(
                                        onPressed: () {
                                          _showExperienceDialog();
                                        },
                                        icon: Icon(
                                          Clarity.plus_circle_solid,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text('No Experience Details available'),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              final experienceDocs = snapshot.data!.docs;
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'EXPERIENCE',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontFamily: 'Dubai',
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Expanded(
                                          child: SizedBox(width: 10)),
                                      IconButton(
                                        onPressed: () {
                                          _showExperienceDialog();
                                        },
                                        icon: Icon(
                                          Clarity.plus_circle_solid,
                                          size: 20,
                                          color: primaryBlueColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: experienceDocs.length,
                                    itemBuilder: (context, index) {
                                      final experienceData = experienceDocs[index]
                                          .data() as Map<String, dynamic>;
                                      return ListTile(
                                        title: Text(
                                            experienceData['institute'] ?? ''),
                                        subtitle: Text(
                                            '${experienceData['position'] ??
                                                ''} (${experienceData['from'] ??
                                                ''} - ${experienceData['year'] ??
                                                ''})'),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Clarity.edit_line,
                                                color: primaryBlueColor,
                                                size: 15,
                                              ),
                                              onPressed: () {
                                                _showExperienceDialog(
                                                    document:
                                                    experienceDocs[index]);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Clarity.trash_line,
                                                color: Colors.red,
                                                size: 15,
                                              ),
                                              onPressed: () async {
                                                await _deleteExperience(
                                                    experienceDocs[index].id);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ZoomTapAnimation(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      CustomPageRoute(child: EditProfile()),
                                    );
                                  },
                                  child: const Text(
                                    "Edit Personal Information ",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _refreshScreen(Widget screen) async {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
