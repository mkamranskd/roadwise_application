


import 'package:flutter/material.dart';
import 'package:roadwise_application/const/app_const.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/add_email_page.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/forgot_password_page.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/join_now_page.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/set_password_page.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/sign_in_page.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/sign_up_page.dart';
import 'package:roadwise_application/features/presentation/pages/starting_page/starting_page.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    switch (settings.name) {
    // Initial Screens

      case PageConst.startingPage:{
          return routeBuilder(const StartingPage());
        }
        case PageConst.setPasswordPage:{
          return routeBuilder(const SetPasswordPage());
        }
        case PageConst.addEmailPage:{
          return routeBuilder(const AddEmailPage());
        }

      case PageConst.forgotPage:{
          return routeBuilder(const ForgotPasswordPage());
        }
      case PageConst.signUpPage:{
          return routeBuilder(const SignUpPage());
        }
      case PageConst.joinPage:{
          return routeBuilder(const JoinNowPage());
        }

      case PageConst.signInPage:
        {
          return routeBuilder(const SignInScreen());
        }
      default:
        {
          const ErrorPage();
        }

    }
    return null;
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
      body: const Center(
        child: Text("Error"),
      ),
    );
  }
}
