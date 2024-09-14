import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false; // default theme
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ThemeProvider() {
    loadTheme();
  }

  // Load the theme from Firebase
  Future<void> loadTheme() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        isDarkMode = userDoc['isDarkMode'] ?? false;
        notifyListeners();
      }
    }
  }

  // Toggle the theme and save to Firebase
  void toggleTheme() async {
    isDarkMode = !isDarkMode;
    notifyListeners();
    saveThemeToFirebase();
  }

  // Save the theme to Firebase
  Future<void> saveThemeToFirebase() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'isDarkMode': isDarkMode,
      });
    }
  }
}
