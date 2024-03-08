import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/habit.dart';
import './icons.dart';

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
      _selectedPriority = widget.initialHabit?.priority ?? Priority.none;
      _frequencyCount = widget.initialHabit?.frequencyCount ?? 1;
      _selectedFrequencyPeriod =
          widget.initialHabit?.frequencyPeriod ?? FrequencyPeriod.daily;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Priority? _selectedPriority;
  int _frequencyCount = 1; // Default frequency count
  FrequencyPeriod _selectedFrequencyPeriod = FrequencyPeriod.daily;
  /*
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
  */

  void _submitForm() {
    Habit habit;

    if (widget.initialHabit != null) {
      // We are in edit mode
      habit = widget.initialHabit!.copyWith(
          name: nameController.text,
          description: descriptionController.text,
          priority: _selectedPriority,
          frequencyCount: _frequencyCount,
          frequencyPeriod: _selectedFrequencyPeriod);
    } else {
      // We are in create mode
      habit = Habit(
          name: nameController.text,
          description: descriptionController.text,
          priority: _selectedPriority ?? Priority.none,
          frequencyCount: _frequencyCount,
          frequencyPeriod: _selectedFrequencyPeriod);
    }

    widget.onFormSubmit(habit);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(children: [
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
          ExpansionTile(title: const Text("Advanced"), children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(8.0), // Adjust padding as needed
                child: Text(
                  'Priority', // Your title
                ),
              ),
              Row(
                children: Priority.values.map((priority) {
                  final priorityLabel = priorityToString(priority);
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Tooltip(
                        message: priorityLabel,
                        child: ChoiceChip(
                            label: Icon(
                              priorityIcons[priority],
                              color: _selectedPriority == priority
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).iconTheme.color,
                            ),
                            selected: _selectedPriority == priority,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedPriority = priority;
                              });
                            },
                            backgroundColor:
                                Theme.of(context).chipTheme.backgroundColor,
                            selectedColor:
                                Theme.of(context).colorScheme.primary,
                            showCheckmark: false)),
                  ));
                }).toList(),
              ),
            ]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.all(8.0), // Adjust padding as needed
                  child: Text(
                    'Frequency builder', // Your title
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Frequency Count: $_frequencyCount"),
                      Slider(
                        min: 1,
                        max: 10, // Adjust based on your requirements
                        divisions: 9,
                        value: _frequencyCount.toDouble(),
                        label: '$_frequencyCount',
                        onChanged: (double value) {
                          setState(() {
                            _frequencyCount = value.round();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  children: FrequencyPeriod.values.map((frequencyPeriod) {
                    final frequencyLabel =
                        frequencyPeriodToString(frequencyPeriod);
                    return ChoiceChip(
                      label: Text(frequencyLabel),
                      selected: _selectedFrequencyPeriod == frequencyPeriod,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedFrequencyPeriod = frequencyPeriod;
                        });
                      },
                      backgroundColor:
                          Theme.of(context).chipTheme.backgroundColor,
                      selectedColor: Theme.of(context).colorScheme.primary,
                    );
                  }).toList(),
                )
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.initialHabit == null
                  ? "Create habit"
                  : "Update habit"),
            ),
          ])
        ]));
  }
}
