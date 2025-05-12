import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2/wtms_api";

  static Future<bool> registerWorker(String fullName, String email, String password, String phone, String address) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register_worker.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "full_name": fullName,
        "email": email,
        "password": password,
        "phone": phone,
        "address": address,
      }),
    );

    final jsonResponse = json.decode(response.body);
    return jsonResponse['success'];
  }

  static Future<Map<String, dynamic>?> loginWorker(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login_worker.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final jsonResponse = json.decode(response.body);
    return jsonResponse['success'] ? jsonResponse : null;
  }
}
