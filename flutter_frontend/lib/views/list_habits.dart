import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/habit.dart';
import 'package:flutter_frontend/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_frontend/views/create_habit.dart';
import 'package:flutter_frontend/views/update_habit.dart';
import 'package:flutter_frontend/services/habit_service.dart';

class HabitListView extends StatefulWidget {
  final http.Client client;
  const HabitListView({required this.client, Key? key}) : super(key: key);

  @override
  _HabitListViewState createState() => _HabitListViewState();
}

class _HabitListViewState extends State<HabitListView> {
  late HabitService habitService;
  List<Habit> habits = [];

  Future<void> _refreshHabits() async {
    try {
      List<Habit> fetchedHabits = await habitService.retrieveHabits();
      setState(() {
        habits = fetchedHabits;
      });
    } catch (e) {
      print('Failed to retrieve habits: $e');
      // Optionally, show a snackbar or alert dialog to inform the user
    }
  }

  Future<void> _confirmDeletion(Habit habit) async {
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
              onPressed: () {
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
      _refreshHabits();
    }
  }

  @override
  void initState() {
    super.initState();
    habitService = HabitService(client: widget.client);
    _refreshHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Habits"),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshHabits,
        child: ListView.builder(
          itemCount: habits.length,
          itemBuilder: (BuildContext context, int index) {
            Habit currentHabit = habits[index];
            return ExpansionTile(
              title: Text(currentHabit.name),
              children: [
                ListTile(
                  title: Text("Description"),
                  subtitle: Text(currentHabit.description ?? "No description"),
                ),
                ListTile(
                  title: Text("Habit Type"),
                  subtitle:
                      Text(currentHabit.habitType.toString().split('.').last),
                ),
                if (currentHabit.goalQuantity != null)
                  ListTile(
                    title: Text("Goal Quantity"),
                    subtitle: Text(currentHabit.goalQuantity.toString()),
                  ),
                if (currentHabit.endDate != null)
                  ListTile(
                    title: Text("End Date"),
                    subtitle: Text(currentHabit.endDate != null
                        ? formatDate(currentHabit.endDate!)
                        : 'No End Date'),
                  ),
                ListTile(
                  title: Text("Current Quantity"),
                  subtitle: Text(currentHabit.currentQuantity.toString()),
                ),
                // Add other properties here in the same format as above...
                ListTile(
                  title: Text("Actions"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          bool? result = await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => UpdatePage(
                                        habitService: habitService,
                                        habit: currentHabit,
                                      )));
                          if (result != null && result) {
                            _refreshHabits();
                          }
                          ;
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _confirmDeletion(currentHabit);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => CreatePage(
                    habitService: habitService,
                  )),
        ),
        tooltip: 'Add Habit',
        child: const Icon(Icons.add),
      ),
    );
  }
}
