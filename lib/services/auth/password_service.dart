import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class PasswordService extends AuthService {
  // Singleton pattern
  static final PasswordService _instance = PasswordService._internal();
  
  factory PasswordService() {
    return _instance;
  }
  
  PasswordService._internal();
  
  // Request password reset
  Future<void> requestPasswordReset(String email) async {
    try {
      print('Requesting password reset for: $email');
      
      final url = Uri.parse('${baseUrl}/api/collections/users/request-password-reset');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      print('Password reset request status: ${response.statusCode}');
      
      if (response.statusCode != 204 && response.statusCode != 200) {
        print('Password reset request failed: ${response.body}');
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Password reset request failed');
      }
    } catch (e) {
      print('Exception during password reset request: $e');
      rethrow;
    }
  }
  
  // Confirm password reset
  Future<void> confirmPasswordReset(
      String token, String password, String passwordConfirm) async {
    try {
      print('Confirming password reset');
      
      final url = Uri.parse('${baseUrl}/api/collections/users/confirm-password-reset');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'password': password,
          'passwordConfirm': passwordConfirm,
        }),
      );

      print('Password reset confirmation status: ${response.statusCode}');
      
      if (response.statusCode != 204 && response.statusCode != 200) {
        print('Password reset confirmation failed: ${response.body}');
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Password reset confirmation failed');
      }
    } catch (e) {
      print('Exception during password reset confirmation: $e');
      rethrow;
    }
  }
  
  // Change password (when user is logged in)
  Future<void> changePassword(
      String oldPassword, String newPassword, String newPasswordConfirm) async {
    // Implementation for changing password
    throw UnimplementedError('Change password not implemented yet');
  }
}
