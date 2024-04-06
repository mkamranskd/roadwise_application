import 'package:flutter/material.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/widgets/coloured_button_widget.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/LinkedIn-logo.png",
              width: 120,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Forgot password?",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 33),
            ),
            const SizedBox(
              height: 6,
            ),
            const Text(
              "Reset password in two quick steps",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 25,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Email or Phone"
              ),
            ),
            const SizedBox(height: 20,),
            ColouredButtonWidget(press: (){},text: "Reset password",)
          ],
        ),
      ),
    );
  }
}
