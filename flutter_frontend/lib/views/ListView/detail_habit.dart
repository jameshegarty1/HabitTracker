import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/models/habit.dart';
import 'package:flutter_frontend/providers/habit_provider.dart';
import 'package:flutter_frontend/utils/utils.dart';
import 'package:flutter_frontend/views/ListView/update_habit.dart';
import 'package:flutter_frontend/utils/dialog_utils.dart';

class HabitDetailView extends StatelessWidget {
  final Habit habit;

  HabitDetailView({
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(habit.name)),
      body: ListView(
        children: [
          _buildTile('Description', habit.description ?? 'No description'),
          _buildTile('Priority', priorityToString(habit.priority)),
          _buildTile('Execution Quantity', habit.executionQuantity.toString()),
          _buildTile('Frequency', formatFrequency(habit.frequencyCount, habit.frequencyPeriod)),

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
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);

    return ListTile(
      title: Text('Actions'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              bool? result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UpdatePage(habit: habit)
              ));

              if (result != null && result) {
                habitProvider.fetchHabits();                
              } 
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool deleted =
                  await confirmDeletion(context, habit);
              if (deleted) {
                // Handle the post-deletion here, e.g., navigate back, show a snack bar, etc.
                Navigator.of(context).pop(true);
              }
            },
          )
        ],
      ),
    );
  }
}
