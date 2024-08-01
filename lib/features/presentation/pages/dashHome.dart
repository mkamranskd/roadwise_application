import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import Font Awesome Icons
import '../../../global/Utils.dart';
import '../../../global/style.dart'; // Ensure this path is correct
import '../../../screens/businessinfopage.dart';

// Define the EducationPath class and sample data
class EducationPath {
  final String title;
  final IconData iconData; // Use IconData for icons instead of imageUrl
  final List<EducationPath> children;

  EducationPath({required this.title, required this.iconData, this.children = const []});
}

final List<EducationPath> educationPaths = [
  EducationPath(
    title: '10th Grade',
    iconData: FontAwesomeIcons.school,
    children: [
      EducationPath(
        title: '12th Grade',
        iconData: FontAwesomeIcons.graduationCap,
        children: [
          EducationPath(title: 'Science', iconData: FontAwesomeIcons.flask),
          EducationPath(title: 'Commerce', iconData: FontAwesomeIcons.chartLine),
          EducationPath(title: 'Arts', iconData: FontAwesomeIcons.paintBrush),
        ],
      ),
      EducationPath(
        title: 'Diploma',
        iconData: FontAwesomeIcons.certificate,
        children: [
          EducationPath(title: 'Engineering', iconData: FontAwesomeIcons.cogs),
          EducationPath(title: 'Pharmacy', iconData: FontAwesomeIcons.pills),
        ],
      ),
    ],
  ),
  EducationPath(
    title: 'Undergraduate',
    iconData: FontAwesomeIcons.university,
    children: [
      EducationPath(
        title: 'Engineering',
        iconData: FontAwesomeIcons.tools,
        children: [
          EducationPath(title: 'Computer Science', iconData: FontAwesomeIcons.laptopCode),
          EducationPath(title: 'Mechanical', iconData: FontAwesomeIcons.cog),
        ],
      ),
      EducationPath(title: 'Business Administration', iconData: FontAwesomeIcons.chartBar),
    ],
  ),
  EducationPath(
    title: 'Postgraduate',
    iconData: FontAwesomeIcons.graduationCap,
    children: [
      EducationPath(title: 'MBA', iconData: FontAwesomeIcons.chartLine),
      EducationPath(title: 'M.Tech', iconData: FontAwesomeIcons.microchip),
    ],
  ),
];

class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late List<DocumentSnapshot> usersList = [];
  late List<DocumentSnapshot> filteredUsersList = [];
  bool isLoading = true;
  bool showEducationPaths = true; // Set to true to show education paths by default
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    var snapshot = await FirebaseFirestore.instance.collection('Users').get();

    setState(() {
      usersList = snapshot.docs;
      filteredUsersList = []; // Start with an empty list
      isLoading = false;
    });
  }

  void filterUsers(String query) {
    if (query == '*') {
      setState(() {
        filteredUsersList = usersList; // Show all users
        searchQuery = query;
      });
      return;
    }

    if (query.isEmpty) {
      setState(() {
        filteredUsersList = [];
        searchQuery = query;
      });
      return;
    }

    List<DocumentSnapshot> filteredUsers = usersList.where((user) {
      String fullName = user['fullName'].toString().toLowerCase();
      return fullName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredUsersList = filteredUsers;
      searchQuery = query;
    });
  }

  Widget _buildExpansionTile(EducationPath path) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(15), // Increase padding inside the tile
        childrenPadding: const EdgeInsets.symmetric(horizontal: 15), // Increase padding for the children
        title: Text(
          path.title,
          style: const TextStyle(
            fontSize: 18, // Increase font size
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Icon(path.iconData, size: 30),
        children: path.children.map((child) => _buildExpansionTile(child)).toList(),
      ),
    );
  }

  Widget _buildUserCard(DocumentSnapshot user) {
    var userData = user.data() as Map<String, dynamic>? ?? {};
    String fullName = userData['fullName'] ?? 'Unknown';

    String city = userData['city'] ?? 'Unknown';
    String province = userData['province'] ?? 'Unknown';
    String profilePicture = userData['profilePicture'] ?? '';
    if (userData['fullName'] == "Neha Urooj") {
      fullName = "Unknown Unknown";

      profilePicture =
      "https://firebasestorage.googleapis.com/v0/b/roadwise-application-54684.appspot.com/o/profilePictures%2F8Qlio7yvEUhbdrwArb7mZxkOGXw1?alt=media&token=2495a17f-bb4c-41a9-a6e3-c802e2fa72dc";
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: ListTile(
        tileColor: Colors.white,
        leading: CircleAvatar(

          backgroundImage: NetworkImage(profilePicture),
        ),
        title: Text(
          '$fullName ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing:
          IconButton(onPressed: () {
            Utils.toastMessage(context, "Not Integrated Yet", Icons.warning);
          }, icon: Icon(FontAwesomeIcons.plus,size: 15,color: primaryBlueColor,))
        ,

        subtitle: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 8,
              child: Icon(
                userData['businessAccount'] == "true"
                    ? Icons.business
                    : Icons.person,
                size: 10,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Text('From $city, $province')
          ],
        ),
        onTap: () {
          debugPrint('Tapped on: $fullName');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BusinessPageScreen(
                businessData: user,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              child: H2(title: 'Users List', clr: primaryBlueColor),
            ),

          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: (value) {
                filterUsers(value);
              },
              decoration: const InputDecoration(
                labelText: 'Search users...',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                if (searchQuery.isNotEmpty)
                  ...filteredUsersList.map((user) => _buildUserCard(user)),

              ],
            ),
          ),
        ],
      ),
    );
  }
}