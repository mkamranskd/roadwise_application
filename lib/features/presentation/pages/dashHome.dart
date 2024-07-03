import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../global/style.dart';
import '../../../screens/businessinfopage.dart';

class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late List<DocumentSnapshot> usersList = [];
  late List<DocumentSnapshot> filteredUsersList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .get();

    setState(() {
      usersList = snapshot.docs;
//      filteredUsersList = usersList;
      isLoading = false;
    });
  }

  void filterUsers(String query) {
    List<DocumentSnapshot> filteredUsers = usersList.where((user) {
      String firstName = user['firstName'].toString().toLowerCase();
      String lastName = user['lastName'].toString().toLowerCase();
      String fullName = '$firstName $lastName';
      return fullName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredUsersList = filteredUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: H2(title: 'Users List', clr: primaryBlueColor),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: (value) {
                filterUsers(value);
              },
              decoration: InputDecoration(
                labelText: 'Search users...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsersList.length,
              itemBuilder: (context, index) {
                var userData = filteredUsersList[index].data() as Map<String, dynamic>;
                String firstName = userData['firstName'] ?? 'Unknown';
                String lastName = userData['lastName'] ?? 'Unknown';
                String city = userData['city'] ?? 'Unknown';
                String province = userData['province'] ?? 'Unknown';
                String profilePicture = userData['profilePicture'] ?? '';
                if (userData['firstName'] == "Neha") {
                  firstName = "Unknown";
                  lastName = "Unknown";
                  profilePicture = "https://firebasestorage.googleapis.com/v0/b/roadwise-application-54684.appspot.com/o/profilePictures%2F8Qlio7yvEUhbdrwArb7mZxkOGXw1?alt=media&token=2495a17f-bb4c-41a9-a6e3-c802e2fa72dc";
                }
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(profilePicture),
                  ),
                  title: Text('$firstName $lastName'),
                  subtitle: Row(
                    children: [
                      CircleAvatar(child: Icon(userData['businessAccount']=="true"? Icons.business:Icons.person,size: 10,color: Colors.white,),backgroundColor: Colors.blue,radius: 8,),
                      SizedBox(width: 20),
                      Text('From $city, $province')

                    ],
                  ),
                  onTap: () {
                    debugPrint('Tapped on: $firstName $lastName');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusinessPageScreen(
                          businessData: filteredUsersList[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
