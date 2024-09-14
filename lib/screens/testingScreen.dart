import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
final _auth = FirebaseAuth.instance;

class EducationQuestionScreen extends StatefulWidget {
  @override
  _EducationQuestionScreenState createState() => _EducationQuestionScreenState();
}

class _EducationQuestionScreenState extends State<EducationQuestionScreen> {
  String? educationLevel;
  int? graduationYear;

  final TextEditingController _graduationYearController = TextEditingController();

  // Function to store data in Firestore
  Future<void> _saveDataToFirestore() async {
    final userId = _auth.currentUser!.uid;
    await FirebaseFirestore.instance.collection('Users').doc(userId).set({
      'educationLevel': educationLevel,
      'graduationYear': int.tryParse(_graduationYearController.text),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Education Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: educationLevel,
              decoration: const InputDecoration(labelText: 'Select Education Level'),
              items: ['Matric', 'Intermediate', 'Bachelors']
                  .map((level) => DropdownMenuItem(
                value: level,
                child: Text(level),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  educationLevel = value;
                });
              },
            ),
            TextFormField(
              controller: _graduationYearController,
              decoration: const InputDecoration(labelText: 'Graduation Year'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveDataToFirestore();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
