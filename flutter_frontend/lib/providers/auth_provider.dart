import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_frontend/main.dart';
import 'package:flutter_frontend/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService authService;
  final storage = FlutterSecureStorage();
  String? _token;
  bool _hasSeenIntro = false;

  AuthProvider(this.authService) {
    _loadToken();
    _loadIntroStatus();
  }

  bool get isAuthenticated => _token != null;
  bool get hasSeenIntro => _hasSeenIntro;

  Future<void> _loadIntroStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
  }

  Future<void> _loadToken() async {
    _token = await storage.read(key: 'authToken');
    notifyListeners();
  }

  Future<void> setIntroSeen() async {
    _hasSeenIntro = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);
    debugPrint("[AuthProvider] Introduction has been set as seen.");
  }

  Future<bool> login(String username, String password) async {
    try {
      var loginResponse = await authService.login(username, password);
      if (loginResponse != null){
        _token = loginResponse;
        await storage.write(key: 'authToken', value: _token);
        notifyListeners();
        logger.i('[AuthProvider] Login successful, token stored.');
        return true;
      }
      return false;
    } catch (e) {
      logger.e('[AuthProvider] login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    String? token = await storage.read(key: 'authToken');
    if (token != null) {
        await authService.logout(token); // Pass the token to AuthService
        await storage.delete(key: 'authToken'); // Clear the token from secure storage
        _token = null;
        notifyListeners();
        logger.i("[AuthProvider] User logged out.");
    }  }

  Future<Map<String, dynamic>> signup(String username, String password, String email) async {
  try {
    var result = await authService.signup(username, password, email);
    if (result['success']){
      bool loginSuccess = await login(username, password);
      if (loginSuccess) {
        return {'success': true, 'message': 'Signup and login successful'};
      } else {
        return {'success': false, 'message': 'Login failed after successful signup'};
      }
    } else {
      logger.e('AuthProvider signup error: ${result['message']}');
      return {'success': false, 'message': result['message']};
    }
  } catch (e) {
    logger.e('AuthProvider signup exception: $e');
    return {'success': false, 'message': 'An unexpected error occurred'};
  }
}
}
