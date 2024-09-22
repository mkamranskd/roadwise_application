import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gif_view/gif_view.dart';
import 'package:roadwise_application/global/svg_illustrations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../../screens/dashboard_screen.dart';
import '../../presentation/pages/credentials/sign_in_page.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(
        pages: [
          OnboardingPageModel(
            title: 'Find Your Perfect Path',
            description:
                'Find the best path after high school with RightWay\'s help.',
            svgString: adventure_map,
            bgColor: Colors.white,
          ),
          OnboardingPageModel(
            title: 'Personalized Guidance',
            description:
                'Get custom advice on courses and steps to reach your goals.',
            svgString: travelers,
            bgColor: Colors.white,
          ),
          OnboardingPageModel(
            title: 'Connect with the Right Fit',
            description:
                'Connect with colleges and jobs that match your career goals.',
            svgString: house_searching,
            bgColor: Colors.white,
          ),
        ],
        onSkip: () async {
          _setOnboardingCompleted();
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
        },
        onFinish: () async {
          _setOnboardingCompleted();
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
        },
      ),
    );
  }

  Future<void> _setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter(
      {Key? key, required this.pages, this.onSkip, this.onFinish})
      : super(key: key);

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  // Store the currently visible page
  int _currentPage = 0;

  // Define a controller for the pageview
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return FadeIn(
      duration: const Duration(milliseconds: 2000),
      child: Scaffold(
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          color: _currentPage == 0
              ? Colors.white
              : widget.pages[_currentPage - 1].bgColor, // Adjust for index shift
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  // Page view to render each page
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.pages.length + 1, // Add +1 for the extra screen
                    onPageChanged: (idx) {
                      setState(() {
                        _currentPage = idx;
                      });
                    },
                    itemBuilder: (context, idx) {
                      if (idx == 0) {
                        // First custom screen with only Text("data")
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 60,),
                            GifView.asset(
                              'assets/logo.gif',
                              width: screenWidth,
                              frameRate: 30,
                              repeat: ImageRepeat.noRepeat,
                            ),
                          ],
                        );
                      } else {
                        // Shift pages by -1 to show the rest of the onboarding screens
                        final item = widget.pages[idx - 1];
                        return Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(50, 80, 50, 0),
                                child: item.svgString.isNotEmpty
                                    ? SvgPicture.string(
                                  item.svgString,
                                  width: screenWidth,
                                )
                                    : Container(), // Default fallback if no SVG string
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Text(
                                        item.title,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontFamily: 'Dubai',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 28,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: screenWidth,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0, vertical: 8.0),
                                      child: Text(
                                        item.description,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),

                // Current page indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.pages.length + 1, // +1 for extra screen
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: _currentPage == index ? 30 : 8,
                      height: 8,
                      margin: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),

                // Bottom buttons
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.comfortable,
                          foregroundColor: Colors.blue,
                          backgroundColor: Colors.grey.shade100,
                        ),
                        onPressed: () {
                          if (_currentPage == widget.pages.length) {
                            widget.onFinish?.call();
                          } else {
                            _pageController.animateToPage(
                              _currentPage + 1,
                              curve: Curves.easeInOutCubic,
                              duration: const Duration(milliseconds: 500),
                            );
                          }
                        },
                        child: ZoomTapAnimation(
                          child: Row(
                            children: [
                              Text(
                                _currentPage == widget.pages.length
                                    ? "Go to Sign In Page"
                                    : "Next",
                              ),
                              const SizedBox(width: 8),
                              Icon(_currentPage == widget.pages.length
                                  ? Icons.done
                                  : Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class OnboardingPageModel {
  final String title;
  final String description;
  final String svgString; // Use SVG strings
  final Color bgColor;
  final Color textColor;

  OnboardingPageModel({
    required this.title,
    required this.description,
    this.svgString = '', // Default to empty if not used
    this.bgColor = Colors.blue,
    this.textColor = Colors.white,
  });
}
