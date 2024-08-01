import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../global/style.dart';
import 'dashboard_screen.dart';

class ChatScreen extends StatelessWidget {
  final Message message;

  const ChatScreen({super.key, required this.message});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.only(left: 8.0), // Adjust padding as needed
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(message.image.toString()) as ImageProvider<Object>,
              ),
              SizedBox(width: 8.0), // Adjust spacing between the CircleAvatar and Text
              Text(
                message.sender,
                style: TextStyle(
                  color: primaryBlueColor,
                  fontFamily: 'Dubai',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: primaryBlueColor, size: 15),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.call, size: 20, color: primaryBlueColor),
              onPressed: () {
                // Add your call functionality here
              },
            ),
          ),
          SizedBox(width: 8.0), // Add spacing between action icons if needed
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.more_vert_rounded, size: 20, color: primaryBlueColor),
              onPressed: () {
                // Add your additional functionality here
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Say Hello",
                  style: TextStyle(fontSize: 50),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(AntDesign.send_outline),
                  onPressed: () {
                    // Send message logic here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}