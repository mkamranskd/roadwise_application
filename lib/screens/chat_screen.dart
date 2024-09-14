import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'dashboard_screen.dart';

class ChatScreen extends StatelessWidget {
  final Message message;

  const ChatScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading: false, // Prevent default leading widget
        title: Row(
          children: [
            // Back Button
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(message.image.toString())
                    as ImageProvider<Object>,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      message.sender,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.call,
            ),
            onPressed: () {
              // Add your call functionality here
            },
          ),
          PopupMenuButton<int>(
            icon: const Icon(
              Icons.more_vert_rounded,
            ),
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(value: 0, child: Text('Clear Chat')),
              const PopupMenuItem<int>(value: 1, child: Text('Delete Chat')),
              const PopupMenuItem<int>(value: 2, child: Text('Archive Chat')),
              const PopupMenuItem<int>(value: 3, child: Text('Close Chat')),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Add your chat messages here
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[800],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Text(
                      "Say Hello",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(
                      Icons.emoji_emotions,
                    ),
                    onPressed: () {},
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      AntDesign.send_outline,
                    ),
                    onPressed: () {},
                  ),
                  hintText: 'Type a message...',
                ),
              ),
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
