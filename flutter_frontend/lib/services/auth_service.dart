import 'dart:convert';
import 'package:flutter_frontend/utils/urls.dart';
import 'package:http/http.dart';
import 'package:flutter_frontend/main.dart';

class AuthService {
  final Client client;

  AuthService({required this.client});

  Future<String?> login(String username, String password) async {
    logger.d('[AuthService] Attempting to login user: $username');

    final response = await client.post(
      loginUrl(),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String? token = data['token'];
      logger.i('[AuthService] Login successful for user: $username');
      return token; // Return the token
    } else {
      logger.e(
          '[AuthService] Failed to login. Status code: ${response.statusCode} for user: $username');
      return null;
    }
  }

  Future<void> logout(String token) async {
    logger.d('[AuthService] Attempting to logout...');

    final response = await client.post(
      logoutUrl(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );
    if (response.statusCode == 200) {
      logger.i('[AuthService] Logout successful.');
    } else {
      logger.e(
          '[AuthService] Failed to logout. Status code: ${response.statusCode}');
    }
  }

  Future<bool> signup(String username, String password, String email) async {
    logger.d('Attempting to signup user: $username');

    final response = await client.post(
      signupUrl(), // Ensure Uri.parse is used with your URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'username': username, 'password': password, 'email': email}),
    );

    if (response.statusCode == 201) {
      logger.i('Signup successful');
      return true; // Return true if signup is successful
    } else {
      logger.e('Failed to signup. Status code: ${response.statusCode}');
      return false; // Return false if signup is not successful
    }
  }

  Future<void> testToken(String token) async {
    logger.d('Testing token');

    final response = await client.get(
      testTokenUrl(), // Replace with your test token API endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Token $token', // Adjust header according to your API's requirements
      },
    );
    if (response.statusCode == 200) {
      logger.i('Token is valid');
      // Handle valid token
    } else {
      logger.e('Token test failed. Status code: ${response.statusCode}');
    }
  }

  // Add any other authentication related methods here
}
