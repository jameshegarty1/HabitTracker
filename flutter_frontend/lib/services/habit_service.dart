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
    logger.d('Creating habit with data: $habitData');

    final response = await client.post(
      createUrl(),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(habitData), // Convert habit to map then to JSON
    );


    if (response.statusCode == 200) {
      logger.i('Habit created successfully');
    } else {
      logger.e('Failed to create habit. Status code: ${response.statusCode}');
      logger.d('Response body: ${response.body}');
    }
  }

  Future<List<Habit>> retrieveHabits() async {
    logger.d('Retrieving habits');
    final response = await client.get(retrieveUrl());
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((habit) => Habit.fromMap(habit)).toList();
    } else {
      logger.e('Failed to retrieve habits. Status code: ${response.statusCode}');
      throw Exception('Failed to retrieve habits');
    }
  }

  Future<void> updateHabit(Habit habit) async {
    logger.d('Updating habit with ID: ${habit.id}');
    final response = await client.put(
      updateUrl(
          habit.id!), // Assuming updateUrl takes habit's id as a parameter
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(habit.toMap()),
    );

    if (response.statusCode != 200) {
      logger.e('Failed to update habit. Status code: ${response.statusCode}');
      throw Exception('Failed to update habit');
    }
  }

  Future<void> deleteHabit(int id) async {
    logger.d('Deleting habit with ID: $id');
    final response = await client.delete(deleteUrl(id));

    if (response.statusCode != 200) {
      logger.e('Failed to delete habit. Status code: ${response.statusCode}');
      throw Exception('Failed to delete habit');
    }
  }

  Future<void> executeHabit(HabitExecution habitExecution) async {
    logger.d('Executing habit with ID: ${habitExecution.habitId}');
    final exec_response = await client.post(
      executeHabitUrl(), // Assuming updateUrl takes habit's id as a parameter
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(habitExecution.toMap()),
    );

    if (exec_response.statusCode == 201) {
      logger.i('Habit executed successfully');
    } else {
      logger.e(
          'Failed to execute habit. Status codes: ${exec_response.statusCode}');
      logger.d('Response body: ${exec_response.body}');
    }
  }
}
