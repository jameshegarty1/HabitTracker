import 'dart:convert';
import 'package:flutter_frontend/utils/urls.dart';
import 'package:http/http.dart';
import 'package:flutter_frontend/main.dart';

class AuthService {
  final Client client;

  AuthService({required this.client});

  Future<void> login(String username, String password) async {
    logger.d('Attempting to login user: $username');

    final response = await client.post(
      loginUrl(),
      headers: {
          'Content-Type': 'application/json'
      },
      body: jsonEncode({'username': username, 'password': password}),
    );

    logger.d('Response for login: Status code ${response.statusCode}, Body: ${response.body}');

    if (response.statusCode == 200) {
      logger.i('Login successful');
      // Handle login success, like storing the token
    } else {
      logger.e('Failed to login. Status code: ${response.statusCode}');
    }
  }

  Future<void> signup(String username, String password, String email) async {
    logger.d('Attempting to signup user: $username');

    final response = await client.post(
      signupUrl(), // Replace with your signup API endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password, 'email': email}),
    );

    logger.d('Response for signup: Status code ${response.statusCode}, Body: ${response.body}');

    if (response.statusCode == 200) {
      logger.i('Signup successful');
      // Handle signup success
    } else {
      logger.e('Failed to signup. Status code: ${response.statusCode}');
    }
  }

  Future<void> testToken(String token) async {
    logger.d('Testing token');

    final response = await client.get(
      testTokenUrl(), // Replace with your test token API endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token', // Adjust header according to your API's requirements
      },
    );

    logger.d('Response for token test: Status code ${response.statusCode}, Body: ${response.body}');

    if (response.statusCode == 200) {
      logger.i('Token is valid');
      // Handle valid token
    } else {
      logger.e('Token test failed. Status code: ${response.statusCode}');
    }
  }

  // Add any other authentication related methods here
}

