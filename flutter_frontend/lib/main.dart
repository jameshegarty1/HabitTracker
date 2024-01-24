import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/views/home.dart';
import 'package:flutter_frontend/providers/habit_provider.dart';
import 'package:flutter_frontend/providers/auth_provider.dart';
import 'package:flutter_frontend/services/habit_service.dart';
import 'package:flutter_frontend/services/auth_service.dart';
import 'package:flutter_frontend/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';

// Global logger
var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ),
);

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              HabitProvider(HabitService(client: http.Client())),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(AuthService(client: http.Client())),
        ),
      ],
      child: MaterialApp(
        title: 'Habit Tracker',
        theme: ThemeData(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: Colors.white,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: Colors.white,
                backgroundColor: kPrimaryColor,
                shape: const StadiumBorder(),
                maximumSize: const Size(double.infinity, 56),
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: kPrimaryLightColor,
              iconColor: kPrimaryColor,
              prefixIconColor: kPrimaryColor,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide.none,
              ),
            )),
        home: const HomePage(),
      ),
    );
  }
}
