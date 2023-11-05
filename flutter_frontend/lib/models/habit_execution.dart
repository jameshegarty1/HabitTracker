import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/utils/utils.dart';

class HabitExecution {
  final int habitId;
  final String note;

  HabitExecution({
    required this.habitId,
    this.note = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'habitId': habitId,
      'note': note,
    };
  }

  factory HabitExecution.fromMap(Map<String, dynamic> map) {
    return HabitExecution(
      habitId: map['habitId'] as int,
      note: map['note'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HabitExecution.fromJson(String source) =>
      HabitExecution.fromMap(json.decode(source) as Map<String, dynamic>);
}
