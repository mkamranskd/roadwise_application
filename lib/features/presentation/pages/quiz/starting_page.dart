import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roadwise_application/global/Utils.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:animate_do/animate_do.dart';
import 'package:roadwise_application/screens/dashboard_screen.dart';

final _auth = FirebaseAuth.instance;

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentQuestionIndex = 0;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();

  void _navigateToNextQuestion() {
    setState(() {
      _currentQuestionIndex++;
    });
  }

  void _navigateBack(BuildContext context) {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions:[
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const DashBoard()));
          }, child: const Text("Skip For Now",style: TextStyle(color: Colors.black),))
        ],
        title: const H3(
          title: "Tell Us About Yourself",
          clr: Colors.white,
        ),
        backgroundColor: primaryBlueColor,
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
                _navigateBack(context);
              },
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        // Wrap your Container with SingleChildScrollView
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // Ensure that Column takes minimum required space
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              // Set the height of the container to full screen height
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/quiz_background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: FadeInUpBig(
                duration: const Duration(milliseconds: 1000),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 70,
                        ),
                        ProgressBar(count: _currentQuestionIndex + 1, total: 5),
                        // Assuming there are 3 questions
                        if (_currentQuestionIndex == 0) ...[
                          _buildQuestion0(),
                        ] else if (_currentQuestionIndex == 1) ...[
                          _buildQuestion1(),
                        ] else if (_currentQuestionIndex == 2) ...[
                          _buildQuestion2(),
                        ] else if (_currentQuestionIndex == 3) ...[
                          _buildQuestion3(),
                        ] else if (_currentQuestionIndex == 4) ...[
                          _buildQuestion4(),
                        ],
                        const SizedBox(
                          height: 50,
                        ),
                        /*Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                              onTap: _currentQuestionIndex == 4 ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const DashBoard()),
                                );
                              }  : _navigateToNextQuestion,
                              title: _currentQuestionIndex == 4 ? "Finish" : "Next",

                              clr1: primaryBlueColor,
                              clr2: const Color.fromRGBO(104, 159, 56, 1),
                            ),
                          ],
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion0() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          const H2(
            title: "Personal Information",
            clr: Colors.white,
          ),
          TEXTBOX(
            title: "First Name",
            cont: firstNameController,
          ),
          TEXTBOX(
            title: "Last Name",
            cont: lastNameController,
          ),
          TEXTBOX(
            title: "Age",
            cont: ageController,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () async{
                  await FirebaseFirestore.instance.collection("Users").doc(_auth.currentUser?.uid).set({
                    "updatedAt": DateTime.now(),
                    "userId": _auth.currentUser?.uid,
                    "firstName":firstNameController.text.toString(),
                    "lastName":lastNameController.text.toString(),
                    "age":ageController.text.toString()

                  }).then((value) => (){
                    Utils.toastMessage(context, "Saved \nMoving to next", Icons.abc);

                  }).onError((error, stackTrace) => (){
                    Utils.toastMessage(context, error.toString(), Icons.abc);
                  });
                  setState(() {
                    _currentQuestionIndex++;
                  });
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        primaryBlueColor,
                        const Color.fromRGBO(104, 159, 56, 1)
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Dubai',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion1() {
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    return FadeInUp(

      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          const H2(
            title: "Personal Information?",
            clr: Colors.white,
          ),
          TEXTBOX(
            title: "Phone",
            cont: phoneController,
          ),
          TEXTBOX(
            title: "Address",
            cont: addressController,
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () async{
                  await FirebaseFirestore.instance.collection("Users").doc(_auth.currentUser?.uid).set({
                    "updatedAt": DateTime.now(),
                    "phoneNumber":phoneController.text.toString(),
                    "Address":addressController.text.toString()

                  },SetOptions(merge: true));
                  setState(() {
                    _currentQuestionIndex++;
                  });
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        primaryBlueColor,
                        const Color.fromRGBO(104, 159, 56, 1)
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Dubai',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion10() {
    TextEditingController districtController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          const H2(
            title: "Where are You From?",
            clr: Colors.white,
          ),
          const CAPTION(title: "We are Just working in Two Cities only."),
          CustomComboBox(
            title: "District*",
            items: const ['Shaheed Benazir Abad', 'Hyderabad'],
            controller: districtController,
          ),
          CustomComboBox(
            title: "City*",
            items: const ['Nawabshah', 'Sakrand'],
            controller: cityController,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion2() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          const H2(
            title: "Which class you've just Passed??",
            clr: Colors.white,
          ),
          const CAPTION(
              title: "Skip Semester if you've just passed Enter or matric"),
          CustomComboBox(title: "Class*", items: const [
            'Matric',
            'Enter',
            'BS',
            'BSC',
            'MS',
            'M-PHIL',
            'PHD'
          ]),
          CustomComboBox(
              title: "Semester",
              items: const ['1', '2', '3', '4', '5', '7', '8']),
        ],
      ),
    );
  }

  Widget _buildQuestion3() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          const H2(
            title: "From?",
            clr: Colors.white,
          ),
          const CAPTION(
              title: "From Which institute you passed your last degree"),
          CustomComboBox(title: "City*", items: const ['Nawabshah', 'Sakrand']),
          CustomComboBox(
              title: "Institute Name*", items: const ['Nawabshah', 'Sakrand']),
        ],
      ),
    );
  }

  Widget _buildQuestion4() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: const Column(
        children: [
          H2(
            title: "Educational Interests?",
            clr: Colors.white,
          ),
          CAPTION(title: "Select the Field you are interested in "),
          TextWithIcon(
            options: [
              'Engineering',
              'Medical',
              'Arts',
              'Commerce',
              'not Listed'
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion5() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: const Column(
        children: [
          H2(
            title: "Choose Gender?",
            clr: Colors.white,
          ),
          CAPTION(title: "Select Your Gender"),
          TextWithIcon(
            options: ['Male', 'female', 'Rather not say'],
          ),
        ],
      ),
    );
  }
}
