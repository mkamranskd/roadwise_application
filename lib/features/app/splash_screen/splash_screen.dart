import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/sign_in_page.dart';
import 'package:roadwise_application/global/style.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo widget
            Image.asset(

              'assets/roadwiselogo.PNG',
              width: 350,
              height: 350,
            ),
            const SizedBox(height: 20),
            // Your indicator bar
            LoadingAnimationWidget.staggeredDotsWave(
              color: primaryBlueColor,
              size: 50,
            )
          ],
        ),
      ),
    );
  }
}

