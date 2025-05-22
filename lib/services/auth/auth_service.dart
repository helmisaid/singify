import 'dart:convert';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singify/utils/logger.dart';

abstract class AuthService {
  // Konfigurasi base URL (dapat diambil dari env atau konstanta)
  static const String _baseUrl = String.fromEnvironment(
    'POCKETBASE_URL',
    defaultValue: 'http://127.0.0.1:8090',
  );

  // Kunci untuk menyimpan data di SharedPreferences
  static const String _tokenKey = 'pocketbase_auth_token';
  static const String _userDataKey = 'pocketbase_user_data';

  // Instance PocketBase
  final PocketBase pb = PocketBase(_baseUrl);

  // Inisialisasi pb.authStore dengan token yang tersimpan
  AuthService() {
    _loadAuthData();
  }

  Future<void> _loadAuthData() async {
    try {
      final token = await getAuthToken();
      final userData = await getCurrentUser();
      if (token != null && userData != null) {
        // Pastikan userData adalah Map<String, dynamic>
        final recordMap = userData is Map<String, dynamic>
            ? userData
            : jsonDecode(jsonEncode(userData));
        final record = RecordModel.fromJson(recordMap);
        pb.authStore.save(token, record);
        print('Loaded auth data from SharedPreferences: token=$token');
      } else {
        print('No auth data found in SharedPreferences');
      }
    } catch (e) {
      print('Error loading auth data: $e');
    }
  }

  /// Mendapatkan base URL untuk PocketBase.
  String get baseUrl => _baseUrl;

  Future<bool> saveAuthData(Map<String, dynamic> authData) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (authData['token'] == null || authData['record'] == null) {
        throw Exception('Invalid auth data: token or record is missing');
      }

      await prefs.setString(_tokenKey, authData['token']);
      await prefs.setString(_userDataKey, jsonEncode(authData['record']));

      final recordMap = authData['record'] is Map<String, dynamic>
          ? authData['record']
          : jsonDecode(jsonEncode(authData['record']));
      final record = RecordModel.fromJson(recordMap);
      pb.authStore.save(authData['token'], record);

      AppLogger.info('Auth data saved: token=${authData['token']}');
      return true;
    } catch (e) {
      AppLogger.error('Error saving auth data: $e');
      return false;
    }
  }

  /// Mendapatkan token autentikasi saat ini dari SharedPreferences.
  /// Mengembalikan token sebagai String atau null jika tidak ada.
  Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Error getting auth token: $e');
      return null;
    }
  }

  /// Mendapatkan data pengguna saat ini dari SharedPreferences.
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userDataKey);
      return userData != null
          ? jsonDecode(userData) as Map<String, dynamic>
          : null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  /// Memeriksa apakah pengguna sedang login dan token valid.
  /// Mengembalikan true jika pengguna terautentikasi, false jika tidak.
  Future<bool> isLoggedIn() async {
    try {
      print('Checking isLoggedIn - authStore.isValid: ${pb.authStore.isValid}');
      if (pb.authStore.isValid) {
        try {
          await pb
              .collection('users')
              .authRefresh(); // Verifikasi token dengan server
          print('Token verified successfully');
          return true;
        } catch (e) {
          print('Token verification failed: $e');
          // Fallback: Cek token lokal jika authRefresh gagal
          final token = await getAuthToken();
          return token != null && token.isNotEmpty;
        }
      }
      return false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  /// Mengembalikan true jika berhasil, false jika gagal.
  Future<bool> clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.remove(_tokenKey),
        prefs.remove(_userDataKey),
      ]);

      pb.authStore.clear();

      print('Auth data cleared');
      return true;
    } catch (e) {
      print('Error clearing auth data: $e');
      return false;
    }
  }
}
