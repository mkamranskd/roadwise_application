import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/sign_in_page.dart';
import 'package:roadwise_application/global/Utils.dart';
import 'package:roadwise_application/global/style.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

   bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: FadeInUp(
          duration: const Duration(milliseconds: 100),
          child: Column(

            children: <Widget>[
              FadeInUpBig(duration: const Duration(milliseconds: 400),child:  H1(title: "Sign Up",clr: primaryBlueColor,)),

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
                                  keyboardType:TextInputType.emailAddress,

                                  controller: emailController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    prefixIcon: Icon(Icons.alternate_email_rounded,size: 20, color: primaryBlueColor,),
                                    hintStyle: TextStyle(color: Colors.grey[700], fontFamily: 'Dubai'),
                                  ),

                                ),

                              ),

                              Container(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: TextFormField(
                                  keyboardType:TextInputType.text,
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    prefixIcon: Icon(Icons.lock_open_outlined,size: 20, color: primaryBlueColor,),
                                    hintStyle: TextStyle(color: Colors.grey[700], fontFamily: 'Dubai'),
                                  ),

                                ),

                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),


                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      child: CustomButton(
                        loading: loading,
                        title: "Sign Up",
                        onTap: (){
                          if(_formKey.currentState!.validate()){
                            signUp();
                          }
                        },
                        clr1: primaryBlueColor,
                        clr2: primaryBlueColor,
                      ),
                    ),


                    FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an Account?"),
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignInScreen()));
                          }, child: const Text("Login")),
                        ],
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

  void signUp() {
    setState(() {
      loading = true;
    });
    _auth.createUserWithEmailAndPassword(email: emailController.text.toString(), password:passwordController.text.toString() ).then((value) {
      Utils.toastMessage(context, "Account Created Successfully\nRedirecting to the Login Screen", Icons.check_circle_outline);
      Timer(
        const Duration(seconds: 2),
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
