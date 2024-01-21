import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/views/list_habits.dart';
import 'package:flutter_frontend/providers/habit_provider.dart';
import 'package:flutter_frontend/services/habit_service.dart';
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
    initializeDateFormatting().then((_) => runApp(
                ChangeNotifierProvider(
                    create: (context) =>
                    HabitProvider(HabitService(client: http.Client())),
                    child: const MyApp(),
                    ),
                ));
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
                    ],
                    child: MaterialApp(
                        title: 'Habit Tracker',
                        theme: ThemeData(
                            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                            useMaterial3: true,
                            ),
                        home: const HabitListView(),
                        ),
                    );
        }
}
