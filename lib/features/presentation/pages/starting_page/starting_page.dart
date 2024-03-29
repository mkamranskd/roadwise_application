import 'package:flutter/material.dart';
import 'package:roadwise_application/const/app_const.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/sign_in_page.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/widgets/coloured_button_widget.dart';
import 'package:roadwise_application/global/style.dart';

class StartingPage extends StatelessWidget {
  const StartingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 140,
              ),
              Image.asset(
                "assets/LinkedIn-logo.png",
                width: 210,
              ),
              Text(
                "Join a trusted community of 800M professionals",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, color: Colors.grey[800]),
              ),
              const Spacer(),
              ColouredButtonWidget(
                text: "Join Now",
                press: (){
                  Navigator.pushNamed(context, PageConst.joinPage);
                },),
              const SizedBox(height: 15),
              /*ButtonContainerWidget(
                press: () {},
                text: "Join with Google",
                icon: FontAwesomeIcons.google,
              ),
              const SizedBox(height: 15),
              ButtonContainerWidget(
                press: () {},
                text: "Join with Facebook",
                icon: FontAwesomeIcons.facebook,
              ),*/
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => SignInScreen()));
                },
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
