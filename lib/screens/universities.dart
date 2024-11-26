import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../global/style.dart'; // For HTTP requests
import 'package:cloud_firestore/cloud_firestore.dart';

class Universities extends StatefulWidget {
  @override
  _UniversitiesState createState() => _UniversitiesState();
}

// Function to launch a URL
Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

// Function to make a phone call
Future<void> makePhoneCall(String phoneNumber) async {
  var status = await Permission.phone.status;
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  await launchUrl(launchUri);
  if (status.isDenied) {
    if (await Permission.phone.request().isGranted) {
      final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
      await launchUrl(launchUri);
    }
  } else if (status.isGranted) {
    _launchCaller(phoneNumber);
  } else {
    throw 'Permission denied';
  }
}

// Function to launch the caller app
void _launchCaller(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunch(launchUri.toString())) {
    await launch(launchUri.toString());
  } else {
    throw 'Could not launch $launchUri';
  }
}

class _UniversitiesState extends State<Universities> {
  bool isLoading = true;
  List<QueryDocumentSnapshot> universities = [];
  List<QueryDocumentSnapshot> filteredUniversities = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchUniversities();
  }

  // Function to fetch universities
  Future<void> fetchUniversities() async {
    final String path = '/countries/Pakistan/states/Sindh/universities';
    try {
      var snapshot = await FirebaseFirestore.instance.collection(path).get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          universities = snapshot.docs;
          filteredUniversities = universities; // Initialize filtered list
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching universities: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to filter the list based on the search query
  void filterUniversities(String query) {
    setState(() {
      searchQuery = query;
      filteredUniversities = universities.where((university) {
        String name = university['name'].toLowerCase();
        String shortFormName = university['shortFormName'].toLowerCase();
        return name.contains(query.toLowerCase()) ||
            shortFormName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Universities'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: (value) => filterUniversities(value),
              decoration: InputDecoration(
                hintText: 'Search universities...',
                prefixIcon: const Icon(Clarity.search_line),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(
              child: LoadingAnimationWidget.discreteCircle(
                        color: Colors.white,
                        size: 25,
                      ),
            )
            : filteredUniversities.isEmpty
                ? const Center(
                    child: Text(
                      'No universities found',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredUniversities.length,
                    itemBuilder: (context, index) {
                      var university = filteredUniversities[index];
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),

                            ),
                            child: ExpansionTile(
                              tilePadding:
                                  const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              title: ListTile(
                                tileColor: Colors.transparent,
                                leading: CircleAvatar(
                                  backgroundImage:
                                      university['logoUrl'] != null &&
                                              university['logoUrl']!.isNotEmpty
                                          ? NetworkImage(university['logoUrl'])
                                          : const AssetImage('assets/error.png')
                                              as ImageProvider,
                                ),
                                title: Text(university['name']),
                                subtitle: Text(university['shortFormName']),
                              ),
                              children: [
                                university['newsAPI'] != ''
                                    ? ListTile(
                                        title: const Text("See Notification"),
                                        leading: const Icon(
                                            Clarity.notification_line),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CustomPageRoute(
                                              child: NewsScreen(
                                                  newsApi:
                                                      university['newsAPI'],
                                                  logo: university['logoUrl'],
                                                  name: university['name'],
                                                  short: university['shortFormName']),
                                            ),
                                          );
                                        },
                                      )
                                    : const SizedBox.shrink(),
                                const ListTile(
                                  title: Text(
                                    "Web Links",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                university['webPage'] != ''
                                    ? ListTile(
                                        title: const Text("Open Official Page"),
                                        leading: const Icon(Icons.web_outlined),
                                        onTap: () {
                                          _launchURL(university['webPage']);
                                        },
                                      )
                                    : const SizedBox.shrink(),
                                university['studentPortal'] != ''
                                    ? ListTile(
                                        title: const Text(
                                            "Open Official Student Portal"),
                                        leading: const Icon(Clarity.user_line),
                                        onTap: () {
                                          _launchURL(
                                              university['studentPortal']);
                                        },
                                      )
                                    : const SizedBox.shrink(),
                                university['webContact'] != ''
                                    ? ListTile(
                                        title: const Text(
                                            "Open Official Contact Page"),
                                        leading: const Icon(Icons.contacts),
                                        onTap: () {
                                          _launchURL(university['webContact']);
                                        },
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    },
                  ),
      ),
    );
  }
}

class NewsScreen extends StatefulWidget {
  final String name;
  final String short;
  final String logo;
  final String newsApi;

  // Constructor to accept the JSON API string
  NewsScreen({required this.newsApi, required this.name, required this.logo,required this.short});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final _auth = FirebaseAuth.instance;

  Future<bool> checkIfSubscribed(
      String userId, String universityName) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('subscribedUniversities')
          .doc(universityName)
          .get();

      if (userDoc.exists) {

        return true; // Just having a document with the ID means it's subscribed
      }
    } catch (e) {
      print('Failed to check university subscription: $e');
    }
    return false;
  }

  Future<void> subscribeUniversity(String userId, String universityName) async {
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('subscribedUniversities')
          .doc(universityName);

      await userDocRef.set({
        'id': universityName // or any other necessary fields
      });

      print('University ID added successfully!');
    } catch (e) {
      print('Failed to add university ID: $e');
    }
  }

  Future<void> unsubscribeUniversity(String userId, String universityName) async {
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('subscribedUniversities')
          .doc(universityName);

      await userDocRef.delete();

      print('University ID removed successfully!');
    } catch (e) {
      print('Failed to remove university ID: $e');
    }
  }

  List<dynamic> newsData = [];
  bool isLoading = true;
  bool _isContactPageEnabled = false;

  void loadSubscriptionStatus() async {
    _isContactPageEnabled =
        await checkIfSubscribed(_auth.currentUser!.uid, widget.name);

    setState(() {});
  }

  // Function to fetch the JSON data
  Future<void> _fetchNewsData() async {
    try {
      final response = await http.get(Uri.parse(widget.newsApi));

      if (response.statusCode == 200) {
        setState(() {
          newsData = json.decode(response.body); // Parse the JSON data
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $e");
    }
  }

  // Function to handle switch toggling
  void onSwitchChanged(bool value) {
    setState(() {
      _isContactPageEnabled = value;
    });

    if (value) {
      subscribeUniversity(_auth.currentUser!.uid, widget.name);
      _showNotification(
          title: 'You\'ve Successfully Subscribed to ${widget.short}',
          message: 'You\'ll be updated with all notifications with RightWay');
    } else {
      unsubscribeUniversity(_auth.currentUser!.uid, widget.name);

      _showNotification(
          title: 'You\'ve Successfully unsubscribed to ${widget.short}',
          message: '');
    }
  }

  /////////////////////////////////////////////////////////Notifications
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification plugin
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show a notification
  Future<void> _showNotification(
      {required String title, required String message}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'Testing',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'background',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platformChannelSpecifics,
    );
  }

  @override
  void initState() {
    super.initState();
    loadSubscriptionStatus();
    _fetchNewsData();
    _initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News & Notification"),
      ),
      body: isLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shimmer effect for the header with logo and title
                Shimmer.fromColors(
                  baseColor: Theme.of(context).primaryColor,
                  highlightColor: Colors.white,
                  child: ListTile(
                    tileColor: Colors.transparent,
                    leading: const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/error.png') as ImageProvider,
                    ),
                    title: Shimmer.fromColors(
                      baseColor: Theme.of(context).primaryColor,
                      highlightColor: Colors.white,
                      child: Container(
                        width: double.infinity,
                        height: 10,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Shimmer.fromColors(
                      baseColor: Theme.of(context).primaryColor,
                      highlightColor: Colors.white,
                      child: Container(
                        width: double.infinity,
                        height: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Shimmer.fromColors(
                    baseColor: Theme.of(context).primaryColor,
                    highlightColor: Colors.white,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Shimmer effect for the ListView when the news data is loading
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Theme.of(context).primaryColor,
                    highlightColor: Colors.white,
                    child: ListView.builder(
                      itemCount:
                          5, // Display a few placeholder items during loading
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: const CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.grey,
                            ),
                            title: Container(
                              width: 120,
                              height: 10,
                              color: Colors.grey.shade300, // Shimmer title
                            ),
                            subtitle: Container(
                              width: 150,
                              height: 10,
                              color: Colors.grey.shade300, // Shimmer subtitle
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  tileColor: Colors.transparent,
                  leading: CircleAvatar(
                    backgroundImage: widget.logo.isNotEmpty
                        ? NetworkImage(widget.logo)
                        : const AssetImage('assets/error.png') as ImageProvider,
                  ),
                  title: Text(widget.name),
                  subtitle: const Text(
                    'News and notifications',
                  ),
                ),
                ListTile(
                  tileColor: Colors.transparent,
                  title: Text(_isContactPageEnabled
                      ? "Disable Notifications"
                      : "Enable Notifications"),
                  leading: Icon(_isContactPageEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_none),
                  trailing: Transform.scale(
                    scale: 0.5,
                    // Adjust the scale value to make the switch smaller (0.8 makes it smaller)
                    child: Switch(
                      value: _isContactPageEnabled,
                      onChanged: onSwitchChanged,
                    ),
                  ),
                ),
                /*ElevatedButton(onPressed: (){
                  Navigator.push(
                    context,
                    CustomPageRoute(child: NotificationExample()),
                  );
                }, child: const Text("data")),*/
                Expanded(
                  child: ListView.builder(
                    itemCount: newsData.length,
                    itemBuilder: (context, index) {
                      var item = newsData[index];
                      String heading = item['heading'] ?? '';
                      String notification = item['notification'] ?? '';
                      String date = item['date'] ?? '';
                      String link = item['link'] ?? '';
                      return NotificationCard(
                        heading: heading,
                        notification: notification,
                        link: link,
                        date: date,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String heading;
  final String notification;
  final String link;
  final String date;

  const NotificationCard({
    required this.heading,
    required this.notification,
    required this.link,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading != ''
                ? Text(
                    heading,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
            notification != ""
                ? Text(
                    notification,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
            date != ""
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      date,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
            link != ""
                ? Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _launchURL(link);
                          },
                          child: const Text("Open News & Notifications"),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
