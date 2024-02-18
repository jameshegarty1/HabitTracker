import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/providers/habit_provider.dart';
import 'package:flutter_frontend/providers/auth_provider.dart';
import 'package:flutter_frontend/views/ListView/create_habit.dart';
import 'package:flutter_frontend/utils/dialog_utils.dart';
import 'package:flutter_frontend/main.dart';
import 'detail_habit.dart';

class HabitListView extends StatelessWidget {
  const HabitListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('Building HabitListView');

    return Scaffold(
      appBar: AppBar(
          title: Text("My Habits"),
          actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () async {
                      logger.i('[HabitListView] USER_ACTION: Clicked Logout');
                      await Provider.of<AuthProvider>(context, listen: false).logout();
                      Navigator.of(context).pushReplacementNamed('/authOptionScreen');
                  }
            )
          ],
          ),
      body: RefreshIndicator(
        onRefresh: () {
          logger.d('Refreshing habits...');
          return context.read<HabitProvider>().fetchHabits();
        },
        child: Consumer<HabitProvider>(
          builder: (context, habitProvider, child) {
            logger.d('Number of habits: ${habitProvider.habits.length}');
            return ListView.builder(
              itemCount: habitProvider.habits.length,
              itemBuilder: (context, index) {
                var habit = habitProvider.habits[index];
                logger.d('Building item $index: ${habit.toString()}');
                return ExpansionTile(
                  title: Text(habit.name),
                  trailing: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () async {
                      logger.d('Executing habit with ID: ${habit.id}');
                      bool? executed = await confirmExecution(context, habit);
                      if (executed) {
                        logger.d('Habit executed. Refreshing habits');
                        habitProvider.fetchHabits();
                      }
                    },
                  ),
                  children: [
                    ListTile(
                      title: Text('Details, tap to view more'),
                      onTap: () async {
                        logger.d(
                            'Navigating to details of habit ID: ${habit.id}');
                        bool? refresh =
                            await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HabitDetailView(habit: habit),
                        ));

                        if (refresh ?? false) {
                          logger.d('Returning from details. Refreshing habits');
                          habitProvider.fetchHabits();
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          logger.d('Navigating to Create Habit Page');
          bool? refresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePage()),
          );

          if (refresh ?? false) {
            logger.d('Returning from Create Habit Page. Refreshing habits');
            context.read<HabitProvider>().fetchHabits();
          }
        },
        tooltip: 'Add Habit',
        child: Icon(Icons.add),
      ),
    );
  }
}
