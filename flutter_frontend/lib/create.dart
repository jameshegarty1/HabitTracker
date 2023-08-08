import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/urls.dart';

class CreatePage extends StatefulWidget {
  final Client client;
  const CreatePage({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController controller = TextEditingController();

  Future<void> createHabit(String bodyText) async {
    final String endpoint =
        '$baseUrl/habits/create/'; // replace ID with the actual ID if needed

    final response = await widget.client.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'body': bodyText,
      }),
    );

    if (response.statusCode == 200) {
      print('Habit created successfully');
    } else {
      print('Failed to create habit. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create"),
        ),
        body: Column(
          children: [
            TextField(
              controller: controller,
              maxLines: 10,
            ),
            ElevatedButton(
              onPressed: () {
                createHabit(controller.text);
                Navigator.pop(context);
              },
              child: Text("Create habit"),
            )
          ],
        ));
  }
}
