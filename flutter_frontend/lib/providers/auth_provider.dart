import 'package:flutter/material.dart';
import '../main.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService authService;
  String? _token;

  AuthProvider(this.authService);

  bool get isAuthenticated => _token != null;

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
  }

  // Add other authentication related methods here
}
