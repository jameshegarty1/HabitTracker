import 'package:flutter/material.dart';
import 'package:flutter_frontend/widgets/login_signup_btn.dart'; // Update this import path to where your LoginAndSignupBtn widget is located

class AuthOptionScreen extends StatelessWidget {
  const AuthOptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Welcome',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
                height:
                    50), // Adjust the space between the text and the buttons as needed
            LoginAndSignupBtn(), // Your custom Login/Signup button widget
          ],
        ),
      ),
    );
  }
}
