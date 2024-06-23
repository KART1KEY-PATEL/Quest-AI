import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:questias/pages/model/openAIChatModel.dart';

class BackendService {
  Future<String> getOpenAIResponse(
      {required List<OpenAIChatModel> messages}) async {
    final String backendUrl = "https://quest-ias-backend.onrender.com";

    // Convert messages to JSON map
    final List<Map<String, String>> messageMaps =
        messages.map((message) => message.toJson()).toList();

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/ask'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "messages": messageMaps,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['response'];
      } else {
        print('Error: ${response.statusCode} ${response.reasonPhrase}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load response');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load response');
    }
  }
}
