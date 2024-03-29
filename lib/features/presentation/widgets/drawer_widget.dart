import 'package:flutter/material.dart';
import 'package:roadwise_application/const/app_const.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizeVer(40),
                        Container(
                          width: 90,
                          height: 90,
                          child: const CircleAvatar(backgroundImage: AssetImage("assets/profiles/profile2.jpg"),),
                        ),
                        sizeVer(10),
                        const Text(
                          "Muhammad Kamran",
                          style:
                              TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        sizeVer(5),
                        const Text(
                          "View profile",
                          style:
                              TextStyle(color: Colors.grey,fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  sizeVer(10),
                  const Divider(color: Colors.grey,),
                  sizeVer(30),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Groups",
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                  ),
                  sizeVer(30),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Events",
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.grey,),
          Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 20),
            child: Column(
              children: [
                sizeVer(20),
                Row(
                  children: [
                    const Icon(
                      Icons.settings,
                      size: 30,
                      color: Colors.grey,
                    ),
                    sizeHor(10),
                    const Text(
                      "Settings",
                      style: TextStyle(

                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
