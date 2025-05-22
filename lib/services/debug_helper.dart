import 'dart:convert';
import 'package:http/http.dart' as http;

class DebugHelper {
  static const String _baseUrl = 'http://127.0.0.1:8090';

  // Create a user directly using the admin API
  static Future<Map<String, dynamic>> createUserDirectly(
      String email, String password, String name) async {
    try {
      // First, try to create a user in the users collection
      final url = Uri.parse('$_baseUrl/api/collections/users/records');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'passwordConfirm': password,
          'name': name,
        }),
      );

      print(
          'Direct creation response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }

      // If that fails, try the auth collection
      final authUrl =
          Uri.parse('$_baseUrl/api/collections/_pb_users_auth_/records');

      final authResponse = await http.post(
        authUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'passwordConfirm': password,
          'name': name,
        }),
      );

      print(
          'Auth creation response: ${authResponse.statusCode} - ${authResponse.body}');

      if (authResponse.statusCode == 200 || authResponse.statusCode == 201) {
        return jsonDecode(authResponse.body);
      }

      throw Exception('Failed to create user directly: ${response.body}');
    } catch (e) {
      print('Exception in direct creation: $e');
      rethrow;
    }
  }

  // Check if a collection exists
  static Future<bool> collectionExists(String name) async {
    try {
      final url = Uri.parse('$_baseUrl/api/collections/$name');
      final response = await http.get(url);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Get collection schema
  static Future<Map<String, dynamic>?> getCollectionSchema(String name) async {
    try {
      final url = Uri.parse('$_baseUrl/api/collections/$name');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
