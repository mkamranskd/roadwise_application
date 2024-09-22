
import 'package:flutter/material.dart';


class StepperScreen extends StatefulWidget {
  @override
  _StepperScreenState createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  int _currentStep = 0;

  // This method handles when the user taps the continue button
  void _onStepContinue() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  // This method handles when the user taps the cancel/back button
  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }
  String? selectedInterest;
  String? selectedSubfield;
  final List<String> interests = [
    "Computer Science",
    "Business Administration",
    "Mechanical Engineering",
    "Medical Science",
    "Law",
    "Arts and Humanities"
  ];
  // This method defines the actual content of each step
  List<Step> _getSteps() {
    return [
      Step(
        title: const Text('What is your field of interest?'),
        content:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("What is your field of interest?",
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedInterest,
              hint: const Text("Select your interest"),
              items: interests.map((String interest) {
                return DropdownMenuItem<String>(
                  value: interest,
                  child: Text(interest),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedInterest = newValue;
                  _onStepContinue();
                  // updateDetails(newValue!);
                  // updateSubfields(newValue);
                });
              },
            ),

          ],
        ),
        isActive: _currentStep >= 0,
        state: _currentStep == 0 ? StepState.editing : StepState.complete,
      ),
      Step(
        title: const Text('Step 2'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter your email'),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 1,
        state: _currentStep == 1 ? StepState.editing : StepState.complete,
      ),
      Step(
        title: const Text('Step 3'),
        content: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Confirm your information'),
            SizedBox(height: 10),
            Text('Name: John Doe'),
            Text('Email: john.doe@example.com'),
          ],
        ),
        isActive: _currentStep >= 2,
        state: _currentStep == 2 ? StepState.editing : StepState.complete,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Stepper Example'),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        steps: _getSteps(),
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: const Text('CONTINUE'),
                ),
              ),
              const SizedBox(width: 8),
              if (_currentStep != 0)
                ElevatedButton(
                  onPressed: details.onStepCancel,
                  child: const Text('BACK'),
                ),
            ],
          );
        },
      ),
    );
  }
}
