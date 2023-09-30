import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/habit_service.dart';
import 'package:flutter_frontend/widgets/habit_form_widget.dart';

class CreatePage extends StatelessWidget {
  final HabitService habitService;

  CreatePage({required this.habitService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create")),
      body: HabitFormWidget(
        onFormSubmit: (habit) {
          habitService.createHabit(habit);
          Navigator.pop(context);
        },
      ),
    );
  }
}
