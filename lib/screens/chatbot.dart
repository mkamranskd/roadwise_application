import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:roadwise_application/firebase_services/chatbot_service.dart';
import 'package:roadwise_application/screens/settings.dart';

import '../hierarchical/UnderTestingActualLoadingEducationFromFirebase.dart';

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

    // Ensure the scroll controller is attached before attempting any scroll action
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _sendMessage() async {
    final message = _controller.text;
    if (message.isEmpty) return;

    // Add user message to the list
    setState(() {
      _messages.add({'role': 'user', 'text': message});
    });

    // Clear the text field and focus it again
    _controller.clear();
    _focusNode.requestFocus();

    // Scroll to the bottom after adding the message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    try {
      // Send message to the chatbot service and wait for a response
      final response = await _chatbotService.getChatbotResponse(message);

      // If the response contains navigation instructions, process them
      if (response.contains('navigate_to_screen')) {
        final parsedResponse = _parseNavigationResponse(response);
        if (parsedResponse != null && parsedResponse['screen'] != null) {
          // Delay and navigate to the screen
          await Future.delayed(const Duration(seconds: 2)); // 2-second delay
          _navigateToScreen(parsedResponse['screen']!); // Navigate to the screen
        } else {
          // If no valid navigation screen is found, show the bot's response
          setState(() {
            _messages.add({'role': 'bot', 'text': 'I am unable to process your request at the moment.'});
          });
        }
      } else {
        // Otherwise, add bot response to the list normally
        setState(() {
          _messages.add({'role': 'bot', 'text': response});
        });
      }

      // Scroll to the bottom after processing the response
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      // Handle any errors and show error message
      setState(() {
        _messages.add({'role': 'bot', 'text': 'Error: $e'});
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }



  Map<String, String>? _parseNavigationResponse(String response) {
    try {
      final parsedResponse = jsonDecode(response);
      // Check if it's a navigation response and if the screen is provided
      if (parsedResponse['action'] == 'navigate_to_screen' && parsedResponse['screen'] != null) {
        return {'screen': parsedResponse['screen']};
      }
    } catch (e) {
      print('Error parsing navigation response: $e');
    }
    return null;  // Return null if no valid navigation screen is found
  }



  void _navigateToScreen(String screenName) {
    // Add logic to navigate to the specified screen
    if (screenName == 'SettingsScreen') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()), // Define SettingsScreen separately
      );
    } else if (screenName == 'EducationDropdownScreen') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EducationDropdownScreen()), // Define ProfileScreen separately
      );
    } else {
      // Handle case for an unknown screen
      print('Unknown screen: $screenName');
    }
  }



  void _scrollToBottom() {
    // Ensure that the ScrollController is attached before scrolling
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget customMessageContainer(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.text = text;
          _sendMessage();
        });
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
          
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.7,
                          child: Image.network(
                            'https://cdn-icons-png.flaticon.com/512/8943/8943377.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'Chat with our bot?',
                              textStyle: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                              speed: const Duration(milliseconds: 100),
                            ),
                          ],
                          totalRepeatCount: 1,
                          pause: const Duration(milliseconds: 3000),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  customMessageContainer('Hi'),
                                  customMessageContainer('Who are you?'),
                                  customMessageContainer('What can you do?'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  customMessageContainer('What is RightWay?'),
                                  customMessageContainer('Who are Developers?'),
                                  customMessageContainer('Contact '),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  customMessageContainer('I\'ve done my HSC?'),
                                  customMessageContainer('Help me choosing University'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ListTile(
                        tileColor: Colors.transparent,
                        title: Align(
                          alignment: message['role'] == 'user'
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: message['role'] == 'user'
                                  ? Colors.blue
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              message['text'] ?? '',
                              style: TextStyle(
                                color: message['role'] == 'user'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    // Attach the FocusNode to the TextField
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                    onSubmitted: (value) =>
                        _sendMessage(), // Send message on Enter key
                  ),
                ),
                IconButton(
                  icon: const Icon(AntDesign.send_outline),
                  onPressed: () {
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
