import 'dart:convert';
import 'package:flutter_frontend/main.dart';
import 'package:flutter_frontend/models/habit_execution.dart';
import 'package:http/http.dart';
import 'package:flutter_frontend/utils/urls.dart';
import 'package:flutter_frontend/models/habit.dart';

class HabitService {
  final Client client;

  HabitService({required this.client});

  Future<void> createHabit(Habit habit) async {
    final habitData = habit.toMap();
    logger.d('[HabitService] Creating habit with data: $habitData');

    final response = await client.post(
      createUrl(),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(habitData), // Convert habit to map then to JSON
    );

    if (response.statusCode == 200) {
      logger.i('[HabitService] Habit created successfully');
    } else {
      logger.e(
          '[HabitService] Failed to create habit. Status code: ${response.statusCode}');
    }
  }

  Future<List<Habit>> retrieveHabits() async {
    try {
      logger.d('[HabitService] Retrieving habits');

      // Log the URL being hit for debugging purposes
      final url = retrieveUrl();
      logger.d('[HabitService] Request URL: $url');

      final response = await client.get(url);

      // Log the full response for debugging
      logger.d('[HabitService] HTTP response status: ${response.statusCode}');
      //logger.d('[HabitService] HTTP response body: \n${response.body}');

      if (response.statusCode == 200) {
        // Attempt to parse the JSON, log if there's an error in parsing
        try {
          Iterable list = json.decode(response.body);
          List<Habit> habits =
              list.map((habit) => Habit.fromMap(habit)).toList();
          for (var habit in habits) {
            logger.d('[HabitService] Habit data: ${habit.toString()}');
          }
          return habits;
        } catch (e) {
          logger.e('[HabitService] Error parsing habits JSON: $e');
          throw Exception('[HabitService] Error parsing habits JSON');
        }
      } else {
        logger.e(
            '[HabitService] Failed to retrieve habits. Status code: ${response.statusCode}');
        throw Exception(
            '[HabitService] Failed to retrieve habits. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log any general errors in the function
      logger.e('[HabitService] Error retrieving habits: $e');
      throw Exception('[HabitService] Error retrieving habits: $e');
    }
  }

  Future<List<int>> retrieveHabitPerformance() async {
    try {
      logger.d('[HabitService] Retrieving habit performance');

      // Log the URL being hit for debugging purposes
      final url = retrievePerformanceUrl();
      logger.d('[HabitService] Request URL: $url');

      final response = await client.get(url);

      logger.d('[HabitService] HTTP response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Attempt to parse the JSON, log if there's an error in parsing
        try {
          Iterable list = json.decode(response.body);
          for (var elemnt in list) {
            logger.d('[HabitService] Habit data: ${habit.toString()}');
          }
          return habits;
        } catch (e) {
          logger.e('[HabitService] Error parsing habits JSON: $e');
          throw Exception('[HabitService] Error parsing habits JSON');
        }
      } else {
        logger.e(
            '[HabitService] Failed to retrieve habits. Status code: ${response.statusCode}');
        throw Exception(
            '[HabitService] Failed to retrieve habits. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log any general errors in the function
      logger.e('[HabitService] Error retrieving habits: $e');
      throw Exception('[HabitService] Error retrieving habits: $e');
    }
  }

  Future<void> updateHabit(Habit habit) async {
    logger.d('[HabitService] Updating habit with ID: ${habit.id}');
    final response = await client.put(
      updateUrl(
          habit.id!), // Assuming updateUrl takes habit's id as a parameter
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(habit.toMap()),
    );

    if (response.statusCode != 200) {
      logger.e(
          '[HabitService] Failed to update habit. Status code: ${response.statusCode}');
      throw Exception('Failed to update habit');
    }
  }

  Future<void> deleteHabit(int id) async {
    logger.d('[HabitService] Deleting habit with ID: $id');
    final response = await client.delete(deleteUrl(id));

    if (response.statusCode != 200) {
      logger.e(
          '[HabitService] Failed to delete habit. Status code: ${response.statusCode}');
      throw Exception('Failed to delete habit');
    }
  }

  Future<void> executeHabit(HabitExecution habitExecution) async {
    logger
        .d('[HabitService] Executing habit with ID: ${habitExecution.habitId}');
    final exec_response = await client.post(
      executeHabitUrl(), // Assuming updateUrl takes habit's id as a parameter
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(habitExecution.toMap()),
    );

    if (exec_response.statusCode == 201) {
      logger.i('[HabitService] Habit executed successfully');
    } else {
      logger.e(
          '[HabitService] Failed to execute habit. Status codes: ${exec_response.statusCode}');
      logger.d('Response body: ${exec_response.body}');
    }
  }
}
