import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/habit_execution.dart';
import '../main.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';

class HabitProvider with ChangeNotifier {
  final HabitService habitService;
  List<Habit> _habits = [];

  HabitProvider(this.habitService) {
    fetchHabits(); //Do this in the constructor so the homepage gets populated
  }

  List<Habit> get habits => _habits;

  Future<void> fetchHabits() async {
    try {
      _habits = await habitService.retrieveHabits();
      notifyListeners();
    } catch (e) {
      logger.e('error: $e');
    }
  }



  Future<void> createHabit(Habit habit) async {
    try {
      await habitService.createHabit(habit);
      await fetchHabits(); // refresh the list after creation
    } catch (e) {
      logger.e('error: $e');
      // handle creation errors
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      await habitService.updateHabit(habit);
      await fetchHabits(); // refresh the list after updating
    } catch (e) {
      logger.e('error: $e');
      // handle update errors
    }
  }

  Future<void> deleteHabit(int id) async {
    try {
      await habitService.deleteHabit(id);
      await fetchHabits(); // refresh the list after deletion
    } catch (e) {
      logger.e('error: $e');
      // handle deletion errors
    }
  }

  Future<void> executeHabit(HabitExecution habitExecution) async {
    try {
      await habitService.executeHabit(habitExecution);
      await fetchHabits(); // refresh the list after deletion
    } catch (e) {
      logger.e('error: $e');
    }
      
  }

}

