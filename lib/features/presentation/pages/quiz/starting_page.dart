import 'package:flutter/material.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:animate_do/animate_do.dart';
import 'package:roadwise_application/screens/dashboard_screen.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentQuestionIndex = 0;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const H3(title: "Tell Us About Yourself", clr: Colors.white,),
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
        actions: const [],
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView( // Wrap your Container with SingleChildScrollView
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensure that Column takes minimum required space
          children: [

            Container(
              height: MediaQuery.of(context).size.height, // Set the height of the container to full screen height
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
                        const SizedBox(height: 70,),
                        ProgressBar(count: _currentQuestionIndex + 1 , total: 4), // Assuming there are 3 questions
                        if (_currentQuestionIndex == 0) ...[
                          _buildQuestion1(),
                        ] else if (_currentQuestionIndex == 1) ...[
                          _buildQuestion2(),
                        ] else if (_currentQuestionIndex == 2) ...[
                          _buildQuestion3(),
                        ] else if (_currentQuestionIndex == 3) ...[
                          _buildQuestion4(),
                        ],
                        const SizedBox(height: 50,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                              onTap: _currentQuestionIndex == 3 ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const DashBoard()),
                                );
                              }  : _navigateToNextQuestion,
                              title: _currentQuestionIndex == 3 ? "Finish" : "Next",

                              clr1: primaryBlueColor,
                              clr2: const Color.fromRGBO(104, 159, 56, 1),
                            ),
                          ],
                        ),
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


  Widget _buildQuestion1() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          const H2(title: "Where are You From?", clr: Colors.white,),
          const CAPTION(title: "We are Just working in Two Cities only."),
          CustomComboBox(title: "District*", items: const ['Shaheed Benazir Abad','Hyderabad']),
          CustomComboBox(title: "City*", items: const ['Nawabshah','Sakrand']),
        ],
      ),
    );
  }

  Widget _buildQuestion2() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          const H2(title: "Which class you've just Passed??", clr: Colors.white,),
          const CAPTION(title: "Skip Semester if you've just passed Enter or matric"),
          CustomComboBox(title: "Class*", items: const ['Matric', 'Enter','BS','BSC','MS','M-PHIL','PHD']),
          CustomComboBox(title: "Semester", items: const ['1','2','3','4','5','7','8']),
          ],
      ),
    );
  }

  Widget _buildQuestion3() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          const H2(title: "From?", clr: Colors.white,),
          const CAPTION(title: "From Which institute you passed your last degree"),
          CustomComboBox(title: "City*", items: const ['Nawabshah','Sakrand']),
          CustomComboBox(title: "Institute Name*", items: const ['Nawabshah','Sakrand']),

        ],
      ),
    );
  }
  Widget _buildQuestion4() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: const Column(
        children: [
          H2(title: "Educational Interests?", clr: Colors.white,),
          CAPTION(title: "Select the Field you are interested in "),
          TextWithIcon(options: ['Engineering', 'Medical', 'Arts','Commerce','Not Listed''Engineering', 'Medical', 'Arts','Commerce','Not Listed''Engineering', 'Medical', 'Arts','Commerce','Not Listed'],),
        ],
      ),
    );
  }

}
