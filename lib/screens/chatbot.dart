import 'package:flutter/material.dart';
import 'package:roadwise_application/firebase_services/chatbot_service.dart';

class Chatbot extends StatefulWidget {
  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  late ChatbotService _chatbotService;

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
    });

    _controller.clear();

    try {
      final response = await _chatbotService.getChatbotResponse(message);
      setState(() {
        _messages.add({'role': 'bot', 'text': response});
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'text': 'Error: $e'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Align(
                    alignment: message['role'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: message['role'] == 'user' ? Colors.blue : Colors.grey,
                      child: Text(
                        message['text'] ?? '',
                        style: TextStyle(color: Colors.white),
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
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
