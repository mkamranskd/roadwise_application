import 'package:flutter/material.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:animate_do/animate_do.dart';
import 'package:roadwise_application/screens/dashboard_screen.dart';

class Question1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title:  const H3(title: "Tell Us About Yourself",clr: Colors.white,),
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        actions: const [],
      ),
      backgroundColor: Colors.transparent, // Set background color to transparent
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/quiz_background.jpg"), // Path to your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 70,),
              FadeInUpBig(duration: const Duration(milliseconds: 800),child: const H2(title: "Where are You From?",clr: Colors.white,)),
              FadeInUpBig(duration: const Duration(milliseconds: 1000),child: const CAPTION(title: "We are Just working in Two Cities only.")),
              FadeInUpBig(duration: const Duration(milliseconds: 1000),child: CustomComboBox(title: "Location*",items: const ['Sakrand', 'Nawabshah'])),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FadeInUpBig(duration: const Duration(milliseconds: 1800),child: Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                        title: "Next" ,
                        navigateTo: Question2(),
                        clr1: primaryBlueColor,
                        clr2: const Color.fromRGBO(104, 159, 56, 1),
                      ),
                    )),
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

class Question2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title:  const H3(title: "Tell Us About Yourself",clr: Colors.white,),
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        actions: const [],
      ),
      backgroundColor: Colors.transparent, // Set background color to transparent
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/quiz_background.jpg"), // Path to your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 70,),
              FadeInUpBig(duration: const Duration(milliseconds: 800),child: const H2(title: "In which class you are right now??",clr: Colors.white,)),
              FadeInUpBig(duration: const Duration(milliseconds: 1000),child: const CAPTION(title: "Skip Semester if you've just passed Enter or matric")),
              FadeInUpBig(duration: const Duration(milliseconds: 1000),child: CustomComboBox(title: "Class*",items: const ['Matric', 'Enter','BS','BSC','MS','MPHIL','PHD'])),
              FadeInUpBig(duration: const Duration(milliseconds: 1000),child: CustomComboBox(title: "Semester",items: const ['1','2','3','4','5','7','8'])),
              const SizedBox(height: 50,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      title: "Next",
                      navigateTo: Question3(),
                      clr1: primaryBlueColor,
                      clr2: const Color.fromRGBO(104, 159, 56, 1),
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

class Question3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title:  const H3(title: "Tell Us About Yourself",clr: Colors.white,),
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        actions: const [],
      ),
      backgroundColor: Colors.transparent, // Set background color to transparent
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/quiz_background.jpg"), // Path to your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 70,),
              FadeInUpBig(duration: const Duration(milliseconds: 800),child: const H2(title: "Educational Interests?",clr: Colors.white,)),
              FadeInUpBig(duration: const Duration(milliseconds: 1000),child: const CAPTION(title: "Select the Field you are interested in ")),
              FadeInUpBig(duration: const Duration(milliseconds: 1000),child: const TextWithIcon(options: ['Engineering', 'Medical', 'Arts','Commerce','Not Listed'],),),
              const SizedBox(height: 50,),
               Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      title: "Next",
                      navigateTo: const DashBoard(),
                      clr1: primaryBlueColor,
                      clr2: const Color.fromRGBO(104, 159, 56, 1),
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
