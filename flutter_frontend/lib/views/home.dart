import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/views/list_habits.dart';
import 'package:flutter_frontend/views/login_page.dart';
import 'package:flutter_frontend/views/intro_screen.dart';
import 'package:flutter_frontend/providers/auth_provider.dart';

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
            appBar: AppBar(title: const Text("Welcome")),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text('Login'),
              ),
            ),
          );
        }
      },
    );
  }
}
