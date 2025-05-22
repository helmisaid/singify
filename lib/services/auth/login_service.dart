import 'package:pocketbase/pocketbase.dart';
import 'package:singify/utils/logger.dart'; // Adjust path based on your project structure
import 'auth_service.dart';

class LoginService extends AuthService {
  static final LoginService _instance = LoginService._internal();

  factory LoginService() {
    return _instance;
  }

  LoginService._internal();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      AppLogger.info('Attempting login with email: $email');

      // Perform authentication with PocketBase
      final authData = await pb.collection('users').authWithPassword(email, password);

      AppLogger.info('Login successful: token=${authData.token}, userId=${authData.record.id}');

      // Save authentication data to authStore and SharedPreferences
      final saveSuccess = await saveAuthData({
        'token': authData.token,
        'record': authData.record.toJson(),
      });

      if (!saveSuccess) {
        throw Exception('Failed to save authentication data');
      }

      // Verify auth store state
      if (!pb.authStore.isValid) {
        throw Exception('Authentication store is invalid after login');
      }

      return {
        'success': true,
        'data': {
          'token': pb.authStore.token,
          'record': pb.authStore.model.toJson(),
        }
      };
    } catch (e) {
      AppLogger.error('Exception during login: $e');
      if (e is ClientException) {
        final errorMessage = e.response is Map ? e.response['message'] ?? 'Unknown error' : 'Unknown error';
        AppLogger.error('ClientException details: $errorMessage, Status: ${e.statusCode}, Response: ${e.response}');
        if (e.statusCode == 400) {
          throw Exception('Invalid email or password');
        }
      }
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      AppLogger.info('Attempting logout');
      pb.authStore.clear(); // Clear the auth store as per PocketBase documentation
      await clearAuthData(); // Clear SharedPreferences data
      AppLogger.info('Logout successful');
    } catch (e) {
      AppLogger.error('Exception during logout: $e');
      throw Exception('Logout failed: ${e.toString()}');
    }
  }
}