import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/habit.dart';
import 'package:flutter_frontend/widgets/habit_form_widget.dart';
import 'package:flutter_frontend/services/habit_service.dart';

class UpdatePage extends StatefulWidget {
  final HabitService habitService;
  final Habit habit;

  UpdatePage({
    required this.habitService,
    required this.habit,
    Key? key,
  }) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  @override
  void initState() {
    super.initState();
  }

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
            initialHabit: widget.habit,
            onFormSubmit: (updatedHabit) async {
              Habit habitToUpdate = updatedHabit.copyWith(id: widget.habit.id);
              // Handle the form submission
              try {
                await widget.habitService.updateHabit(habitToUpdate);
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
