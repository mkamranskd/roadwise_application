import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/sign_up_page.dart';
import 'package:roadwise_application/features/presentation/pages/quiz/starting_page.dart';
import 'package:roadwise_application/global/Utils.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:roadwise_application/screens/password_reset_screen.dart';
import '../../../../screens/common_header.dart';

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
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press here
        return true; // Return true to allow back button press to exit
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              H1(title: "Login First", clr: primaryBlueColor),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color.fromRGBO(143, 148, 251, 1)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1))),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  prefixIcon: Icon(Icons.alternate_email_rounded, size: 20, color: primaryBlueColor),
                                  hintStyle: TextStyle(color: Colors.grey[700], fontFamily: 'Dubai'),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  prefixIcon: Icon(Icons.lock_open_outlined, size: 20, color: primaryBlueColor),
                                  hintStyle: TextStyle(color: Colors.grey[700], fontFamily: 'Dubai'),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      loading: loading,
                      title: "Login ",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      clr1: primaryBlueColor,
                      clr2: primaryBlueColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't Have an Account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                          },
                          child: const Text("Sign Up"),
                        ),
                      ],
                    ),
                    CustomButton(
                      title: "Forgot Password?",
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordResetPage()));
                      },
                      clr1: const Color.fromRGBO(255, 0, 0, 1),
                      clr2: const Color.fromRGBO(255, 0, 0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        loading = true;
      });
      _auth.signInWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      ).then((value) {
        //Utils.toastMessage(context, value.user!.email.toString(), Icons.check_circle_outline);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CompleteProfile()));

        setState(() {
          loading = false;
        });
      }).catchError((error) {
        // Check the type of error to provide specific feedback
        IconData icon = Icons.warning;
        String errorMessage = "An error occurred while logging in. Please try again later.";
        if (error is FirebaseAuthException) {
          setState(() {
            loading = false;
          });
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
}
