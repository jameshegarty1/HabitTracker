import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_frontend/main.dart';
import 'package:flutter_frontend/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService authService;
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
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('authToken');
    notifyListeners();
  }

  Future<void> setIntroSeen() async {
    _hasSeenIntro = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);
    debugPrint("AuthProvider: Introduction has been set as seen.");
  }

  Future<bool> login(String username, String password) async {
    try {
      String? token = await authService.login(username, password);
      if (token != null) {
        _token = token;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token); // Store the token
        notifyListeners();
        logger.i('AuthProvider: Login successful, token stored.');
        return true;
      }
      return false;
    } catch (e) {
      logger.e('AuthProvider login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken'); // Remove the token from storage
    notifyListeners();
    logger.i("AuthProvider: User logged out.");
  }

  Future<bool> signup(String username, String password, String email) async {
  try {
    bool signupSuccess = await authService.signup(username, password, email);
    if (signupSuccess) {
      // If signup was successful, attempt to log in
      bool loginSuccess = await login(username, password);
      return loginSuccess;
    }
    return false; // Return false if signup was not successful
  } catch (e) {
    logger.e('AuthProvider signup error: $e');
    return false; // Return false if an exception is caught
  }
}

  // Add other authentication related methods here
}
