import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/transaction.dart';
import 'auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? _baseUrl = dotenv.env['MTN_BASE_URL'];
String? _subscriptionKey = dotenv.env['MTN_SUBSCRIPTION_KEY'] ?? "";

class TransactionService {
  final String baseUrl = '$_baseUrl/collection/v1_0/';
  final AuthService authService = AuthService();

  Future<List<Transaction>> getTransactionsByNumber(String phoneNumber) async {
    final token = await authService.getAccessToken();
    final subscriptionKey = _subscriptionKey ?? "";

    final response = await http.get(
      Uri.parse('$baseUrl/accountholder/MSISDN/0780289432/basicuserinfo'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-Target-Environment': 'sandbox',
        'Cache-Control': 'no-cache',
        'Ocp-Apim-Subscription-Key': subscriptionKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch transactions');
    }
  }
}
