import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/habit_service.dart';
import '../models/habit.dart';

Future<bool> confirmDeletion(
    BuildContext context, Habit habit, HabitService habitService) async {
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
    await habitService.deleteHabit(habit.id!);
    return true;
  }
  return false;
}
