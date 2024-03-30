import 'package:flutter/material.dart';
import 'package:roadwise_application/const/app_const.dart';
import 'package:roadwise_application/global/style.dart';

PreferredSizeWidget appBarWidget({VoidCallback? onTap, String? title,bool? isJobTab}){
  return AppBar(
    backgroundColor:primaryBlueColor,
    elevation: 0,
    leading: GestureDetector(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.only(left: 20),
       child: CircleAvatar(backgroundImage: AssetImage("assets/profiles/profile2.jpg"),)
      ),
    ),
    title: Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: SizedBox(
        height: 40.0, // Adjust the height as needed
        child: Container(
          //padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Find Here',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search_sharp, color: Colors.blue),
              //suffixIcon: const Icon(Icons.filter_list),

              contentPadding:  EdgeInsets.fromLTRB(10, 5, 10, 0),// Reduced vertical padding
            ),
          ),
        ),
      ),

    ),
    actions: [
      IconButton(onPressed: (){}, icon:  Image.asset("assets/icons/email.png",height: 30,)),
      /*isJobTab == false? IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.message,size: 15,color: Colors.white,))
          : Row(
        children: [
          Icon(FontAwesomeIcons.message,size: 15,color: Colors.white,),
          sizeHor(10),
          Icon(Icons.more_vert,size: 15,color: Colors.white),
        ],
      ),*/
      sizeHor(10),
    ],
  );
}