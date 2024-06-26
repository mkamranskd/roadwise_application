import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:animate_do/animate_do.dart';
import 'package:roadwise_application/screens/dashboard_screen.dart';

final _auth = FirebaseAuth.instance;

class CompleteProfile extends StatefulWidget {
  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {

  int _currentQuestionIndex = 0;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final provinceController = TextEditingController();
  final classController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _checkUserFields();
  }

   _checkUserFields() async {
    final userData =
    await FirebaseFirestore.instance.collection("Users").doc(_auth.currentUser?.uid).get();
    if (userData.exists) {
      setState(() {

        firstNameController.text = userData.data()!['firstName'].toString();
        lastNameController.text = userData.data()!['lastName'].toString();
        ageController.text = userData.data()!['age'].toString();

         phoneController.text = userData.data()!['phoneNumber'].toString();
         addressController.text = userData.data()!['Address'].toString();
         cityController.text = userData.data()!['city'].toString();
         provinceController.text = userData.data()!['province'].toString();
         classController.text = userData.data()!['justPassedClass'].toString();
        /*if (userData.data()!['firstName'] != null &&
            userData.data()!['lastName'] != null &&
            userData.data()!['age'] != null) {
          _currentQuestionIndex = 2;
        } else if (userData.data()?['phoneNumber'] != null &&
            userData.data()?['province'] != null &&
            userData.data()?['city'] != null &&
            userData.data()?['Address'] != null) {
          _currentQuestionIndex = 3;
        }else{
          _currentQuestionIndex = 5;
        }*/

      });
    }
  }






  /*void _navigateBack(BuildContext context) {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    } else {
      Navigator.pop(context);
    }
  }*/




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions:[
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const DashBoard()));
          }, child:  Text("Skip For Now",style: TextStyle(color: primaryBlueColor),))
        ],
        title:  H3(
          title: "Tell Us About Yourself",
          clr: primaryBlueColor,
        ),


      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Wrap your Container with SingleChildScrollView
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // Ensure that Column takes minimum required space
          children: [
            FadeInUpBig(
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
                      const SizedBox(
                        height: 20,
                      ),
                      // Assuming there are 3 questions
                      if (_currentQuestionIndex == 0) ...[
                        _buildQuestion1(),
                      ] else if (_currentQuestionIndex == 1) ...[
                        _buildQuestion2(),
                      ] else if (_currentQuestionIndex == 2) ...[
                        _buildQuestion3(),
                      ] else if (_currentQuestionIndex == 3) ...[
                        _buildQuestion4(),
                      ] else if (_currentQuestionIndex == 4) ...[
                        _buildQuestion5(),
                      ],

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion1() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
           H2(
            title: "Personal Information",
            clr: primaryBlueColor,
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

          const SizedBox(height: 10,),
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

  Widget _buildQuestion2() {
    return FadeInUp(

      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
           H2(
            title: "Contact Details?",
            clr: primaryBlueColor,
          ),
          TEXTBOX(
            title: "Phone",
            cont: phoneController,
          ),
          CustomComboBox(
            title: "Class*",
            items: const ['Sindh'],firebaseFieldName: "province",


          ),
          CustomComboBox(
            title: "Class*",
            items: const ['Sakrand'
            ],
            firebaseFieldName: "city",

          ),
          TEXTBOX(
            title: "Address",
            cont: addressController,
          ),
          const SizedBox(height: 10,),
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

  Widget _buildQuestion3() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          H2(
            title: "Which class you've just Passed??",
            clr: primaryBlueColor,
          ),

          CustomComboBox(
            title: "Class*",
            items: const [
              'Matric',
              'Enter',
              'BS',
              'BSC',
              'MS',
              'M-PHIL',
              'PHD'
            ],
            firebaseFieldName: "justPassedClass",


          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () async{
                  await FirebaseFirestore.instance.collection("Users").doc(_auth.currentUser?.uid).set({
                    "updatedAt": DateTime.now(),
                    "class":classController.text.toString()

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



  Widget _buildQuestion4() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child:  Column(
        children: [
          H2(
            title: "Educational Interests?",
            clr: primaryBlueColor,
          ),
          const CAPTION(title: "Select the Field you are interested in "),
          const TextWithIcon(
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

/*Widget _buildQuestion10() {
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
  */

}
