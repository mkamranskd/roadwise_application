import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:roadwise_application/features/presentation/pages/quiz/starting_page.dart';
import 'package:roadwise_application/global/style.dart';
import '../../../../screens/common_header.dart';
import '../../../../screens/password_reset_screen.dart';
import '../../../../screens/sign_up_screen.dart';



class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FadeInUp(
          duration: const Duration(milliseconds: 100),
          child: Column(

            children: <Widget>[
              const CommonHeader(title: 'Road Wise'),
              FadeInUpBig(duration: const Duration(milliseconds: 400),child:  H1(title: "Login First",clr: primaryBlueColor,)),

              Padding(
                padding: const EdgeInsets.fromLTRB(20,0 , 20,0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      child: Container(
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
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1))),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email or Phone number",
                                  hintStyle: TextStyle(color: Colors.grey[700], fontFamily: 'Dubai'),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey[700], fontFamily: 'Dubai'),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),


                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      child: CustomButton(
                        title: "Login ",
                        navigateTo: Question1(),
                        clr1: primaryBlueColor,
                        clr2: primaryBlueColor,
                      ),
                    ),

                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: const CustomButton(
                        title: "Sign Up",
                        navigateTo: SignUpPage(),
                        clr1:  Color.fromRGBO(104, 159, 56, 1),
                        clr2:  Color.fromRGBO(104, 159, 56, 1),
                      ),
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: const CustomButton(
                        title: "Forgot Password?",
                        navigateTo: PasswordResetPage(),
                        clr1: Color.fromRGBO(255, 0, 0, 1),
                        clr2: Color.fromRGBO(255, 0, 0, 1),
                      ),
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
}
