import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:roadwise_application/global/style.dart';

class Utils {
  static void toastMessage(BuildContext context, String title,IconData icon) {
    CherryToast(
      icon: icon,
      animationDuration: const Duration(milliseconds: 600),
      description: Text(title),
      animationType: AnimationType.fromTop,
      enableIconAnimation: true,
      //action: const Text('Backup data'),
      actionHandler: () {}, themeColor: primaryBlueColor,
    ).show(context);
  }
}