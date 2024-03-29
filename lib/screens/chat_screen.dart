import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class ChatScreen extends StatelessWidget {
  final Message message;

  const ChatScreen({super.key, required this.message});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(message.sender),
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.call, size: 20, color: Colors.black),
                onPressed: () {},
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(
                    Icons.more_vert_rounded, size: 20, color: Colors.black),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                // Assuming 'message' is a list of messages and each message has 'message' and 'time' properties


                // Return widget for each message
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent, // Change color according to your preference
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      const Text(
                        "time",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                );
              },
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
                  icon: const Icon(Icons.send),
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