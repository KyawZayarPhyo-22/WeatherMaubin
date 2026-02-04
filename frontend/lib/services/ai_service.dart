import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class AiService {
  final String baseUrl = "https://chatbot-z8ol.onrender.com/chat";

  Future<String> sendMessage(String message, List<ChatMessage> history) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "message": message,
        "history": history
            .map((m) => {"role": m.role, "text": m.text})
            .toList(),
      }),
    );

    if (response.statusCode != 200) {
      return "AI ဆာဗာမှာ ပြဿနာရှိနေပါတယ်";
    }

    final data = jsonDecode(response.body);
    return data["reply"];
  }
}
