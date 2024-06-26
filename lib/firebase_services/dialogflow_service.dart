import 'dart:convert';
import 'package:http/http.dart' as http;

class DialogflowService {
  final String projectId;
  final String sessionId;
  final String languageCode;
  final String authToken;

  DialogflowService({
    required this.projectId,
    required this.sessionId,
    required this.languageCode,
    required this.authToken,
  });

  Future<String> getDialogflowResponse(String query) async {
    final apiUrl = 'https://dialogflow.googleapis.com/v2/projects/$projectId/agent/sessions/$sessionId:detectIntent';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'queryInput': {
          'text': {
            'text': query,
            'languageCode': languageCode,
          },
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['queryResult']['fulfillmentText'];
    } else {
      throw Exception('Failed to get response from Dialogflow. Status Code: ${response.statusCode}');
    }
  }
}
