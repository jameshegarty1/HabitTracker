import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/habit.dart';
import 'package:flutter_frontend/services/habit_service.dart';
import 'package:flutter_frontend/utils/utils.dart';
import 'package:flutter_frontend/views/update_habit.dart';

import '../utils/dialog_utils.dart';

class HabitDetailView extends StatelessWidget {
  final Habit habit;
  final HabitService habitService; // <- Add this

  HabitDetailView({
    required this.habit,
    required this.habitService, // <- Add this
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(habit.name)),
      body: ListView(
        children: [
          _buildTile('Description', habit.description ?? 'No description'),
          _buildTile('Priority', priorityToString(habit.priority)),
          _buildTile('Habit Type', habit.habitType.toString().split('.').last),
          if (habit.goalQuantity != null)
            _buildTile('Goal Quantity', habit.goalQuantity.toString()),
          if (habit.endDate != null)
            _buildTile('End Date', formatDate(habit.endDate!)),
          _buildTile('Current Quantity', habit.currentQuantity.toString()),
          _actionButtons(context), // <- Updated this
        ],
      ),
    );
  }

  ListTile _buildTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return ListTile(
      title: Text('Actions'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              bool? result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UpdatePage(
                        habitService: habitService,
                        habit: habit,
                      )));
              if (result != null && result) {
                Navigator.of(context).pop(true);
              }
              ;
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool deleted =
                  await confirmDeletion(context, habit, habitService);
              if (deleted) {
                // Handle the post-deletion here, e.g., navigate back, show a snack bar, etc.
                Navigator.of(context).pop(true);
              }
              ;
            },
          )
        ],
      ),
    );
  }
}
