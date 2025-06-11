import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> getBotResponse(String message) async {
    final Uri apiUrl = Uri.parse(
        "https://myfirstapi.runasp.net/api/chat/send"); // هغير الرابط لماا يجهزوه

    try {
      final response = await http.post(
        apiUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": message}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data["reply"]; //  عرض رد الذكاء الاصطناعي
      } else {
        return " Server connection error!";
      }
    } catch (e) {
      return " Server connection error!";
    }
  }
}
