import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/sign_in_page.dart';
import 'package:roadwise_application/features/presentation/pages/jobs_page/job_details.dart';
import 'package:roadwise_application/global/Utils.dart';
import '../features/presentation/pages/dashHome.dart';
import '../features/presentation/pages/user_profile.dart';
import 'chat_screen.dart';
import 'chatbot.dart';
final _auth = FirebaseAuth.instance;

void main() {
  ifBusinessAccount();
  runApp(const DashBoard());
}

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
        useMaterial3: true,
      ),
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  static _FirstPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_FirstPageState>();

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  void navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            const HomeScreen(),
            const Screen2(),
            const NotificationScreen(),
            BookMarks_Page(),
            AccountSettingsScreen(),
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: primaryBlueColor,
          unselectedItemColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedIconTheme: IconThemeData(size: 32),
          iconSize: 20,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? Icon(
                Clarity.home_solid,
                color: primaryBlueColor,
              )
                  : const Icon(
                Clarity.home_line,
                color: Colors.grey,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? Icon(
                Clarity.email_solid,
                color: primaryBlueColor,
              )
                  : const Icon(
                Clarity.email_line,
                color: Colors.grey,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? Icon(
                Icons.search_rounded,
                color: primaryBlueColor,
              )
                  : const Icon(
                Clarity.search_line,
                color: Colors.grey,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 3
                  ? Icon(
                Clarity.book_solid,
                color: primaryBlueColor,
              )
                  : const Icon(
                Clarity.book_line,
                color: Colors.grey,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 4
                  ? Icon(
                Clarity.user_solid,
                color: primaryBlueColor,
              )
                  : const Icon(
                Clarity.user_line,
                color: Colors.grey,
              ),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  String _profilePictureUrl = ''; // Store the profile picture URL here

  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
  }

  Future<void> _loadProfilePicture() async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('Users').doc(_auth.currentUser!.uid);
      final userData = await userDoc.get();

      if (userData.exists) {
        final profilePictureUrl = userData['profilePicture'];
        setState(() {
          _profilePictureUrl = profilePictureUrl ?? ''; // Set the profile picture URL
        });
      }
    } catch (e) {
      print('Error loading profile picture: $e');
    }
  }
  void _showCustomDialog(BuildContext context,String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context,) {
        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),

          ),
          icon: Image.asset('assets/roadwiselogo.png',height: 100,),
          content: Text(
            msg,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 45,
        title: Center(
          child: Text(
            "Home",
            style: TextStyle(
              color: primaryBlueColor,
              fontFamily: 'Dubai',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const SignInScreen()),
                            );
                          }).onError((error, stackTrace) {
                            Utils.toastMessage(context, error.toString(), Icons.warning_amber_rounded);
                          });
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Clarity.logout_line, color: primaryBlueColor, size: 23),
          ),
        ],
        leading: GestureDetector(
          onTap: () {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        UserProfileScreen(user: _auth.currentUser!)),
              );
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: CircleAvatar(
              backgroundImage: _profilePictureUrl.isNotEmpty
                  ? NetworkImage(_profilePictureUrl)
                  : const AssetImage("assets/icons/user.png",) as ImageProvider<Object>,
            ),
          ),
        ),
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
        
            children: [

              /*Welcome to roadwise*/
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1C7EF4), Color(0xFF1976D2)], // Adjust colors as needed
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  image: DecorationImage(
                    image: const AssetImage('assets/images/cardBackblue.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), // Adjust opacity as needed
                      BlendMode.dstATop,
                    ),
                  ),
                ),
        
                child:
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset('assets/roadwiselogo.png',height: 110,),
                      const SizedBox(height: 20),
                      const Text(
                        'Welcome to ROADWISE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Dubai',
                        ),
                      ),
                      const SizedBox(height: 10),
        
                      const Text(
                        "Find Your Roadmap To Success.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontFamily: 'Dubai',
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Colors.white , // Button background color
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Start Now',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryBlueColor,
                            fontFamily: 'Dubai',
                          ),
                        ),
                      ),
        
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        FirstPage.of(context)?.navigateToPage(2);
                      },
                      child: Container(
                        height: 200,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                            colors: [Color(0xFF1C7EF4), Color(0xFFFFD580)], // Adjust colors as needed
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),

                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Clarity.search_line,size: 35,color:Colors.white),
                              SizedBox(height: 10),
                              Text(
                                'Search',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Dubai',
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Popular Institutes\nBright Students",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontFamily: 'Dubai',
                                ),
                              ),
                              SizedBox(height: 15),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfileScreen(user: _auth.currentUser!)),
                        );
                        },
                      child: Container(
                        height: 200,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                            colors: [Color(0xFF1C7EF4), Color(0xFF90EE90)], // Adjust colors as needed
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),

                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Clarity.user_line,size: 35,color:Colors.white),
                              SizedBox(height: 10),
                              Text(
                                'My Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Dubai',
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "View Profile\nEdit Profile",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontFamily: 'Dubai',
                                ),
                              ),
                              SizedBox(height: 15),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),

              GestureDetector(
                onTap: (){
                  _showCustomDialog(context,"Front-end\n          Neha Urooj\nBack-end\n          Muhammad Kamran");
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                      colors: [Color(0xFF000000), Color(0xFF1C7EF4)], // Adjust colors as needed
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),

                  ),

                  child:
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Bootstrap.code,size: 35,color:Colors.white),
                        SizedBox(height: 10),
                        Text(
                          'About Developers',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Dubai',
                          ),
                        ),
                        SizedBox(height: 10),



                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlueColor,
        tooltip: 'Connect To Assistant',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Chatbot()),
          );
        },
        child: const Icon(AntDesign.message_fill,color:Colors.white ,),
      ),
    );
  }
}


class NotificationCard extends StatelessWidget {
  final String instituteName;
  final String newsTitle1;
  final String newsTitle2;
  final IconData iconData;

  NotificationCard({
    required this.instituteName,
    required this.newsTitle1,
    required this.newsTitle2,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(iconData),
        title: Text(instituteName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              newsTitle1,
              style: const TextStyle(color: Colors.red),
            ),
            Text(newsTitle2),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            // Add your onPressed logic here
          },
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String jobTitle;
  final String instituteName;
  final String location;
  final String salary;
  final String description;
  final Icon ico;

  const JobCard({
    Key? key,
    required this.jobTitle,
    required this.instituteName,
    required this.location,
    required this.salary,
    required this.description,
    required this.ico,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JobDetailsScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.all(0),
          width: 350,
          child: Card(
            color: Colors.white,
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: primaryBlueColor,
                    child: const Icon(
                      Icons.work,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    jobTitle,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(instituteName,
                      style: const TextStyle(
                        color: Colors.grey,
                      )),
                  trailing: ico,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          // Adding space between badges
                          _buildBadge("Full-Time"),
                          const SizedBox(width: 8),
                          // Adding space between badges
                          _buildBadge("Remote"),
                          const SizedBox(width: 8),
                          // Adding space between badges
                          _buildBadge("Internship"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                size: 15,
                                Clarity.map_marker_solid,
                                color: primaryBlueColor,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                location,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                'Rs $salary/hr',
                                style: TextStyle(
                                    color: primaryBlueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildBadge(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(0.1),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 45,
        title: Center(
          child: Text(
            'Messages',
            style: TextStyle(
                color: primaryBlueColor,
                fontFamily: 'Dubai',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body:const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Open any Profile to Send Message"),
          ],
        ),
      ],),
    );
  }
}


class MessageCard extends StatelessWidget {
  final Message message;

  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(message: message)),
          );
        },
        leading: CircleAvatar(
          child:
              Text(message.sender[0]), // Display first letter of sender's name
        ),
        title: Text(message.sender),
        subtitle: Text(message.message),
        trailing: Text(message.timestamp),
      ),
    );
  }
}

class Message {
  final String image;
  final String sender;
  final String message;
  final String timestamp;

  Message({
    required this.image,
    required this.sender,
    required this.message,
    required this.timestamp,
  });
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: UsersListScreen(),
    );
  }
}

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<NotificationItem> notifications = [
    NotificationItem(
      heading: 'Meeting Reminder',
      description: 'Don\'t forget the team meeting at 9:00 AM',
      time: '9:00 AM',
    ),
    NotificationItem(
      heading: 'Assignment Deadline',
      description: 'Submit your assignment before 10:00 AM',
      time: '10:00 AM',
    ),
    NotificationItem(
      heading: 'Event Invitation',
      description: 'You\'re invited to the party tonight at 7:00 PM',
      time: '11:00 AM',
    ),
    NotificationItem(
      heading: 'Doctor Appointment',
      description: 'Your appointment with Dr. Smith is at 2:30 PM',
      time: '1:30 PM',
    ),
    NotificationItem(
      heading: 'Grocery Shopping',
      description: 'Remember to buy milk and eggs',
      time: '3:00 PM',
    ),
    NotificationItem(
      heading: 'Birthday Reminder',
      description: 'Wish Sarah a happy birthday today',
      time: '4:00 PM',
    ),
    NotificationItem(
      heading: 'Project Deadline',
      description: 'Project proposal submission due tomorrow',
      time: '5:00 PM',
    ),
    NotificationItem(
      heading: 'Movie Night',
      description: 'Join us for a movie night at 7:00 PM',
      time: '6:00 PM',
    ),
    NotificationItem(
      heading: 'Dentist Appointment',
      description: 'Dental checkup scheduled for next week',
      time: '8:00 PM',
    ),
    NotificationItem(
      heading: 'Family Dinner',
      description: 'Family dinner at your favorite restaurant',
      time: '9:00 PM',
    ),
    NotificationItem(
      heading: 'Meeting Reminder',
      description: 'Don\'t forget the team meeting at 9:00 AM',
      time: '9:00 AM',
    ),
    NotificationItem(
      heading: 'Assignment Deadline',
      description: 'Submit your assignment before 10:00 AM',
      time: '10:00 AM',
    ),
    NotificationItem(
      heading: 'Event Invitation',
      description: 'You\'re invited to the party tonight at 7:00 PM',
      time: '11:00 AM',
    ),
    NotificationItem(
      heading: 'Doctor Appointment',
      description: 'Your appointment with Dr. Smith is at 2:30 PM',
      time: '1:30 PM',
    ),
    NotificationItem(
      heading: 'Grocery Shopping',
      description: 'Remember to buy milk and eggs',
      time: '3:00 PM',
    ),
    NotificationItem(
      heading: 'Birthday Reminder',
      description: 'Wish Sarah a happy birthday today',
      time: '4:00 PM',
    ),
    NotificationItem(
      heading: 'Project Deadline',
      description: 'Project proposal submission due tomorrow',
      time: '5:00 PM',
    ),
    NotificationItem(
      heading: 'Movie Night',
      description: 'Join us for a movie night at 7:00 PM',
      time: '6:00 PM',
    ),
    NotificationItem(
      heading: 'Dentist Appointment',
      description: 'Dental checkup scheduled for next week',
      time: '8:00 PM',
    ),
    NotificationItem(
      heading: 'Family Dinner',
      description: 'Family dinner at your favorite restaurant',
      time: '9:00 PM',
    ),
    NotificationItem(
      heading: 'Meeting Reminder',
      description: 'Don\'t forget the team meeting at 9:00 AM',
      time: '9:00 AM',
    ),
    NotificationItem(
      heading: 'Assignment Deadline',
      description: 'Submit your assignment before 10:00 AM',
      time: '10:00 AM',
    ),
    NotificationItem(
      heading: 'Event Invitation',
      description: 'You\'re invited to the party tonight at 7:00 PM',
      time: '11:00 AM',
    ),
    NotificationItem(
      heading: 'Doctor Appointment',
      description: 'Your appointment with Dr. Smith is at 2:30 PM',
      time: '1:30 PM',
    ),
    NotificationItem(
      heading: 'Grocery Shopping',
      description: 'Remember to buy milk and eggs',
      time: '3:00 PM',
    ),
    NotificationItem(
      heading: 'Birthday Reminder',
      description: 'Wish Sarah a happy birthday today',
      time: '4:00 PM',
    ),
    NotificationItem(
      heading: 'Project Deadline',
      description: 'Project proposal submission due tomorrow',
      time: '5:00 PM',
    ),
    NotificationItem(
      heading: 'Movie Night',
      description: 'Join us for a movie night at 7:00 PM',
      time: '6:00 PM',
    ),
    NotificationItem(
      heading: 'Dentist Appointment',
      description: 'Dental checkup scheduled for next week',
      time: '8:00 PM',
    ),
    NotificationItem(
      heading: 'Family Dinner',
      description: 'Family dinner at your favorite restaurant',
      time: '9:00 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: primaryBlueColor,
              child: Text(
                '${index + 1}',
                // Display the index of the notification (starting from 1)
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(notification.heading),
            subtitle: Text(notification.description),
            trailing: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  notifications.removeAt(index);
                });
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NotificationDetails(notification: notification),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class NotificationItem {
  final String heading;
  final String description;
  final String time;

  NotificationItem({
    required this.heading,
    required this.description,
    required this.time,
  });
}

class NotificationDetails extends StatelessWidget {
  final NotificationItem notification;

  const NotificationDetails({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        title: Center(
          child: Text(
            'Notification Details',
            style: TextStyle(
                color: primaryBlueColor,
                fontFamily: 'Dubai',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.heading,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(notification.description),
            const SizedBox(height: 8.0),
            Text('Time: ${notification.time}'),
          ],
        ),
      ),
    );
  }
}

class BookMarks_Page extends StatelessWidget {
  BookMarks_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // You can customize the color as needed

        toolbarHeight: 45,
        title: Center(
          child: Text(
            'Bookmarks',
            style: TextStyle(
                color: primaryBlueColor,
                fontFamily: 'Dubai',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SizedBox(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            JobCard(
              jobTitle: 'Software Engineer',
              instituteName: 'ABC Tech',
              location: 'New York',
              salary: 'Rs.5000-Rs.50000',
              description: 'a quick brown fox jumps over the lazy dog.',
              ico: Icon(
                Icons.bookmark,
                color: primaryBlueColor,
              ),
            ),
            JobCard(
              jobTitle: 'Data Analyst',
              instituteName: 'XYZ Inc.',
              location: 'Dubai',
              salary: 'Rs.45000',
              description: 'a quick brown fox jumps over the lazy dog.',
              ico: Icon(
                Icons.bookmark,
                color: primaryBlueColor,
              ),
            ),
            JobCard(
              jobTitle: 'Data Analyst',
              instituteName: 'XYZ Inc.',
              location: 'San Francisco',
              salary: 'Rs.45000',
              description: 'a quick brown fox jumps over the lazy dog.',
              ico: Icon(
                Icons.bookmark,
                color: primaryBlueColor,
              ),
            ),
            JobCard(
              jobTitle: 'Security Analyst',
              instituteName: 'DBR Solutions.',
              location: 'Karachi',
              salary: 'Rs.45000',
              description: 'a quick brown fox jumps over the lazy dog.',
              ico: Icon(
                Icons.bookmark,
                color: primaryBlueColor,
              ),
            ),
            // Add more JobCard widgets here
          ],
        ),
      ),
    );
  }
}

class AccountSettingsScreen extends StatefulWidget {
  final User user = FirebaseAuth.instance.currentUser!;
  AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();

}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final auth = FirebaseAuth.instance;

  File? _image;
  bool isBusinessProfile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 45,
          title: Center(
            child: Text(
              'Profile',
              style: TextStyle(
                color: primaryBlueColor,
                fontFamily: 'Dubai',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        ),
        backgroundColor: Colors.white,
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.user.uid)
              .get(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
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
              final fullName = userData['fullName'] ?? '';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(

                      elevation: 4, // Adjust elevation as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // Adjust border radius as needed
                      ),
                      child: ListTile(

                        contentPadding: const EdgeInsets.all(16), // Adjust padding as needed
                        leading: CircleAvatar(
                          backgroundImage: _image != null
                              ? FileImage(_image!) as ImageProvider<Object>
                              : userData['profilePicture'] != null
                              ? NetworkImage(userData['profilePicture'])
                              : const AssetImage('assets/icons/person_icon.png') as ImageProvider<Object>,
                          radius: 32,

                        ),
                        title: Text(
                          fullName.isNotEmpty ? fullName : 'Name Not Provided',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Dubai',
                          ),
                        ),
                        // Add subtitle if needed
                         subtitle: Row(
                           children: [
                             CircleAvatar(
                               backgroundColor: Colors.blue,
                               radius: 12,
                               child: Icon(
                                 userData['businessAccount'] == "true"
                                     ? Icons.business
                                     : Icons.person,
                                 size: 15,
                                 color: Colors.white,
                               ),
                             ),
                             const SizedBox(width: 10,),
                             Text(userData["businessAccount"]=="true"? 'Business Account': 'Student Account'),
                           ],
                         ),

                      ),
                    ),
                    if(userData["businessAccount"]=="true") ...[
                      ListTile(
                        leading: const Icon(Icons.business),
                        title: const Text(
                          'Business Profile' ,
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



                    ] else ...[
                      ListTile(
                        leading: const Icon(Clarity.user_line),
                        title: const Text(
                          'Profile' ,
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

                    ],

                    const Divider(
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30, left: 0),
                      child: Column(
                        children: [
                          //sizeVer(20),

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
          },
        ),
      ),
    );
  }
}

