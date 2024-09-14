import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:roadwise_application/features/app/splash_screen/on_board_screen.dart';
import 'package:roadwise_application/features/presentation/pages/user/user_complete_profile.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/sign_in_page.dart';
import 'package:roadwise_application/global/svg_illustrations.dart';
import 'package:roadwise_application/screens/settings.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../features/presentation/pages/user_list_screen.dart';
import '../features/presentation/pages/user/user_profile.dart';
import '../hierarchical/UnderTestingActualLoadingEducationFromFirebase.dart';
import 'chat_screen.dart';
import 'chatbot.dart';
import 'package:roadwise_application/hierarchical/loadeducationsystemscreen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

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

  /*void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }*/

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

  int _selectedIndex = 0; // New selected index for navigation

  // Page Controller to manage page navigation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          const HomeScreen(),
          const ChatsScreen(),
          const NotificationScreen(),
          BookMarks_Page(),
          AccountSettingsScreen(),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        //backgroundColor: Colors.white,
        selectedItemColor: primaryBlueColor,
        unselectedItemColor: const Color(0xffADD8E6),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.jumpToPage(index); // Navigate to selected page
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Clarity.home_line),
            title: const Text(
              "Home",
              style: TextStyle(
                fontFamily: 'Dubai',
                fontWeight: FontWeight.w500,
              ),
            ),
            selectedColor: primaryBlueColor,
            activeIcon: const Icon(Clarity.home_solid),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Clarity.email_line),
            title: const Text(
              "Message",
              style: TextStyle(
                fontFamily: 'Dubai',
                fontWeight: FontWeight.w500,
              ),
            ),
            selectedColor: Colors.pink,
            activeIcon: const Icon(Clarity.email_solid),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Clarity.search_line),
            title: const Text(
              "Search",
              style: TextStyle(
                fontFamily: 'Dubai',
                fontWeight: FontWeight.w500,
              ),
            ),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Clarity.bookmark_line),
            title: const Text(
              "Bookmarks",
              style: TextStyle(
                fontFamily: 'Dubai',
                fontWeight: FontWeight.w500,
              ),
            ),
            selectedColor: primaryBlueColor,
            activeIcon: const Icon(Clarity.bookmark_solid),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Clarity.user_line),
            title: const Text(
              "Profile",
              style: TextStyle(
                fontFamily: 'Dubai',
                fontWeight: FontWeight.w500,
              ),
            ),
            selectedColor: Colors.teal,
            activeIcon: const Icon(Clarity.user_solid),
          ),
        ],
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

  void _showCustomDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          icon: Image.asset(
            'assets/roadwiselogo.png',
            height: 100,
          ),
          content: Text(
            msg,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Dubai',
              fontWeight: FontWeight.w500,
            ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 45,
              ),
              Row(
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundImage: _profilePictureUrl.isNotEmpty
                              ? NetworkImage(_profilePictureUrl)
                              : const AssetImage(
                            "assets/icons/user1.png",
                          ) as ImageProvider<Object>,
                        )

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
              const SizedBox(
                height: 20,
              ),
              /*Welcome to roadwise*/
              ZoomTapAnimation(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1C7EF4), Color(0xFF1976D2)],
                      // Adjust colors as needed
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    image: DecorationImage(
                      image: const AssetImage('assets/images/cardBackblue.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        // Adjust opacity as needed
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
                        Image.asset(
                          'assets/roadwiselogo.png',
                          height: 110,
                        ),
                        const SizedBox(height: 20),
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
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CustomPageRoute(child: Chatbot()),
                        );
                      },
                      child: ZoomTapAnimation(
                        child: Container(
                          height: 230,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            gradient: LinearGradient(
                              colors: [Color(0xFF1C7EF4), Color(0xFFFFD580)],
                              // Adjust colors as needed
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
                                Icon(Clarity.headphones_line,
                                    size: 35, color: Colors.white),
                                SizedBox(height: 10),
                                Text(
                                  'AI ChatBot',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: 'Dubai',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Chat with our Chatbot to Generate Your Career Map with AI",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontFamily: 'Dubai',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const OnBoardingScreen()),
                        );
                      },
                      child: ZoomTapAnimation(
                        child: Container(
                          height: 230,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            gradient: LinearGradient(
                              colors: [Color(0xFF1C7EF4), Color(0xFF90EE90)],
                              // Adjust colors as needed
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
                                Icon(Clarity.refresh_line,
                                    size: 35, color: Colors.white),
                                SizedBox(height: 10),
                                Text(
                                  'RESTART',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: 'Dubai',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Restart\n Application",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontFamily: 'Dubai',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ZoomTapAnimation(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Example2()),
                    );
                  },
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        colors: [Color(0xFF1C7EF4), Color(0xFFFFD580)],
                        // Adjust colors as needed
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
                          Icon(Clarity.flow_chart_line,
                              size: 35, color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            'Education System FLow',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'Dubai',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "View Education System By Level",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontFamily: 'Dubai',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        FirstPage.of(context)?.navigateToPage(2);
                      },
                      child: ZoomTapAnimation(
                        child: Container(
                          height: 200,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            gradient: LinearGradient(
                              colors: [Color(0xFF1C7EF4), Color(0xFFFFD580)],
                              // Adjust colors as needed
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
                                Icon(Clarity.search_line,
                                    size: 35, color: Colors.white),
                                SizedBox(height: 10),
                                Text(
                                  'Search',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: 'Dubai',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Popular Institutes\nBright Students",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontFamily: 'Dubai',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserProfileScreen(user: _auth.currentUser!)),
                        );
                      },
                      child: ZoomTapAnimation(
                        child: Container(
                          height: 200,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            gradient: LinearGradient(
                              colors: [Color(0xFF1C7EF4), Color(0xFF90EE90)],
                              // Adjust colors as needed
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
                                Icon(Clarity.user_line,
                                    size: 35, color: Colors.white),
                                SizedBox(height: 10),
                                Text(
                                  'My Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: 'Dubai',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "View Profile\nEdit Profile",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontFamily: 'Dubai',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  _showCustomDialog(context,
                      "Front-end\n          Neha Urooj\nBack-end\n          Muhammad Kamran");
                },
                child: ZoomTapAnimation(
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        colors: [Color(0xFF000000), Color(0xFF1C7EF4)],
                        // Adjust colors as needed
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
                          Icon(Bootstrap.code, size: 35, color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            'About Developers',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'Dubai',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          backgroundColor: primaryBlueColor,
          tooltip: 'Connect To Assistant',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Chatbot()),
            );
          },
          child: const Icon(
            AntDesign.message_fill,
            color: Colors.white,
          ),
        ),
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
              style: const TextStyle(
                color: Colors.red,
                fontFamily: 'Dubai',
                fontWeight: FontWeight.w500,
              ),
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


class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Chats"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: Row(
              children: [
                FillOutlineButton(press: () {}, text: "Recent Message"),
                const SizedBox(width: 16.0),
                FillOutlineButton(
                  press: () {},
                  text: "Active",
                  isFilled: true,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatsData.length,
              itemBuilder: (context, index) => ChatCard(
                chat: chatsData[index],
                press: () {},
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.person_add_alt_1,
        ),
      ),
    );
  }
}

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.chat,
    required this.press,
  });

  final Chat chat;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0 * 0.75),
        child: Row(
          children: [
            CircleAvatarWithActiveIndicator(
              image: chat.image,
              isActive: chat.isActive,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.name,
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(chat.time),
            ),
          ],
        ),
      ),
    );
  }
}

class FillOutlineButton extends StatelessWidget {
  const FillOutlineButton({
    super.key,
    this.isFilled = true,
    required this.press,
    required this.text,
  });

  final bool isFilled;
  final VoidCallback press;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: Colors.white),
      ),
      elevation: isFilled ? 2 : 0,
      color: isFilled ? Colors.white : Colors.transparent,
      onPressed: press,
      child: Text(
        text,
        style: TextStyle(
          color: isFilled ? const Color(0xFF1D1D35) : Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}

class CircleAvatarWithActiveIndicator extends StatelessWidget {
  const CircleAvatarWithActiveIndicator({
    super.key,
    this.image,
    this.radius = 24,
    this.isActive,
  });

  final String? image;
  final double? radius;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: NetworkImage(image!),
        ),
        if (isActive!)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF00BF6D),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor, width: 3),
              ),
            ),
          )
      ],
    );
  }
}

class Chat {
  final String name, lastMessage, image, time;
  final bool isActive;

  Chat({
    this.name = '',
    this.lastMessage = '',
    this.image = '',
    this.time = '',
    this.isActive = false,
  });
}

List chatsData = [
  Chat(
    name: "Jenny Wilson",
    lastMessage: "Hope you are doing well...",
    image: "https://i.postimg.cc/g25VYN7X/user-1.png",
    time: "3m ago",
    isActive: false,
  ),
  Chat(
    name: "Esther Howard",
    lastMessage: "Hello Abdullah! I am...",
    image: "https://i.postimg.cc/cCsYDjvj/user-2.png",
    time: "8m ago",
    isActive: true,
  ),
  Chat(
    name: "Ralph Edwards",
    lastMessage: "Do you have update...",
    image: "https://i.postimg.cc/sXC5W1s3/user-3.png",
    time: "5d ago",
    isActive: false,
  ),
  Chat(
    name: "Jacob Jones",
    lastMessage: "You’re welcome :)",
    image: "https://i.postimg.cc/4dvVQZxV/user-4.png",
    time: "5d ago",
    isActive: true,
  ),
  Chat(
    name: "Albert Flores",
    lastMessage: "Thanks",
    image: "https://i.postimg.cc/FzDSwZcK/user-5.png",
    time: "6d ago",
    isActive: false,
  ),
  Chat(
    name: "Jenny Wilson",
    lastMessage: "Hope you are doing well...",
    image: "https://i.postimg.cc/g25VYN7X/user-1.png",
    time: "3m ago",
    isActive: false,
  ),
  Chat(
    name: "Esther Howard",
    lastMessage: "Hello Abdullah! I am...",
    image: "https://i.postimg.cc/cCsYDjvj/user-2.png",
    time: "8m ago",
    isActive: true,
  ),
  Chat(
    name: "Ralph Edwards",
    lastMessage: "Do you have update...",
    image: "https://i.postimg.cc/sXC5W1s3/user-3.png",
    time: "5d ago",
    isActive: false,
  ),
];


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

class BookMarks_Page extends StatelessWidget {
  BookMarks_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Bookmarks',
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
      body: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              'Profile',
            ),
          ),
        ),
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.user.uid)
              .get(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: Colors.blue,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      elevation: 4, // Adjust elevation as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5), // Adjust border radius as needed
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        // Adjust padding as needed
                        leading: CircleAvatar(
                          backgroundImage: _image != null
                              ? FileImage(_image!) as ImageProvider<Object>
                              : userData['profilePicture'] != null
                                  ? NetworkImage(userData['profilePicture'])
                                  : const AssetImage(
                            "assets/icons/user1.png",)
                                      as ImageProvider<Object>,
                          radius: 32,
                        ),
                        title: Text(
                          fullName.isNotEmpty ? fullName : 'Name Not Provided',
                          style: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'Dubai',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // Add subtitle if needed
                        subtitle: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              child: Icon(
                                userData['businessAccount'] == "true"
                                    ? Icons.business
                                    : Clarity.user_solid,
                                size: 15,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(userData["businessAccount"] == "true"
                                ? 'Business Account'
                                : 'Student Account'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (userData["businessAccount"] == "true") ...[
                      ProfileListItem(
                        icon: Clarity.user_line,
                        title: "Business Profile",
                        ontap: () {
                          Navigator.push(
                            context,
                            CustomPageRoute(
                                child: UserProfileScreen(
                                    user: _auth.currentUser!)),
                          );
                        },
                      ),
                    ] else ...[
                      ProfileListItem(
                        icon: Clarity.user_line,
                        title: "Profile",
                        ontap: () {
                          Navigator.push(
                            context,
                            CustomPageRoute(
                                child: UserProfileScreen(
                                    user: _auth.currentUser!)),
                          );
                        },
                      ),
                    ],
                    ProfileListItem(
                        icon: Clarity.settings_line,
                        title: "Settings",
                        ontap: () {
                          Navigator.push(
                            context,
                            CustomPageRoute(child: SettingsScreen()),
                          );
                        }),
                    ProfileListItem(
                      icon: Clarity.logout_line,
                      title: "Logout",
                      ontap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Logout'),
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
                                                  const SignInScreen()));
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
