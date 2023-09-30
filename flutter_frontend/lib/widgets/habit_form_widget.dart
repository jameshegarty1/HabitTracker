import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/models/habit.dart';

class HabitFormWidget extends StatefulWidget {
  final Function(Habit) onFormSubmit;
  final Habit? initialHabit;

  HabitFormWidget({
    required this.onFormSubmit,
    this.initialHabit,
  });

  @override
  _HabitFormWidgetState createState() => _HabitFormWidgetState();
}

class _HabitFormWidgetState extends State<HabitFormWidget> {
  @override
  void initState() {
    super.initState();

    if (widget.initialHabit != null) {
      nameController.text = widget.initialHabit!.name;
      descriptionController.text = widget.initialHabit!.description ?? "";
      _selectedHabitType = widget.initialHabit!.habitType;
      _selectedEndDate = widget.initialHabit!.endDate;
      endDateController.text = _selectedEndDate == null
          ? ''
          : "${_selectedEndDate!.toLocal()}".split(' ')[0];
      goalQuantityController.text =
          widget.initialHabit!.goalQuantity?.toString() ?? '';
      _selectedPriority = widget.initialHabit?.priority ?? Priority.none;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    endDateController.dispose();
    goalQuantityController.dispose();
    super.dispose();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  HabitType? _selectedHabitType;
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController goalQuantityController = TextEditingController();
  DateTime? _selectedEndDate;
  Priority? _selectedPriority;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
        endDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _submitForm() {
    Habit habit;

    if (widget.initialHabit != null) {
      // We are in edit mode
      habit = widget.initialHabit!.copyWith(
        name: nameController.text,
        description: descriptionController.text,
        habitType: _selectedHabitType ?? HabitType.infinite,
        endDate: _selectedEndDate,
        goalQuantity: int.tryParse(goalQuantityController.text),
        priority: _selectedPriority,
      );
    } else {
      // We are in create mode
      habit = Habit(
        name: nameController.text,
        description: descriptionController.text,
        habitType: _selectedHabitType ?? HabitType.infinite,
        endDate: _selectedEndDate,
        goalQuantity: int.tryParse(goalQuantityController.text),
        priority: _selectedPriority ?? Priority.none,
      );
    }

    widget.onFormSubmit(habit);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
              ),
            ),
            DropdownButton<Priority>(
              value: _selectedPriority,
              hint: Text('Choose Priority'),
              onChanged: (Priority? newValue) {
                setState(() {
                  _selectedPriority = newValue;
                });
              },
              items: Priority.values
                  .map<DropdownMenuItem<Priority>>((Priority value) {
                return DropdownMenuItem<Priority>(
                  value: value,
                  child: Text(priorityToString(value)),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            DropdownButton<HabitType>(
              value: _selectedHabitType,
              hint: Text('Choose Habit Type'),
              onChanged: (HabitType? newValue) {
                setState(() {
                  _selectedHabitType = newValue;
                });
              },
              items: HabitType.values
                  .map<DropdownMenuItem<HabitType>>((HabitType value) {
                return DropdownMenuItem<HabitType>(
                  value: value,
                  child:
                      Text(value == HabitType.infinite ? 'Infinite' : 'Finite'),
                );
              }).toList(),
            ),
            if (_selectedHabitType == HabitType.finite) ...[
              TextField(
                controller: goalQuantityController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: "Goal Quantity",
                ),
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text(
                    "End Date: ${_selectedEndDate == null ? 'Not set' : endDateController.text}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 16.0),
            ],
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.initialHabit == null
                  ? "Create habit"
                  : "Update habit"),
            ),
          ],
        ));
  }
}
