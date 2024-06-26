


import 'package:flutter/material.dart';

class ButtonContainerWidget extends StatelessWidget {
  final VoidCallback press;
  final String? text;
  final IconData? icon;
  const ButtonContainerWidget({Key? key, required this.press, this.text, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all()
        ),
        child: Row(

          children: [
            const SizedBox(width: 60,),
            Icon(icon),
            const SizedBox(width: 10,),

            Text(
              "$text",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
