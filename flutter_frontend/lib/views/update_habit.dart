import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/models/habit.dart';
import 'package:flutter_frontend/providers/habit_provider.dart';
import 'package:flutter_frontend/widgets/habit_form_widget.dart';

class UpdatePage extends StatelessWidget {
  final Habit habit;

  UpdatePage({
    required this.habit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Habit"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: HabitFormWidget(
            initialHabit: habit,
            onFormSubmit: (updatedHabit) async {
              try {
                await Provider.of<HabitProvider>(context, listen: false).updateHabit(updatedHabit);
                Navigator.of(context).pop(true); // Go back after updating
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Habit updated successfully!')),
                );
              } catch (e) {
                // Handle any errors, e.g., show a Snackbar
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating habit')),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
