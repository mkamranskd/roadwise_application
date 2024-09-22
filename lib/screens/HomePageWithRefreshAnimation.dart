import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rive/rive.dart' as rive;
import 'package:roadwise_application/hierarchical/loadeducationsystemscreen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../features/presentation/pages/credentials/sign_in_page.dart';
import '../features/presentation/pages/user/user_profile.dart';
import '../global/style.dart';
import '../hierarchical/UnderTestingActualLoadingEducationFromFirebase.dart';
import 'chatbot.dart';

final _auth = FirebaseAuth.instance;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
  }

  final double _offsetToArm = 220.0;
  String _profilePictureUrl = '';
  final double _profileCompletion = 110;
  final double progress = 0.0;

  Future<void> _loadProfilePicture() async {
    try {
      final userDoc = FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth.currentUser!.uid);
      final userData = await userDoc.get();

      if (userData.exists) {
        final profilePictureUrl = userData['profilePicture'];
        setState(() {
          _profilePictureUrl =
              profilePictureUrl ?? ''; // Set the profile picture URL
        });
      }
    } catch (e) {
      print('Error loading profile picture: $e');
    }
  }

  Widget buildCustomContainer({
    required Function() onTap,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ZoomTapAnimation(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 35, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Dubai',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Dubai',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int selectedIndex = 0;

  void updateIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  _rowButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildButton(0, "All"),
        _buildButton(1, "My Posts"),
        _buildButton(2, "Mentions"),
      ],
    );
  }

// Helper method to build each button
  Widget _buildButton(int index, String text) {
    bool isSelected = selectedIndex == index;
    return ZoomTapAnimation(
      child: GestureDetector(
        onTap: () {
          updateIndex(index);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.transparent,
              ),
      
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomRefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 2)),
        offsetToArmed: _offsetToArm,
        builder: (context, child, controller) => AnimatedBuilder(
          animation: controller,
          child: child,
          builder: (context, child) {
            return Stack(
              children: [
                // Rive Animation showing during refresh
                SizedBox(
                  width: double.infinity,
                  height: _offsetToArm * controller.value,
                  child: const rive.RiveAnimation.asset(
                    "assets/raster-graphics-example.riv",
                    fit: BoxFit.cover,
                  ),
                ),
                // The child content (Scaffold’s body)
                Transform.translate(
                  offset: Offset(0.0, _offsetToArm * controller.value),
                  child: controller.isLoading
                      ? Center(
                          child: LoadingAnimationWidget.inkDrop(
                          color: Colors.blue,
                          size: 25,
                        ))
                      : child,
                ),
              ],
            );
          },
        ),
        // Child is now a ListView to support scrolling and refresh
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  ZoomTapAnimation(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProfileScreen(
                                    user: _auth.currentUser!)),
                          );
                        });
                      },
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: _profilePictureUrl.isNotEmpty
                                    ? NetworkImage(_profilePictureUrl)
                                    : const AssetImage(
                                        "assets/icons/user1.png",
                                      ) as ImageProvider<Object>,
                              ),
                              // Circular progress bar around the avatar
                              SizedBox(
                                width: 45,
                                height: 45,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  // Value between 0.0 and 1.0
                                  strokeWidth: 1,
                                  backgroundColor: Colors.grey[300],
                                  // Background color of the progress bar
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.blue), // Progress color
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          if (_profileCompletion < 100.0) ...[
                            Container(
                              width: 50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "$_profileCompletion%",
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    // Rounded corners for progress bar
                                    child: LinearProgressIndicator(
                                      value: _profileCompletion / 100,
                                      // Value between 0.0 and 1.0
                                      backgroundColor: Colors.grey[300],
                                      // Background color of the progress bar
                                      color: Colors.blue,
                                      // Color of the progress indicator
                                      minHeight:
                                          2, // Height of the progress bar
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                      child: SizedBox(
                    width: 10,
                  )),
                  const Center(
                    child: Text(
                      "HOME",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const Expanded(
                      child: SizedBox(
                    width: 10,
                  )),
                  ZoomTapAnimation(
                    child: IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.blue),
                        iconColor: WidgetStateProperty.all(Colors.white),
                        iconSize: WidgetStateProperty.all(25),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Logout'),
                              icon: RightWay(height: 50),
                              content: const Text(
                                  'Are you sure you want to logout?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _auth.signOut().then((value) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignInScreen()),
                                      );
                                    }).onError((error, stackTrace) {
                                      Utils.toastMessage(
                                          context,
                                          error.toString(),
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
                      icon: const Icon(
                        Clarity.logout_line,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            /*Welcome to roadwise*/
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                    image: const AssetImage('assets/images/cardBackblue.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.8),
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      RightWay(height: 110),
                      const Text(
                        'Welcome to RightWay',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Find Your Right Way To Success.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontFamily: 'Dubai',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ZoomTapAnimation(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EducationDropdownScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Start Now',
                            style: TextStyle(
                              fontFamily: 'Dubai',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                children: [
                  ZoomTapAnimation(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CustomPageRoute(child: Chatbot()),
                        );
                      },
                      child: const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Icon(Clarity.chat_bubble_line),
                              SizedBox(
                                width: 20,
                              ),
                              Text("AI ChatBot")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ZoomTapAnimation(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EducationalChart()),
                        );
                      },
                      child: const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Icon(Clarity.flow_chart_line),
                              SizedBox(
                                width: 20,
                              ),
                              Text("Education System FLow")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Your Next Move",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [_rowButtons()],
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: Row(
                    children: [

                      buildCustomContainer(
                        onTap: () {},
                        icon: Clarity.lightbulb_line,
                        title: 'Explore',
                        subtitle: 'Discover Courses\nExpand Knowledge',
                        gradientColors: const [
                          Color(0xFF42A5F5),
                          Color(0xFF66BB6A)
                        ],
                      ),
                      buildCustomContainer(
                        onTap: () {},
                        icon: Clarity.wand_line,
                        title: 'Achieve',
                        subtitle: 'Top Performance\nEarn Rewards',
                        gradientColors: const [
                          Color(0xFFFFA726),
                          Color(0xFFF44336)
                        ],
                      ),
                      buildCustomContainer(
                        onTap: () {},
                        icon: Clarity.calendar_line,
                        title: 'Plan',
                        subtitle: 'Stay Organized\nManage Time',
                        gradientColors: const [
                          Color(0xFF29B6F6),
                          Color(0xFFAB47BC)
                        ],
                      ),
                      buildCustomContainer(
                        onTap: () {},
                        icon: Clarity.settings_line,
                        title: 'Settings',
                        subtitle: 'Personalize\nAdjust Preference',
                        gradientColors: const [
                          Color(0xFF26C6DA),
                          Color(0xFFEF5350)
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
