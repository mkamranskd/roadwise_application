import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'chat_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
void main() {
  runApp(const DashBoard());
}
Color primary = const Color(0xff13265C);

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
          Screen4(),
          const AccountSettingsScreen(),
        ],
      ),
      bottomNavigationBar: FadeInUp(
        duration: const Duration(milliseconds: 1000),
        child: CurvedNavigationBar(
          color: Colors.blue,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Colors.blue,
          height: 50,
          items: <Widget>[
            Image.asset(
              'lib/assets/icons/home_icon.png', // Replace 'home_icon.png' with your actual asset path
              width: 20,
              height: 20,
              color: Colors.white,

            ),
            Image.asset(
              'lib/assets/icons/mail_icon.png', // Replace 'mail_icon.png' with your actual asset path
              width: 20,
              height: 20,
              color: Colors.white,
            ),
            Image.asset(
              'lib/assets/icons/notifications_icon.png', // Replace 'notifications_icon.png' with your actual asset path
              width: 20,
              height: 20,
              color: Colors.white,
            ),
            Image.asset(
              'lib/assets/icons/roadmap-planning.png', // Replace 'person1_icon.png' with your actual asset path
              width: 20,
              height: 20,
              color: Colors.white,
            ),
            Image.asset(
              'lib/assets/icons/person_icon.png', // Replace 'person2_icon.png' with your actual asset path
              width: 20,
              height: 20,
              color: Colors.white,
            ),
          ],
          onTap: _onItemTapped,
          index: _currentIndex, // Set the index of the selected item
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
  final List<String> cardData = List.generate(100, (index) => 'Card ${index + 1}');
  bool showAllCards = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Road Wise',
          style: TextStyle(color: Colors.white, fontFamily: 'bifur', fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Vertical list of circular icon buttons
            SizedBox(
              width: 50, // Adjust width as needed
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyApp()),
                        );
                      },
                      icon: const Icon(Icons.add_circle),
                    ),

                    const SizedBox(height: 20), // Add spacing between buttons
                    IconButton(
                      onPressed: () {
                        // Handle button tap
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    const SizedBox(height: 20), // Add spacing between buttons
                    IconButton(
                      onPressed: () {
                        // Handle button tap
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            ),
            // Vertical separator
            const VerticalDivider(thickness: 1, width: 1),
            // Centered sidebar
            const Expanded(
              child: Center(
                child: Text(
                  'Centered Sidebar',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Messages', style: TextStyle(color: Colors.white)),
      ),
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
        backgroundColor: Colors.blue,
        title: const Text('Notifications',style: TextStyle(color: Colors.white),),
      ),
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
              backgroundColor: Colors.blue,
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
        title: const Text('Notification Details'),
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


class Folder {
  final String name;
  final List<Folder> subFolders;

  Folder(this.name, this.subFolders);
}

class Screen4 extends StatelessWidget {
  final List<Folder> folders = [
    Folder('Folder 1', [
      Folder('Subfolder 1.1', []),
      Folder('Subfolder 1.2', [
        Folder('Sub-subfolder 1.2.1', []),
        Folder('Sub-subfolder 1.2.2', []),
      ]),
    ]),
    Folder('Folder 1', [
      Folder('Subfolder 1.1', []),
      Folder('Subfolder 1.2', [
        Folder('Sub-subfolder 1.2.1', []),
        Folder('Sub-subfolder 1.2.2', []),
      ]),
    ]),
    Folder('Folder 1', [
      Folder('Subfolder 1.1', []),
      Folder('Subfolder 1.2', [
        Folder('Sub-subfolder 1.2.1', []),
        Folder('Sub-subfolder 1.2.2', []),
      ]),
    ]),
    Folder('Folder 1', [
      Folder('Subfolder 1.1', []),
      Folder('Subfolder 1.2', [
        Folder('Sub-subfolder 1.2.1', []),
        Folder('Sub-subfolder 1.2.2', []),
      ]),
    ]),
    Folder('Folder 1', [
      Folder('Subfolder 1.1', []),
      Folder('Subfolder 1.2', [
        Folder('Sub-subfolder 1.2.1', []),
        Folder('Sub-subfolder 1.2.2', []),
      ]),
    ]),
    Folder('Folder 2', []),
    Folder('Folder 3', [
      Folder('Subfolder 3.1', []),
    ]),
  ];

  Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Folder Tree', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          return FolderItem(folders[index]);
        },
      ),
    );
  }
}

class FolderItem extends StatelessWidget {
  final Folder folder;

  const FolderItem(this.folder, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(folder.name),
      leading: const Icon(Icons.folder),
      onTap: () {
        // Handle tapping on folder item if needed
      },
      subtitle: folder.subFolders.isEmpty
          ? null
          : Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var subFolder in folder.subFolders)
              FolderItem(subFolder),
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
        backgroundColor: Colors.blue, // You can customize the color as needed
        title: const Text(
          'Account Settings',
          style: TextStyle(color: Colors.white),
        ),
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
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue, // Customize the background color as needed
                      radius: 30,
                      child: Icon(
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
                    subtitle: const Text(
                      'View Profile', // Add a subtitle for additional action or information
                      style: TextStyle(
                        color: Colors.blue, // Customize the color as needed
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
                    MaterialPageRoute(builder: (context) => const MyApp()),
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
