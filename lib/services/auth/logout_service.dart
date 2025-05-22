import 'auth_service.dart';

class LogoutService extends AuthService {
  // Singleton pattern
  static final LogoutService _instance = LogoutService._internal();

  factory LogoutService() {
    return _instance;
  }

  LogoutService._internal();

  // Logout function
  // Mengembalikan true jika berhasil, false jika gagal
  Future<bool> logout() async {
    try {
      final success = await clearAuthData();
      print('Logout successful: $success');
      return success;
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }
}
