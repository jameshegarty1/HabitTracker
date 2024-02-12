import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/views/ListView/list_habits.dart';
import 'package:flutter_frontend/providers/auth_provider.dart';
import 'package:flutter_frontend/views/Welcome/login_signup.dart';
import 'package:flutter_frontend/views/Welcome/intro_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Check if the introduction has been completed
        if (!authProvider.hasSeenIntro) {
          return IntroScreen();
        } else if (authProvider.isAuthenticated) {
          return const HabitListView();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text("Login"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LoginSignupScreen(),
                  ));
                },
                child: const Text('Login/Signup'),
              ),
            ),
          );
        }
      },
    );
  }
}
