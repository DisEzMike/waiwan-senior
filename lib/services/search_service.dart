import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waiwan/model/elderly_person.dart';
import 'package:waiwan/utils/config.dart';
import 'package:waiwan/utils/helper.dart';

class SearchService {
  // Use your computer's IP address when running the FastAPI server
  static const String baseUrl = '$API_URL/search';

  // Alternative: Use localhost only when running on web or same device
  // static const String baseUrl = 'http://localhost:8001/auth';

  final String accessToken;

  SearchService({required this.accessToken});

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  // get senior nearby
  Future<List<ElderlyPerson>> searchNearby(double lat, double lon) async {
    final response = await http
        .get(
          Uri.parse('$baseUrl/nearby?lat=$lat&lng=$lon&range=10000'),
          headers: headers,
        )
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      final List<dynamic> jsonList = data['list'];
      return jsonList.map((json) => ElderlyPerson.fromJson(json)).toList();
    } else {
      throw errorHandler(response, 'searchNearby');
    }
  }

  // get senior by search query
  Future<List<ElderlyPerson>> searchByQuery(
    String query,
    double lat,
    double lng,
  ) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$query&lat=$lat&lng=$lng'), headers: headers)
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      final List<dynamic> jsonList = data['list'];
      return jsonList.map((json) => ElderlyPerson.fromJson(json)).toList();
    } else {
      throw errorHandler(response, 'searchByQuery');
    }
  }
}
