import 'login_service.dart';
import 'register_service.dart';
import 'logout_service.dart';
import 'password_service.dart';
import 'auth_service.dart';

class AuthRepository extends AuthService {
  final LoginService _loginService = LoginService();
  final RegisterService _registerService = RegisterService();
  final LogoutService _logoutService = LogoutService();
  final PasswordService _passwordService = PasswordService();

  static final AuthRepository _instance = AuthRepository._internal();

  factory AuthRepository() {
    return _instance;
  }

  AuthRepository._internal();

  Future<Map<String, dynamic>> login(String email, String password) {
    return _loginService.login(email, password);
  }

  Future<Map<String, dynamic>> register(
      String email, String password, String fullName) {
    return _registerService.register(email, password, fullName);
  }

  Future<void> logout() {
    return _logoutService.logout();
  }

  // Password methods
  Future<void> requestPasswordReset(String email) {
    return _passwordService.requestPasswordReset(email);
  }

  Future<void> confirmPasswordReset(
      String token, String password, String passwordConfirm) {
    return _passwordService.confirmPasswordReset(
        token, password, passwordConfirm);
  }

  // User methods
  @override
  Future<Map<String, dynamic>?> getCurrentUser() {
    return super.getCurrentUser();
  }

  @override
  Future<bool> isLoggedIn() {
    return super.isLoggedIn();
  }
}
