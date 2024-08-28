import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../global/style.dart';
import 'dashboard_screen.dart';

class ChatScreen extends StatelessWidget {
  final Message message;

  const ChatScreen({super.key, required this.message});

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
          IconButton(
            icon: Icon(Icons.call, color: primaryBlueColor),
            onPressed: () {
              // Add your call functionality here
            },
          ),
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert_rounded, color: primaryBlueColor),
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text('Clear Chat')),
              PopupMenuItem<int>(value: 1, child: Text('Delete Chat2')),
              PopupMenuItem<int>(value: 2, child: Text('Archive Chat')),
              PopupMenuItem<int>(value: 3, child: Text('Close Chat4')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                // Add your chat messages here
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Say Hello",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                CircleAvatar(
                  backgroundColor: primaryBlueColor,
                  child: IconButton(
                    icon: Icon(AntDesign.send_outline, color: Colors.white),
                    onPressed: () {
                      // Send message logic here
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
      // Handle Option 1
        break;
      case 1:
      // Handle Option 2
        break;
      case 2:
      // Handle Option 3
        break;
      case 3:
      // Handle Option 4
        break;
    }
  }
}
