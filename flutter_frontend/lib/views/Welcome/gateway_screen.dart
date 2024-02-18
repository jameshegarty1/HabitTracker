import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/views/ListView/list_habits.dart';
import 'package:flutter_frontend/providers/auth_provider.dart';
import 'package:flutter_frontend/views/Welcome/auth_option_screen.dart';
import 'package:flutter_frontend/views/Welcome/intro_screen.dart';

class Gateway extends StatelessWidget {
  const Gateway({Key? key}) : super(key: key);

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
          return AuthOptionScreen();
        }
      },
    );
  }
}
