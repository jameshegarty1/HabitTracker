import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/models/habit.dart';

class HabitFormWidget extends StatefulWidget {
  final Function(Habit) onFormSubmit;

  HabitFormWidget({required this.onFormSubmit});

  @override
  _HabitFormWidgetState createState() => _HabitFormWidgetState();
}

class _HabitFormWidgetState extends State<HabitFormWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  HabitType? _selectedHabitType;
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController goalQuantityController = TextEditingController();
  DateTime? _selectedEndDate;

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
    // Create Habit object from form data and use widget.onFormSubmit to pass it.
    Habit habit = Habit(
      name: nameController.text,
      description: descriptionController.text,
      habitType: _selectedHabitType,
      endDate: _selectedEndDate,
      goalQuantity: int.tryParse(goalQuantityController.text),
    );
    widget.onFormSubmit(habit);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
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
              child: Text(value == HabitType.infinite ? 'Infinite' : 'Finite'),
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
          child: Text("Create habit"),
        ),
      ],
    );
  }
}
