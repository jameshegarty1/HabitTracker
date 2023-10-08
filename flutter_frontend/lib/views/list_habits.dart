import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/habit.dart';
import 'package:flutter_frontend/services/habit_service.dart';
import 'package:flutter_frontend/views/create_habit.dart';
import 'package:http/http.dart' as http;

import 'detail_habit.dart';

class HabitListView extends StatefulWidget {
  final http.Client client;
  const HabitListView({required this.client, Key? key}) : super(key: key);

  @override
  _HabitListViewState createState() => _HabitListViewState();
}

class _HabitListViewState extends State<HabitListView> {
  late HabitService habitService;
  List<Habit> habits = [];

  @override
  void initState() {
    super.initState();
    habitService = HabitService(client: widget.client);
    _refreshHabits();
  }

  Future<void> _refreshHabits() async {
    try {
      habits = await habitService.retrieveHabits();
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Habits")),
      body: RefreshIndicator(
        onRefresh: _refreshHabits,
        child: ListView.builder(
          itemCount: habits.length,
          itemBuilder: (context, index) {
            var habit = habits[index];
            return ExpansionTile(
              title: Text(habit.name),
              trailing: IconButton(
                icon: Icon(Icons.check),
                onPressed: () {/* handle habit completion */},
              ),
              children: [
                ListTile(
                  title: Text('Details, tap to view more'),
                  onTap: () async {
                    bool? refresh =
                        await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HabitDetailView(
                        habit: habit,
                        habitService: habitService,
                      ),
                    ));

                    if (refresh ?? false) {
                      _refreshHabits();
                    }
                  },
                )
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePage(habitService: habitService),
          ),
        ),
        tooltip: 'Add Habit',
        child: Icon(Icons.add),
      ),
    );
  }
}
