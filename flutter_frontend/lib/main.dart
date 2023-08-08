import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/update.dart';
import 'package:flutter_frontend/create.dart';
import 'package:flutter_frontend/urls.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_frontend/habit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Habit Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Client client = http.Client();
  List<Habit> habits = [];

  @override
  void initState() {
    _retrieveHabits();
    super.initState();
  }

  Future<void> _deleteHabit(int id) async {
    var deleteUrl = Uri.parse('$baseUrl/habits/$id/delete/');

    final response = await client.delete(deleteUrl);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete habit');
    }
  }

  _retrieveHabits() async {
    habits = [];

    List response = json.decode((await client.get(retrieveUrl)).body);

    response.forEach((element) {
      habits.add(Habit.fromMap(element));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _retrieveHabits();
        },
        child: ListView.builder(
          itemCount: habits.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(habits[index].habit),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => UpdatePage(
                            client: client,
                            id: habits[index].id,
                            habit: habits[index].habit,
                          )),
                );
              },
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteHabit(habits[index].id),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => CreatePage(
                    client: client,
                  )),
        ),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
