import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class ChatScreen extends StatelessWidget {
  final Message message;

  const ChatScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(message.sender),
      ),
      body: Center(
        child: Text(message.message),
      ),
    );
  }
}
