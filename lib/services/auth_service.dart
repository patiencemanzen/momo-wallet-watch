import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? _baseUrl = dotenv.env['MTN_BASE_URL'];
String? _clienApiKey = dotenv.env['MTN_API_KEY'];
String? _clientApiUser = dotenv.env['MTN_API_USER'];
String? _subscriptionKey = dotenv.env['MTN_SUBSCRIPTION_KEY'];

class AuthService {
  final String authUrl = '$_baseUrl/collection/token/';

  Future<String> getAccessToken() async {
    final useKey = _clientApiUser;
    final apiKey = _clienApiKey;
    final subscriptionKey = _subscriptionKey ?? "";

    final response = await http.post(
      Uri.parse(authUrl),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$useKey:$apiKey'))}',
        'Cache-Control': 'no-cache',
        'Ocp-Apim-Subscription-Key': subscriptionKey,
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }
}
