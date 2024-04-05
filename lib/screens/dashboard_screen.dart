import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:roadwise_application/features/domain/entities/user_post_data.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/sign_in_page.dart';
import 'package:roadwise_application/features/presentation/pages/home_page/widgets/single_post_card_widget.dart';
import 'package:roadwise_application/features/presentation/pages/jobs_page/job_details.dart';
import 'package:roadwise_application/global/style.dart';
import '../features/presentation/widgets/drawer_widget.dart';
import 'chat_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() {
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
      home: const FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

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
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children:  [
          const HomeScreen(),
          const Screen2(),
          const NotificationScreen(),
          BookMarks_Page(),
          const AccountSettingsScreen(),
        ],
      ),
      bottomNavigationBar: FadeInUp(
        duration: const Duration(milliseconds: 1000),
        child: CurvedNavigationBar(
          color: primaryBlueColor,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor:primaryBlueColor ,
          height: 50,
          items: <Widget>[
            Image.asset(
              'assets/icons/home_icon.png',
              width: 15,
              height: 15,
              color: Colors.white,

            ),
            Image.asset(
              'assets/icons/mail_icon.png',
              width: 15,
              height: 15,
              color: Colors.white,
            ),
            Image.asset(
              'assets/icons/notifications_icon.png',
              width: 15,
              height: 15,
              color: Colors.white,
            ),
            Image.asset(
              'assets/icons/roadmap-planning.png',
              width: 15,
              height: 15,
              color: Colors.white,
            ),
            Image.asset(
              'assets/icons/person_icon.png',
              width: 30,
              height: 15,
              color: Colors.white,
            ),
          ],
          onTap: _onItemTapped,
          index: _currentIndex,
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
  ScrollController? _scrollController;
  final _userPost = UserPostClass.userPostList;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      drawer: const DrawerWidget(),

    /*appBar: _currentPageIndex ==4?appBarWidget(title: "Search Jobs",isJobTab: true,onTap: (){setState(() {
        _scaffoldState.currentState!.openDrawer();
      });}): appBarWidget(
          title: "Search",
          isJobTab: false,
          onTap: (){setState(() {
            _scaffoldState.currentState!.openDrawer();
          });}
      ),*/
      appBar: AppBar(
        backgroundColor: primaryBlueColor,
        toolbarHeight: 45,
        title: const Text(
          'HOME',
          style: TextStyle(color: Colors.white, fontFamily: 'Dubai', fontSize: 15,fontWeight: FontWeight.bold),
        ),
        leading: GestureDetector(
        onTap: (){setState(() {
          _scaffoldState.currentState!.openDrawer();
        });},
        child: const Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: CircleAvatar(backgroundImage: AssetImage("assets/profiles/profile2.jpg"),)
        ),
      ),
        actions: [
          IconButton(
            onPressed: () {
              // Handle notifications button tap
            },
            icon: const Icon(Icons.notifications,color:Colors.white,),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _userPost.length,
              itemBuilder: (context, index) {
                final userPostData = _userPost[index];
                return SinglePostCardWidget(userPostData: userPostData);
              },
            ),
          )
        ],
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
            Text(newsTitle1,style: const TextStyle(color: Colors.red),),
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
          MaterialPageRoute(builder: (context) =>  JobDetailsScreen()),
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
                  leading:  CircleAvatar(
                    backgroundColor: primaryBlueColor,
                    child:  const Icon(
                      Icons.work,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(jobTitle, style:  const TextStyle(color:Colors.black,fontSize: 20, fontWeight: FontWeight.bold),),
                  subtitle: Text(instituteName, style:  const TextStyle(color: Colors.grey,)),
                  trailing:  ico,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 8), // Adding space between badges
                          _buildBadge("Full-Time"),
                          SizedBox(width: 8), // Adding space between badges
                          _buildBadge("Remote"),
                          SizedBox(width: 8), // Adding space between badges
                          _buildBadge("Internship"),

                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                             children: [
                               const Icon(
                                Icons.location_on,
                                color: Colors.green,),
                               SizedBox(width: 8),
                               Text(location, style: TextStyle(color: primaryBlueColor), ),
                             ],
                           ),
                          const SizedBox(height: 8,),
                          Row(
                            children: [
                              Text('Rs $salary/hr', style: TextStyle(color: primaryBlueColor,fontWeight: FontWeight.bold,fontSize: 15), ),

                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8,),

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
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(0.1),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      text,
      style: TextStyle(
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
        backgroundColor: primaryBlueColor,
        toolbarHeight: 45,
        title: const Text(
        'Messages',
        style: TextStyle(color: Colors.white, fontFamily: 'Dubai', fontSize: 15,fontWeight: FontWeight.bold),),),
      body: const MessageCardList(),
    );
  }
}

class MessageCardList extends StatelessWidget {
  const MessageCardList({super.key});

  @override
  Widget build(BuildContext context) {
    // Example data
    List<Message> messages = [
      Message(sender: 'Alice', message: 'Hello!', timestamp: 'Yesterday'),
      Message(sender: 'Bob', message: 'Hi there!', timestamp: 'Jan 30'),
      Message(sender: 'Eve', message: 'Good morning!', timestamp: 'Feb 1'),
      Message(sender: 'Charlie', message: 'What\'s up?', timestamp: 'Feb 3'),
      Message(sender: 'David', message: 'Howdy!', timestamp: 'Feb 5'),
      Message(sender: 'Frank', message: 'Nice to meet you!', timestamp: 'Feb 7'),
      Message(sender: 'Grace', message: 'How are you doing?', timestamp: 'Feb 8'),
      Message(sender: 'Hannah', message: 'Hey!', timestamp: 'Feb 8'),
      Message(sender: 'Isabel', message: 'Hi, long time no see!', timestamp: 'Feb 8'),
      Message(sender: 'Jack', message: 'What\'s going on?', timestamp: 'Feb 8'),
      Message(sender: 'Kelly', message: 'Hey there!', timestamp: 'Feb 8'),
      Message(sender: 'Liam', message: 'Hello!', timestamp: 'Feb 8'),
      Message(sender: 'Mia', message: 'Hey!', timestamp: 'Feb 8'),
      Message(sender: 'Nathan', message: 'How\'s it going?', timestamp: 'Feb 8'),
      Message(sender: 'Olivia', message: 'Hi!', timestamp: 'Feb 8'),
      Message(sender: 'Peter', message: 'Hey, what\'s up?', timestamp: 'Feb 8'),
      Message(sender: 'Rachel', message: 'Hello!', timestamp: 'Feb 8'),
      Message(sender: 'Sam', message: 'Hi there!', timestamp: 'Feb 8'),
      Message(sender: 'Tom', message: 'Hey!', timestamp: 'Feb 8'),
      Message(sender: 'Ursula', message: 'Good evening!', timestamp: 'Feb 8'),
      Message(sender: 'Victor', message: 'Hey!', timestamp: 'Feb 8'),
      Message(sender: 'Wendy', message: 'Hello!', timestamp: 'Feb 8'),
      Message(sender: 'Xavier', message: 'Hi there!', timestamp: 'Feb 8'),
      Message(sender: 'Yvonne', message: 'Hey!', timestamp: 'Feb 8'),
      Message(sender: 'Zach', message: 'What\'s up?', timestamp: 'Feb 8')

      // Add more messages as needed
    ];

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return MessageCard(message: messages[index]);
      },
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
            MaterialPageRoute(builder: (context) => ChatScreen(message: message)),
          );
        },
        leading: CircleAvatar(
          child: Text(message.sender[0]), // Display first letter of sender's name
        ),
        title: Text(message.sender),
        subtitle: Text(message.message),
        trailing: Text(message.timestamp),
      ),
    );
  }
}

class Message {
  final String sender;
  final String message;
  final String timestamp;

  Message({
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
      appBar: AppBar(
        backgroundColor: primaryBlueColor,

        toolbarHeight: 45,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontFamily: 'Dubai', fontSize: 15,fontWeight: FontWeight.bold),),),
      body: const NotificationList(),
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
                '${index + 1}', // Display the index of the notification (starting from 1)
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
                  builder: (context) => NotificationDetails(notification: notification),
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
        title: const Text(
          'Notification Details',
          style: TextStyle(color: Colors.white, fontFamily: 'Dubai', fontSize: 15,fontWeight: FontWeight.bold),),),
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
        backgroundColor: primaryBlueColor, // You can customize the color as needed

        toolbarHeight: 45,
        title: const Text(
          'Bookmarks',
          style: TextStyle(color: Colors.white, fontFamily: 'Dubai', fontSize: 15,fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white), // Home Icon
          onPressed: () {
            // Implement action for home button
          },
        ),
      ),

      body:
      SizedBox(

        child: ListView(
          scrollDirection: Axis.vertical,
          children:  [
            JobCard(
              jobTitle: 'Software Engineer',
              instituteName: 'ABC Tech',
              location: 'New York',
              salary: 'Rs.5000-Rs.50000',
              description: 'a quick brown fox jumps over the lazy dog.',
              ico: Icon(Icons.bookmark,color: primaryBlueColor,),
            ),
            JobCard(
              jobTitle: 'Data Analyst',
              instituteName: 'XYZ Inc.',
              location: 'Dubai',
              salary: 'Rs.45000',
              description: 'a quick brown fox jumps over the lazy dog.',
              ico: Icon(Icons.bookmark,color: primaryBlueColor,),
            ), JobCard(
              jobTitle: 'Data Analyst',
              instituteName: 'XYZ Inc.',
              location: 'San Francisco',
              salary: 'Rs.45000',
              description: 'a quick brown fox jumps over the lazy dog.',
              ico: Icon(Icons.bookmark,color: primaryBlueColor,),
            ),JobCard(
              jobTitle: 'Security Analyst',
              instituteName: 'DBR Solutions.',
              location: 'Karachi',
              salary: 'Rs.45000',
              description: 'a quick brown fox jumps over the lazy dog.',
              ico: Icon(Icons.bookmark,color: primaryBlueColor,),
            ),
            // Add more JobCard widgets here
          ],
        ),
      ),
      );
  }
}

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlueColor, // You can customize the color as needed

        toolbarHeight: 45,
        title: const Text(
          'Profile Settings',
          style: TextStyle(color: Colors.white, fontFamily: 'Dubai', fontSize: 15,fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4, // Add elevation for a raised look
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    leading:  CircleAvatar(
                      backgroundColor: primaryBlueColor, // Customize the background color as needed
                      radius: 30,
                      child: const Icon(
                        Icons.person,
                        size: 40, // Adjust the size of the icon as needed
                        color: Colors.white, // Customize the color as needed
                      ), // Adjust the size of the avatar as needed
                    ),
                    title: const Text(
                      'John Doe', // Placeholder for user name
                      style: TextStyle(
                        fontSize: 18, // Adjust the font size of the name as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle:  Text(
                      'View Profile', // Add a subtitle for additional action or information
                      style: TextStyle(
                        color: primaryBlueColor, // Customize the color as needed
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      // Handle viewing the user profile
                    },
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Profile'),
                onTap: () {
                  // Handle Profile settings
                },
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                onTap: () {
                  // Handle Email settings
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Password'),
                onTap: () {
                  // Handle Password settings
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy'),
                onTap: () {
                  // Handle Privacy settings
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                onTap: () {
                  // Handle Notification settings
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_sharp),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                  );
                },
              ),
              // Add more ListTile widgets for other settings as needed
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Search results for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Type something to search'),
    );
  }
}
