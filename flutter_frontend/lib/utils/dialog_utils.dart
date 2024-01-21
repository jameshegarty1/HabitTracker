import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/providers/habit_provider.dart';
import '../models/habit.dart';
import '../main.dart';

Future<bool> confirmDeletion(
    BuildContext context, Habit habit) async {
  bool? result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Do you really want to delete this habit?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );

  if (result ?? false) {
    // Proceed with deletion
    await Provider.of<HabitProvider>(context, listen: false).deleteHabit(habit.id!);
    return true;
  }
  return false;
}

Future<bool> confirmExecution(
    BuildContext context, Habit habit) async {
  try {
    var habitExecution = habit.newExecution();
    await Provider.of<HabitProvider>(context, listen: false).executeHabit(habitExecution);
    return true;
  } catch (e) {
    logger.e('Error executing the habit: $e');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while executing the habit.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return false;
  }
}
