import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zitoun/prompts/prompt.dart';

Future<String> sendToLLM(message) async {

  const String apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  const String apiKey = '';

  //Date
  final DateTime now = DateTime.now();
  final String customTime = "${now.hour}:${now.minute}:${now.second}";

  final Map<String, String> headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  final Map<String, dynamic> body = {

    'model': 'openai/gpt-5.1-codex-mini',
    'messages': [
      {
        'role': 'user',
        'content': '$context #THE MESSAGE IS :$message #THE CURRENT TIME:$customTime'
      }
    ]
  };

  
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(body),
    );


    //print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final String reply = responseData['choices']?[0]?['message']?['content'] ?? 'No response text found.';
      return reply;
    } else {
      return 'Error';
    }

}

