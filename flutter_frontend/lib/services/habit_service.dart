import 'dart:convert';
import 'package:flutter_frontend/models/habit_execution.dart';
import 'package:http/http.dart';
import 'package:flutter_frontend/utils/urls.dart';
import 'package:flutter_frontend/models/habit.dart';

class HabitService {
  final Client client;

  HabitService({required this.client});

  Future<void> createHabit(Habit habit) async {
    final response = await client.post(
      createUrl(),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(habit.toMap()), // Convert habit to map then to JSON
    );

    if (response.statusCode == 200) {
      print('Habit created successfully');
    } else {
      print('Failed to create habit. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<List<Habit>> retrieveHabits() async {
    final response = await client.get(retrieveUrl());

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((habit) => Habit.fromMap(habit)).toList();
    } else {
      print('Failed to retrieve habits. Status code: ${response.statusCode}');
      throw Exception('Failed to retrieve habits');
    }
  }

  Future<void> updateHabit(Habit habit) async {
    final response = await client.put(
      updateUrl(
          habit.id!), // Assuming updateUrl takes habit's id as a parameter
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(habit.toMap()),
    );

    if (response.statusCode != 200) {
      print('Failed to update habit. Status code: ${response.statusCode}');
      throw Exception('Failed to update habit');
    }
  }

  Future<void> deleteHabit(int id) async {
    final response = await client.delete(deleteUrl(id));

    if (response.statusCode != 200) {
      print('Failed to delete habit. Status code: ${response.statusCode}');
      throw Exception('Failed to delete habit');
    }
  }

  Future<void> executeHabit(HabitExecution execution, Habit habit) async {
    final exec_response = await client.post(
      executeHabitUrl(), // Assuming updateUrl takes habit's id as a parameter
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(execution.toMap()),
    );

    if (exec_response.statusCode == 201) {
      print('Habit executed successfully');
    } else {
      print(
          'Failed to execute habit. Status codes: ${exec_response.statusCode}');
      print('Response body: ${exec_response.body}');
    }
  }
}
