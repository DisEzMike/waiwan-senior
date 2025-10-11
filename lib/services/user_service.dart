import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:waiwan/utils/config.dart';
import 'package:waiwan/utils/service_helper.dart';

class UserService {
  // Use your computer's IP address when running the FastAPI server
  static const String baseUrl = '$API_URL/user';

  // Alternative: Use localhost only when running on web or same device
  // static const String baseUrl = 'http://localhost:8001/auth';

  final String accessToken = localStorage.getItem('token') ?? '';

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  // get user profile
  Future getProfile() async {
    final response = await http
        .get(Uri.parse('$baseUrl/me'), headers: headers)
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw errorHandler(response, 'getProfile');
    }
  }

  setOnline(double lat, double lng) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/set-online'),
          headers: headers,
          body: jsonEncode({'lat': lat, 'lng': lng}),
        )
        .timeout(const Duration(seconds: 5));
    if (response.statusCode != 204) {
      throw errorHandler(response, 'setOnline');
    }
  }

  Future getUserById(String userId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/$userId'), headers: headers)
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw errorHandler(response, 'getUserById');
    }
  }
}
