import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_frontend/main.dart';
import 'package:flutter_frontend/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService authService;
  String? _token;
  bool _hasSeenIntro = false;

  AuthProvider(this.authService) {
    _loadIntroStatus();
  }

  bool get isAuthenticated => _token != null;
  bool get hasSeenIntro => _hasSeenIntro;

  Future<void> _loadIntroStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
  }

  Future<void> setIntroSeen() async {
    _hasSeenIntro = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);
    debugPrint("AuthProvider: Introduction has been set as seen.");
  }

  Future<void> login(String username, String password) async {
    try {
      await authService.login(username, password);
      notifyListeners();
    } catch (e) {
      logger.e('error: $e');
    }
  }

  void logout() {
    _token = null;
    notifyListeners();
    // Remove token from storage
    debugPrint("AuthProvider: User logged out.");
  }

  // Add other authentication related methods here
}
