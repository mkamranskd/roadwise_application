import 'package:flutter/material.dart';
import 'package:roadwise_application/const/app_const.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/widgets/coloured_button_widget.dart';
import 'package:roadwise_application/features/presentation/widgets/form_container_widget.dart';
import 'package:roadwise_application/global/style.dart';

class SetPasswordPage extends StatelessWidget {
  const SetPasswordPage({Key? key}) : super(key: key);

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
              "Set your password",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 33),
            ),
            sizeVer(60),
            const FormContainerWidget(hintText: "Email",),
            sizeVer(20),
            const FormContainerWidget(hintText: "Password",isPasswordField: true,),
            sizeVer(15),
            Column(
              children: [
                Row(
                  children: [
                    const Text("You agree to the LinkedIn",style: TextStyle(color: Colors.grey),),
                    sizeHor(5),
                    const Text("User Agreement .",style: TextStyle(color: kPrimaryColor),),
                  ],
                ), Row(
                  children: [
                    const Text("Privacy Policy",style: TextStyle(color: kPrimaryColor)),
                    sizeHor(5),
                    const Text("and"),
                    sizeHor(5),
                    const Text("Cookie Policy.",style: TextStyle(color: kPrimaryColor)),
                  ],
                ),

              ],
            ),
            sizeVer(20),
            ColouredButtonWidget(press: (){},text: "Agree & Join",)
          ],
        ),
      ),
    );
  }
}
