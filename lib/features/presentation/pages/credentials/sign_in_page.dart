import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/sign_up_page.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:roadwise_application/screens/dashboard_screen.dart';
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
              const CommonHeader(title: 'Road Wise'),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DashBoard()));
        setState(() {
          loading = false;
        });
      }).catchError((error) {
        // Handle login error
        setState(() {
          loading = false;
        });
      });
    }
  }
}
