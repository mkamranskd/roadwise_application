import 'package:flutter/material.dart';
import 'package:roadwise_application/firebase_services/chatbot_service.dart';

import '../global/style.dart';

class Chatbot extends StatefulWidget {
  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // Add a FocusNode
  final List<Map<String, String>> _messages = [];
  late ChatbotService _chatbotService;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatbotService = ChatbotService();
    _chatbotService.initialize().then((_) {
      // Now you can use _chatbotService to get responses
    });
  }

  void _sendMessage() async {
    final message = _controller.text;
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': message});
      _scrollToBottom();
    });

    _scrollToBottom();
    _controller.clear();
    _focusNode.requestFocus(); // Focus the text box after sending

    try {
      final response = await _chatbotService.getChatbotResponse(message);
      setState(() {
        _messages.add({'role': 'bot', 'text': response});
        _scrollToBottom();
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'text': 'Error: $e'});
        _scrollToBottom();
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Chatbot'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new,),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Align(
                    alignment: message['role'] == 'user'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: message['role'] == 'user'
                          ? primaryBlueColor
                          : Colors.grey,
                      child: Text(
                        message['text'] ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode, // Attach the FocusNode to the TextField
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                    onSubmitted: (value) => _sendMessage(), // Send message on Enter key
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: (){
                    _sendMessage();
                    _scrollToBottom();
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
