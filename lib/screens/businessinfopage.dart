import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../global/style.dart';

class BusinessPageScreen extends StatelessWidget {
  final DocumentSnapshot businessData;

  BusinessPageScreen({required this.businessData});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = businessData.data() as Map<String, dynamic>;
    String businessName = data['firstName'] ?? 'Unknown';
    String ownerName = data['firstName'] ?? 'Unknown';
    String city = data['city'] ?? 'Unknown';
    String province = data['province'] ?? 'Unknown';
    String description = data['description'] ?? 'No description available';
    String profilePicture = data['profilePicture'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(businessName),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new, color: primaryBlueColor,size: 15,)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(profilePicture),
                radius: 50,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Owner: $ownerName',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Location: $city, $province',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
