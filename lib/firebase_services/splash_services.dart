/* splash_services.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/sign_in_page.dart';
import 'package:roadwise_application/screens/dashboard_screen.dart';
import '../features/app/splash_screen/on_board_screen.dart';

class SplashServices {
  Future<void> _checkOnboardingAndLogin() async {
    await Future.delayed(const Duration(seconds: 2)); // Adjust duration as needed

    final prefs = await SharedPreferences.getInstance();
    final bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

    if (!onboardingCompleted) {
      // Navigate to OnboardingScreen if onboarding is not completed
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
      );
    } else {
      // Proceed with checking user authentication status
      final auth = FirebaseAuth.instance;
      final user = auth.currentUser;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashBoard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }
    }
  }


}

 */
