import 'package:flutter/material.dart';
import 'package:roadwise_application/const/app_const.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/widgets/coloured_button_widget.dart';
import 'package:roadwise_application/features/presentation/widgets/form_container_widget.dart';

class AddEmailPage extends StatelessWidget {
  const AddEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/LinkedIn-logo.png",
              width: 90,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Add your email or phone",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 33),
            ),
            const SizedBox(
              height: 30,
            ),
            const FormContainerWidget(hintText: "Email or Phone"),
            const SizedBox(
              height: 20,
            ),
            ColouredButtonWidget(
              press: () {
                Navigator.pushNamed(context, PageConst.setPasswordPage);
              },
              text: "Continue",
            ),
          ],
        ),
      ),
    );
  }
}
