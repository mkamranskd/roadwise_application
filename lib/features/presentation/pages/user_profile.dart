import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;

  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userData = snapshot.data!.data();
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Display profile picture
                  CircleAvatar(
                    backgroundImage: NetworkImage(userData!['profilePicture']),
                    radius: 50,
                  ),
                  SizedBox(height: 20),
                  // Display user's name
                  Text(
                    userData['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // Display user's bio
                  Text(
                    userData['bio'],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  // Display other profile information like work experience, education, skills, etc.
                  // Add more UI elements here based on your design
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
