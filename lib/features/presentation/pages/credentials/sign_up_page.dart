import 'dart:async';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/sign_in_page.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roadwise_application/global/svg_illustrations.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  bool isBusinessAccount = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final businessNameController = TextEditingController();
  final businessAddressController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  bool showPasswordGuidelines = false;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();

    // Add focus listeners to track focus changes
    passwordFocusNode.addListener(() {
      setState(() {
        showPasswordGuidelines =
            passwordFocusNode.hasFocus || confirmPasswordFocusNode.hasFocus;
      });
    });

    confirmPasswordFocusNode.addListener(() {
      setState(() {
        showPasswordGuidelines =
            passwordFocusNode.hasFocus || confirmPasswordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    businessNameController.dispose();
    businessAddressController.dispose();
    super.dispose();
  }

  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumbers = false;
  bool hasSymbols = false;
  bool passwordsMatch = false;
  bool meetsAllConditions = false;

  void validatePassword(String password) {
    setState(() {
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      hasLowercase = password.contains(RegExp(r'[a-z]'));
      hasNumbers = password.contains(RegExp(r'[0-9]'));
      hasSymbols = password.contains(RegExp(r'[!@#\$.,&*~]'));
      meetsAllConditions =
          hasUppercase && hasLowercase && hasNumbers && hasSymbols;
    });
  }

  void checkPasswordsMatch(String confirmPassword) {
    setState(() {
      passwordsMatch = passwordController.text == confirmPassword;
    });
  }

  bool positive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new,),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            H1(title: "Sign Up", clr: primaryBlueColor),
            const Text(
              "Complete your details or continue \nwith social media",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF757575)),
            ),
            // const SizedBox(height: 16),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ZoomTapAnimation(
              child: AnimatedToggleSwitch<bool>.dual(
                current: positive,
                first: false,
                second: true,
                spacing: 200.0,
                animationDuration: const Duration(milliseconds: 1000),
                style: const ToggleStyle(
                  borderColor: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 2,
                      blurRadius: 1,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                borderWidth: 5.0,
                height: textBoxHeight,
                onChanged: (bool value) {
                  setState(() {
                    positive = value;
                    isBusinessAccount = value;
                  });
                },
                styleBuilder: (b) => ToggleStyle(
                    indicatorColor: b ? Colors.green : primaryBlueColor),
                iconBuilder: (value) => value
                    ? const Icon(
                        Icons.business_outlined,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                textBuilder: (value) => value
                    ? const Center(child: Text('Business Account'))
                    : const Center(child: Text('Student Account')),
              ),
            ),
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          style: const TextStyle(
                            fontFamily: 'Dubai',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          onSaved: (email) {},
                          onChanged: (email) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              hintText: "Enter your email",
                              labelText: "Email",
                              labelStyle: TextStyle(
                                fontFamily: 'Dubai',
                                fontWeight: FontWeight.w500,
                                color: primaryBlueColor,
                                // Replace with your primaryBlueColor
                                fontSize: 13,
                              ),
                              hintStyle: TextStyle(
                                fontFamily: 'Dubai',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500,
                                // Replace with your primaryBlueColor
                                fontSize: 13,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              suffixIcon: Icon(
                                Clarity.email_line,
                                color: primaryBlueColor,
                                size: 20,
                              ),
                              border: boxOutlineBorder,
                              enabledBorder: boxOutlineBorder,
                              focusedBorder: boxOutlineBorder),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          style: const TextStyle(
                            fontFamily: 'Dubai',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          focusNode: passwordFocusNode,
                          // Add this line
                          controller: passwordController,
                          onChanged: (password) {
                            validatePassword(password);
                          },
                          keyboardType: TextInputType.text,
                          obscureText: _isObscure,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              hintText: "Enter your password",
                              labelText: "Password",
                              labelStyle: TextStyle(
                                fontFamily: 'Dubai',
                                fontWeight: FontWeight.w500,
                                color: primaryBlueColor,
                                // Replace with your primaryBlueColor
                                fontSize: 13,
                              ),
                              hintStyle: TextStyle(
                                fontFamily: 'Dubai',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500,
                                // Replace with your primaryBlueColor
                                fontSize: 13,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
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
                              border: boxOutlineBorder,
                              enabledBorder: boxOutlineBorder,
                              focusedBorder: boxOutlineBorder),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          style: const TextStyle(
                            fontFamily: 'Dubai',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          focusNode: confirmPasswordFocusNode,
                          // Add this line
                          controller: confirmPasswordController,
                          onChanged: (confirmPassword) {
                            checkPasswordsMatch(confirmPassword);
                            if (meetsAllConditions) {
                              setState(() {
                                showPasswordGuidelines = false;
                              });
                            }
                          },
                          obscureText: _isObscure,

                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            labelText: "Re-enter your password",
                            labelStyle: TextStyle(
                              fontFamily: 'Dubai',
                              fontWeight: FontWeight.w500,
                              color: primaryBlueColor,
                              // Replace with your primaryBlueColor
                              fontSize: 13,
                            ),
                            hintStyle: TextStyle(
                              fontFamily: 'Dubai',
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500,
                              // Replace with your primaryBlueColor
                              fontSize: 13,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
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
                            border: boxOutlineBorder,
                            enabledBorder: boxOutlineBorder,
                            focusedBorder: boxOutlineBorder,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (showPasswordGuidelines) ...[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("PASSWORD GUIDELINES:"),
                                const SizedBox(
                                  height: 10,
                                ),
                                _buildPasswordRule(
                                    "Must contain at least one uppercase letter",
                                    hasUppercase),
                                _buildPasswordRule(
                                    "Must contain at least one number",
                                    hasNumbers),
                                _buildPasswordRule(
                                    "Must contain at least one symbol",
                                    hasSymbols),
                                _buildPasswordRule(
                                    "Passwords must match", passwordsMatch),
                              ],
                            ),
                          ),
                        ],
                        /*if (isBusinessAccount) ...[
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: Color.fromRGBO(143, 148, 251, 1))),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: businessNameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Business Name",
                                hintStyle: TextStyle(color: Colors.grey[700], fontFamily: 'Dubai'),
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: Color.fromRGBO(143, 148, 251, 1))),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: businessAddressController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Business Address",
                                hintStyle: TextStyle(color: Colors.grey[700], fontFamily: 'Dubai'),
                              ),
                            ),
                          ),
                        ],*/
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ZoomTapAnimation(
                    child: ElevatedButton(
                      onPressed: meetsAllConditions && passwordsMatch
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                signUp();
                              }
                            }
                          : null,
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialCard(
                        icon: SvgPicture.string(googleIcon),
                        press: () {},
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
                  const SizedBox(height: 16),
                  const Text(
                    "By continuing your confirm that you agree \nwith our Term and Condition",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF757575),
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

  void signUp() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
      email: emailController.text.toString(),
      password: passwordController.text.toString(),
    )
        .then((value) {
      if (isBusinessAccount) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(_auth.currentUser?.uid)
            .set({
          "businessAccount": 'true',
          "isThemeMode": false,
          /*'fullName': businessNameController.text,
          'Address': businessAddressController.text,*/
        }, SetOptions(merge: true));
      } if (!isBusinessAccount) {
        FirebaseFirestore.instance
            .collection('businessAccounts')
            .doc(_auth.currentUser!.uid)
            .set({
          "businessAccount": 'false',
          "isThemeMode": false,
        });
      }
      FirebaseFirestore.instance
          .collection('businessAccounts')
          .doc(_auth.currentUser!.uid)
          .set({
        "isThemeMode": false,
      });
      Utils.toastMessage(
          context,
          "Account Created Successfully\nRedirecting to the Login Screen",
          Icons.check_circle_outline);
      Timer(
        const Duration(seconds: 1),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        ),
      );
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils.toastMessage(context, error.toString(), Icons.warning);
    });
  }
}

Widget _buildPasswordRule(String text, bool conditionMet) {
  return Row(
    children: [
      Icon(
        conditionMet ? Clarity.check_circle_solid : Clarity.error_line,
        color: conditionMet ? primaryBlueColor : Colors.red,
      ),
      const SizedBox(width: 8),
      Text(text),
    ],
  );
}
