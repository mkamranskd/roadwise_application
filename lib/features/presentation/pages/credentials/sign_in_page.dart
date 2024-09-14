import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/sign_up_page.dart';
import 'package:roadwise_application/features/presentation/pages/user/user_complete_profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:roadwise_application/global/svg_illustrations.dart';
import 'package:roadwise_application/main.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/forgot_password_page.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isObscure = true;
  bool _isButtonEnabled = false;

  void _validateForm() {
    setState(() {
      // Check if the email is valid and password is at least 6 characters long
      if (emailController.text.contains('@') &&
          emailController.text.contains('.') &&
          passwordController.text.length >= 6) {
        _isButtonEnabled = true;
      } else {
        _isButtonEnabled = false;
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //SizedBox(height: 100,),
            const CommonHeader(title: "title"),
            H1(title: "Login First", clr: primaryBlueColor),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          onChanged: (email) => _validateForm(),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "Enter your email",
                            labelText: "Email",
                            suffixIcon: Icon(
                              Clarity.email_line,
                              color: primaryBlueColor,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          obscureText: _isObscure,
                          onChanged: (password) => _validateForm(),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            labelText: "Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Clarity.eye_show_line
                                    : Clarity.eye_hide_line,
                                color: primaryBlueColor,
                                size: 20, // You can adjust the size here
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure =
                                      !_isObscure; // Toggle password visibility
                                });
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PasswordResetPage()));
                              },
                              child: const Text(
                                "Forget Password?",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ZoomTapAnimation(
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                login();
                              }
                            }
                          : null, // Disable button if not valid
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFFFF7643),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                      child: Center(
                        child: loading
                            ? LoadingAnimationWidget.inkDrop(
                                color: Colors.white,
                                size: 25,
                              )
                            : const Text(
                                "Continue",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Dubai',
                                    fontWeight: FontWeight.w500),
                              ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't Have an Account?"),
                      ZoomTapAnimation(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpPage()));
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialCard(
                        icon: SvgPicture.string(googleIcon),
                        press: () async {
                          setState(() {
                            loading = true;
                          });
                          final userCredential = await _signInWithGoogle();

                          if (userCredential != null) {
                            final user = userCredential.user;
                            if (user != null) {
                              final userDoc = await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(user.uid)
                                  .get();

                              if (userDoc.exists) {
                                final userData = userDoc.data();
                                final fullName = userData?['fullName'];

                                if (fullName != null && fullName.isNotEmpty) {
                                  // Navigate to main app
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MyApp()),
                                  );
                                } else {
                                  // Navigate to complete profile screen
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UserCompleteProfile()),
                                  );
                                }
                              } else {
                                // Navigate to complete profile screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UserCompleteProfile()),
                                );
                              }
                            }
                          }

                          setState(() {
                            loading = false;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SocialCard(
                          icon: SvgPicture.string(facebookIcon),
                          press: () {},
                        ),
                      ),
                      SocialCard(
                        icon: SvgPicture.string(twitterIcon),
                        press: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "By continuing your confirm that you agree \nwith our Term and Condition",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Dubai',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() async {

    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        loading = true;
      });
      _auth
          .signInWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      )
          .then((value) async {
        // Check if the user is a business account
        final user = _auth.currentUser;
        if (user != null) {
          final userDoc = await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            // Check if the fullName field exists and has data
            final userData = userDoc.data(); // Get the data from the document
            final fullName = userData?['fullName']; // Access the fullName field

            if (fullName != null && fullName.isNotEmpty) {
              // fullName exists and is not empty, navigate to profile screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyApp()),
              );
            } else {
              // fullName is missing or empty, navigate to complete profile screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserCompleteProfile()),
              );
            }
          } else {
            // Document does not exist, navigate to complete profile screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserCompleteProfile()),
            );
          }

          /*if (userDoc.exists && userDoc.data()?['businessAccount'] == "true") {
            // Navigate to a blank screen if the user is a business account
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const RestartWidget(child: MyApp())));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const RestartWidget(child: MyApp())));
          }*/
        }
        setState(() {
          loading = false;
        });
      }).catchError((error) {
        // Check the type of error to provide specific feedback
        IconData icon = Icons.warning;
        String errorMessage =
            "An error occurred while logging in. Please try again later.";
        if (error is FirebaseAuthException) {
          switch (error.code) {
            case 'invalid-email':
              errorMessage = "Invalid email address.";
              break;
            case 'user-not-found':
              errorMessage =
                  "User not found. Please check your credentials and try again.";
              break;
            case 'wrong-password':
              errorMessage = "Wrong password. Please try again.";
              break;
            case 'user-disabled':
              errorMessage =
                  "Your account has been disabled. Please contact support.";
              break;
            case 'too-many-requests':
              errorMessage = "Too many login attempts. Please try again later.";
              break;
            case 'operation-not-allowed':
              errorMessage =
                  "Email/password sign-in is not enabled. Please contact support.";
              break;
            case 'email-already-in-use':
              errorMessage =
                  "The email address is already in use by another account.";
              break;
            case 'weak-password':
              errorMessage =
                  "The password is too weak. Please choose a stronger password.";
              break;
            case 'network-request-failed':
              errorMessage =
                  "Network error occurred. Please check your internet connection.";
              break;
            case 'invalid-verification-code':
              errorMessage = "Invalid verification code.";
              break;
            case 'invalid-verification-id':
              errorMessage = "Invalid verification ID.";
              break;
            case 'session-expired':
              errorMessage = "Verification session expired. Please try again.";
              break;
            case 'invalid-credential':
              errorMessage = "Invalid Email or Password.";
              break;
            case 'credential-already-in-use':
              errorMessage =
                  "The credential is already in use by another account.";
              break;
            case 'user-mismatch':
              errorMessage = "User mismatch error.";
              break;
            case 'expired-action-code':
              errorMessage =
                  "The action code has expired. Please request a new one.";
              break;
            case 'invalid-action-code':
              errorMessage = "Invalid action code. Please check and try again.";
              break;
            case 'missing-verification-code':
              errorMessage = "Missing verification code.";
              break;
            case 'missing-verification-id':
              errorMessage = "Missing verification ID.";
              break;
            default:
              errorMessage = "Authentication failed: ${error.message}";
              break;
          }
        }
        // Display error message to the user
        Utils.toastMessage(context, errorMessage, icon);
        // Handle login error
        setState(() {
          loading = false;
        });
      });
    }
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      // Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential;
    } catch (error) {
      Utils.toastMessage(context, "Google Sign-In failed: $error", Icons.error);
      print("Google Sign-In failed: $error");
      return null;
    }
  }
}
