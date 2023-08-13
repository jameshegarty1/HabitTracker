import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/habit.dart';
import 'package:flutter_frontend/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_frontend/views/create.dart';
import 'package:flutter_frontend/views/update.dart';
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

  String formatDate(DateTime dateTime) {
    return DateFormat.yMMMMd('en_UK').format(dateTime);
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
        title: Text("Title"),
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
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => UpdatePage(
                                      client: widget.client,
                                      id: currentHabit.id,
                                      name: currentHabit.name,
                                    )),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          try {
                            await habitService.deleteHabit(currentHabit.id);
                            // Optionally: Refresh the habits list after deletion
                            _refreshHabits();
                          } catch (e) {
                            // Optionally: Show an error message to the user
                          }
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
