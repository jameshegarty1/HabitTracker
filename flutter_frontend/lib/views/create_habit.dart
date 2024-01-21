import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/providers/habit_provider.dart';
import 'package:flutter_frontend/widgets/habit_form_widget.dart';
import 'package:flutter_frontend/models/habit.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create")),
      body: HabitFormWidget(
        onFormSubmit: (Habit habit) async {
          await Provider.of<HabitProvider>(context, listen: false).createHabit(habit);
          Navigator.pop(context, true);
        },
      ),
    );
  }
}
