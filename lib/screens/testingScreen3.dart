import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EducationDetailsScreen extends StatefulWidget {
  const EducationDetailsScreen({Key? key}) : super(key: key);

  @override
  State<EducationDetailsScreen> createState() => _EducationDetailsScreenState();
}

class _EducationDetailsScreenState extends State<EducationDetailsScreen> {
  String? selectedEducationLevel;
  final TextEditingController _instituteController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  final List<String> educationLevels = [
    'Matric',
    'Intermediate',
    'Bachelors',
    'Masters',
    'PhD'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Education Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for education level
            DropdownButtonFormField<String>(
              value: selectedEducationLevel,
              hint: const Text("Select Passed Education Level"),
              items: educationLevels.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedEducationLevel = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Education Level',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Institute name input
            TextFormField(
              controller: _instituteController,
              decoration: const InputDecoration(
                labelText: 'Institute Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Year input
            TextFormField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Year of Completion',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),

            // Save button
            ElevatedButton(
              onPressed: () async {
                if (selectedEducationLevel != null &&
                    _instituteController.text.isNotEmpty &&
                    _yearController.text.isNotEmpty) {
                  await _saveEducationDetails();
                  // Navigate to the next suggestion screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NextSuggestionScreen()),
                  );
                } else {
                  // Show an error message if fields are not filled
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields'),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _saveEducationDetails() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Educations')
        .doc(); // Creating a new document for each education

    await userDocRef.set({
      'educationLevel': selectedEducationLevel,
      'institute': _instituteController.text,
      'year': _yearController.text,
      'createdAt': Timestamp.now(),
    });

    // Save to preferences that the education details were entered
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('educationDetailsEntered', true);
  }
}

class NextSuggestionScreen extends StatelessWidget {
  const NextSuggestionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Next Move'),
      ),
      body: const Center(
        child: Text(
          'Based on your details, here are some suggestions...',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}














