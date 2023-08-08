import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/urls.dart';

class UpdatePage extends StatefulWidget {
  final Client client;
  final int id;
  final String habit;

  const UpdatePage(
      {Key? key, required this.client, required this.id, required this.habit})
      : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  TextEditingController controller = TextEditingController();

  Future<void> updateHabit(int id, String bodyText) async {
    final String endpoint =
        '$baseUrl/habits/$id/update/'; // replace ID with the actual ID if needed

    final response = await widget.client.put(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'body': bodyText,
      }),
    );

    if (response.statusCode == 200) {
      print('Habit Updated successfully');
    } else {
      print('Failed to Update habit. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  initState() {
    controller.text = widget.habit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Update"),
        ),
        body: Column(
          children: [
            TextField(
              controller: controller,
              maxLines: 10,
            ),
            ElevatedButton(
              onPressed: () {
                updateHabit(widget.id, controller.text);
                Navigator.pop(context);
              },
              child: Text("Update habit"),
            )
          ],
        ));
  }
}
