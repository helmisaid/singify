import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class RegisterService extends AuthService {
  // Singleton pattern
  static final RegisterService _instance = RegisterService._internal();
  
  factory RegisterService() {
    return _instance;
  }
  
  RegisterService._internal();
  
  // Register a new user
  Future<Map<String, dynamic>> register(
      String email, String password, String fullName) async {
    try {
      print('Attempting to register user: $email');
      
      final url = Uri.parse('${baseUrl}/api/collections/users/records');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'passwordConfirm': password,
          'name': fullName,
        }),
      );

      print('Register response status: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Registration successful');
        return responseData;
      } else {
        print('Registration failed: ${response.body}');
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      print('Exception during registration: $e');
      rethrow;
    }
  }
  
  // Verify email (for future implementation)
  Future<bool> verifyEmail(String token) async {
    // Implementation for email verification
    throw UnimplementedError('Email verification not implemented yet');
  }
}
