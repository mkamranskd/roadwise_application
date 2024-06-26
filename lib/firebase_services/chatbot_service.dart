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
      "private_key_id": "7cd0ca88422815e644dea8981b52b3920ea67bb8",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDBRvFH7TG85fob\nAHKGu3Km/iaTVkRs422odaVfjy683rfZ54C7YKpKc3TqUOU9SjWEjlZtLsQSwpa3\nZgEB9F1aI8s6bDD2rD53QFLvlbfln6Ni3cuMRLg4h82TpDl0L8D6pynFbSfJ/VnJ\nozzBZV8db47KhO9cku++piBhCgcpueezKRGxIKCiNKLntyczFJL1mm6DLYgkM/QA\nqIOW4F0lPyH+uEiozDuX5UiWhDnQGcJmwYAyWZQX0dR4ma6Biz2O6ekZbs6JfK4X\nBkd1LTFHoCf8oTF1SizOGfRSqaKT118JX3I2gLzpvctYbNtiinvWEZWGmWOuO5xP\npGMN/fS7AgMBAAECggEAHeociyznr1yLBuXdVAQsPTOGBfTqt03GGbZHx9ASBFKW\ncygVMStHgCl5lZC6wm87dE5RiymbWGn8yNsFWeeYEU0L9flr5KoJKwzuKT3rjiNU\ntwcsK4QxXTKLu4fGCrkfbcw0t2VrLKTFYmOdEjPd8mDjYW4M3C+z4ra0uUBDlo31\nxl2fzA53XnsPwH/coeRDUaJV79lxBh3f3eUIBxyg5lDTxC7u7yEFHuhrt/VjbzD2\nk2DO4lS1tZ6vL5HVNZVLxdU9qvYGGFzp0k2kWa3S1nzRIFThmwcLxbpmB2+SRpe2\nUeuEd91Wd7pQwOm57R/H2I/wLp3Op5T5QHUYpkK5HQKBgQD5BWtvJPZU1vF9wJgU\nGL0Ol1s9tptFXsEx9kCNiKgRBcPbaIsR1nBC4yWFXFROaOnz8bIwHU4ZRyL6ldnI\n9+91JH67ak+wBH4IKY4yfvcKlbj1sTQIxLzuWUsxsnOBGJJzqGU4eh+ZdEjT9pxZ\nC2WTRIKHf2D2gZWC4/q/Zth4jQKBgQDGsZeSeqS9Q7/dWYF/tSDPCXGdMOHWw7Wd\nCQIKRHb2becDlHSVcwy7I+IB1TH940Vqe0ir+3bDyDSt/aCesnF2cKB31yGdyL7X\nnY3r3dCUv9FgH2/JBybLx//3sUuAfDdH1ZSSAhdcJC8VTvMgfAYoLAHXymw4ZGvU\nTviX2GBEZwKBgQCx4w07+Et/j4wzKMF6mbF0Gusyyp9gjq+z4RV8BYMJpfSjZ6rw\nsx6+qUTEX5BZ8tgtSxrfBBAmPoreNu28gmCsbcWaW/dQ5eSiMA1ERS50gT//QvbI\nzMGqAl+UwMWCEuuLc1/bWGH6XPcpc6F8eoe1C9uyr2u0rB0Bw5n74JwCgQKBgGK7\noOwC0ZXS8qZVcco6AUGgGbrYrYCA4+BSt5bOiqbN2funa39QGkVsAUST4jGdG8Nb\n27LKVCvZcoP7AjOZzFPkh3jFiEjVli+idQF9ycYAw1QWiv/D8/1TNtioWzJPh1DE\nyvz62QzKVjMqdhnwR0bzBz9psPkcvZBUZadeuAeFAoGBAKEbPSQdG2ntiYz65ElX\nR7ezkd4etmeFy7NWdtWLI5QJ6gVi6JaO1SZwr0anf22yTmrKSYTRnD9+LXq6u017\noEff9XWqZ7UMJTyiKI/2tsdbsxNDwvHiJanhg5Tk0pkBPIEcqf2WVYPcplASU4mA\nc5C3G/nxHWn+UMrK5GqYQ18N\n-----END PRIVATE KEY-----\n",
      "client_email": "roadwise-application-54684@appspot.gserviceaccount.com",
      "client_id": "111941203858011655279",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/roadwise-application-54684%40appspot.gserviceaccount.com"
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
