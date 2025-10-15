import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Add this import
import 'package:localstorage/localstorage.dart';
import 'package:waiwan_senior/model/elderly_person.dart';
import 'package:waiwan_senior/utils/config.dart';
import 'package:waiwan_senior/utils/helper.dart';

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
  Future<ElderlyPerson> getProfile() async {
    final response = await http
        .get(Uri.parse('$baseUrl/me'), headers: headers)
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      return ElderlyPerson.fromJson(jsonDecode(response.body));
    } else {
      localStorage.clear();
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

  Future uploadProfileImage(File imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$API_URL/files/upload?is_profile_image=true'),
    );
    request.headers.addAll({
      'Authorization': 'Bearer $accessToken',
    });
    
    // Get the file extension to determine MIME type
    String fileName = imageFile.path.split('/').last;
    String? mimeType;
    
    if (fileName.toLowerCase().endsWith('.jpg') || fileName.toLowerCase().endsWith('.jpeg')) {
      mimeType = 'image/jpeg';
    } else if (fileName.toLowerCase().endsWith('.png')) {
      mimeType = 'image/png';
    } else if (fileName.toLowerCase().endsWith('.gif')) {
      mimeType = 'image/gif';
    } else if (fileName.toLowerCase().endsWith('.webp')) {
      mimeType = 'image/webp';
    }
    
    // Add the file with proper MIME type
    if (mimeType != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          await imageFile.readAsBytes(),
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      );
    } else {
      // Fallback to original method if MIME type can't be determined
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );
    }
    
    final response = await request.send().timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      final errorBody = await response.stream.bytesToString();
      throw streamErrorHandler(response, errorBody, 'uploadProfileImage');
    }
  }
}
