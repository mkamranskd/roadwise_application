import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/app/splash_screen/on_board_screen.dart';
import 'firebase_options.dart';
import 'features/app/splash_screen/splash_screen.dart';
import 'global/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RestartWidget(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isOnboardingCompleted = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    _checkOnboardingStatus();
  }

  Future<void> _loadThemeMode() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          isDarkMode = userDoc['isThemeMode'] ?? false;
        });
      }
    }
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isOnboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Right Way',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        // Light mode
        primaryColor: Colors.blue,
        // Primary blue color
        scaffoldBackgroundColor: Colors.white,
        // Light background
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          toolbarHeight: 45,
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontFamily: 'Dubai',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: IconThemeData(
            color: Colors.blue,
            size: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.blue, // Default icon color
          size: 20.0, // Default icon size
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue, // Button color
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Dubai',
            color: Colors.black,
            fontSize: 13,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Dubai',
            color: Colors.black45, // Slightly lighter text
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          iconColor: Colors.blue,
          filled: false,
          fillColor: Colors.blueGrey[800],
          hintStyle: const TextStyle(
            fontFamily: 'Dubai',
            fontWeight: FontWeight.w500,
            color: Colors.blue,
            fontSize: 13,
          ),
          labelStyle: const TextStyle(
            fontFamily: 'Dubai',
            fontWeight: FontWeight.w500,
            color: Colors.blue,
            fontSize: 13,
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: Colors.grey.shade100,
          // Background color
          selectedTileColor: Colors.blue[100],
          // Selected color
          textColor: const Color(0xFF757575),
          // Text color
          iconColor: Colors.blue,
          // Icon color
          selectedColor: Colors.blue,
          // Color when selected
          titleTextStyle: const TextStyle(
            color: Colors.blue,
            fontFamily: 'Dubai',
            fontSize: 16,
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.blueGrey[900], // Dark background with blue tint
          shadowColor: Colors.transparent, // No shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            // Text color
            elevation: 5,
            // Elevation of the button
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 24.0,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        // Dark mode
        primaryColor: Colors.blue,
        // Primary blue color
        scaffoldBackgroundColor: Colors.blueGrey[900],
        // Dark background
        appBarTheme: AppBarTheme(
          toolbarHeight: 45,
          backgroundColor: Colors.blueGrey[900], // Dark AppBar
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Dubai',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Default icon color
          size: 20.0, // Default icon size
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue, // Button color
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Dubai',
            color: Colors.white,
            fontSize: 13,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Dubai',
            color: Colors.white70, // Slightly lighter text
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.blueGrey[800],
          // Dark input fields
          hintStyle: TextStyle(
            fontFamily: 'Dubai',
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
            fontSize: 13,
          ),
          labelStyle: const TextStyle(
            fontFamily: 'Dubai',
            fontWeight: FontWeight.w500,
            color: Colors.blue,
            fontSize: 13,
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: Colors.blueGrey[800],
          // Dark tile color
          selectedTileColor: Colors.blue[900],
          // Selected color
          textColor: Colors.white,
          // Text color
          iconColor: Colors.white,
          // Icon color
          selectedColor: Colors.blue,
          // Color when selected
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Dubai',
            fontSize: 16,
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.blueGrey[900], // Dark background with blue tint
          shadowColor: Colors.transparent, // No shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            // Text color
            elevation: 5,
            // Elevation of the button
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 24.0,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      home: _isOnboardingCompleted ? SplashScreen() : const OnBoardingScreen(),
    );
  }
}
