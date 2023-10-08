import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/utils/utils.dart';

class HabitCompletion {
  final int id;
  final int habitId;
  final DateTime completionDate;
  final String notes;

  HabitCompletion({
    required this.id,
    required this.habitId,
    required this.completionDate,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'completionDate': completionDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory HabitCompletion.fromMap(Map<String, dynamic> map) {
    return HabitCompletion(
      id: map['id'] as int,
      habitId: map['habitId'] as int,
      completionDate: DateTime.parse(map['completionDate'] as String),
      notes: map['notes'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HabitCompletion.fromJson(String source) =>
      HabitCompletion.fromMap(json.decode(source) as Map<String, dynamic>);
}
