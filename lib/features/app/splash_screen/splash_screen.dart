import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import '../../../screens/dashboard_screen.dart';
import '../../presentation/pages/credentials/sign_in_page.dart';

class SplashScreen extends StatefulWidget {
  //String message = "Loading";

  //SplashScreen({Key? key, required this.message}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingAndLogin();
  }

  Future<void> _checkOnboardingAndLogin() async {
    await Future.delayed(const Duration(seconds: 8));
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FirstPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    }

    // final prefs = await SharedPreferences.getInstance();
    // final bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;
    //
    // if (!onboardingCompleted) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
    //   );
    // } else {
    //
    //
    // }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GifView.asset(
            'assets/logo.gif',
            width: screenWidth,
            frameRate: 20,
            repeat: ImageRepeat.noRepeat,
          ),
          const SizedBox(
            height: 50,
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 1000),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GifView.asset(
                  'assets/loading.gif',
                  width: 50,
                  height: 50,
                  frameRate: 30,
                  repeat: ImageRepeat.noRepeat,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 120,
          ),
        ],
      ),
    );
  }
}
