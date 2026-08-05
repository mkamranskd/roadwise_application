import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class ChatbotService {
  static const _scopes = ['https://www.googleapis.com/auth/cloud-platform'];
  late AccessCredentials _credentials;
  late http.Client _client;

  Future<void> initialize() async {
    final jsonCredentials = {
      "type": "service_account",
      "project_id": "roadwise-application-54684",
      "private_key_id": "",
      "private_key": "",
      "client_email": "",
      "client_id": "",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": ""
    };

    final accountCredentials = ServiceAccountCredentials.fromJson(jsonCredentials);
    _client = http.Client();
    _credentials = await obtainAccessCredentialsViaServiceAccount(accountCredentials, _scopes, _client);
  }

  Future<String> getChatbotResponse(String query) async {
    final url = 'https://dialogflow.googleapis.com/v2/projects/roadwise-application-54684/agent/sessions/123456789:detectIntent';

    final response = await _client.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${_credentials.accessToken.data}',
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode({
        'query_input': {
          'text': {
            'text': query,
            'language_code': 'en',
          },
        },
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse['queryResult']['fulfillmentText'];
    } else {
      throw Exception('Failed to get response from Dialogflow: ${response.body}');
    }
  }
}
