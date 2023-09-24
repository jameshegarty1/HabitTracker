// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/utils/utils.dart';

enum HabitType { infinite, finite }

HabitType stringToHabitType(String habitTypeString) {
  switch (habitTypeString) {
    case 'infinite':
      return HabitType.infinite;
    case 'finite':
      return HabitType.finite;
    default:
      throw ArgumentError('Unknown habit type string: $habitTypeString');
  }
}

class Habit {
  int? id;
  int? parentHabitId;
  String name;
  String? description;
  HabitType habitType;
  int? goalQuantity;
  int? currentQuantity;
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay?
      notificationTime; // You'll need to import 'package:flutter/material.dart'
  List<String>?
      tags; // Assuming Tag model is just a list of tag names. If not, adjust accordingly.
  DateTime? updated;
  DateTime? created;

  Habit({
    this.id,
    required this.name,
    this.parentHabitId,
    this.description,
    this.habitType = HabitType.infinite,
    this.goalQuantity,
    this.currentQuantity = 0,
    this.startDate,
    this.endDate,
    this.notificationTime,
    this.tags,
    this.updated,
    this.created,
  });

  Habit copyWith({
    int? id,
    int? parentHabitId,
    String? name,
    String? description,
    HabitType? habitType,
    int? goalQuantity,
    int? currentQuantity,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? notificationTime,
    List<String>? tags,
    DateTime? updated,
    DateTime? created,
  }) {
    return Habit(
      id: id ?? this.id,
      parentHabitId: parentHabitId ?? this.parentHabitId,
      name: name ?? this.name,
      description: description ?? this.description,
      habitType: habitType ?? this.habitType,
      goalQuantity: goalQuantity ?? this.goalQuantity,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notificationTime: notificationTime ?? this.notificationTime,
      tags: tags ?? this.tags,
      updated: updated ?? this.updated,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'parent_habit': parentHabitId,
      'name': name,
      'description': description,
      'habit_type': habitType.toString().split('.').last,
      'goal_quantity': goalQuantity,
      'current_quantity': currentQuantity,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      // Convert TimeOfDay to your desired format here
      'notification_time': timeOfDayToString(notificationTime),
      'tags': tags,
      'updated': updated?.toIso8601String(),
      'created': created?.toIso8601String(),
    };
  }

  factory Habit.newHabit({
    required String name,
    int? parentHabitId,
    String? description,
    HabitType habitType = HabitType.infinite,
    int? goalQuantity,
    int? currentQuantity,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? notificationTime,
    List<String>? tags,
  }) {
    return Habit(
      id: null,
      name: name,
      parentHabitId: parentHabitId,
      description: description,
      habitType: habitType,
      goalQuantity: goalQuantity,
      currentQuantity: currentQuantity ?? 0,
      startDate: startDate,
      endDate: endDate,
      notificationTime: notificationTime,
      tags: tags,
      updated: null,
      created: null,
    );
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    // TODO: Convert string to enum and handle TimeOfDay
    return Habit(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String?,
      habitType: stringToHabitType(map['habit_type'] as String),
      goalQuantity: map['goal_quantity'] as int?,
      currentQuantity: map['current_quantity'] as int,
      startDate:
          map['start_date'] == null ? null : DateTime.parse(map['start_date']),
      endDate: map['end_date'] == null ? null : DateTime.parse(map['end_date']),
      notificationTime: stringToTimeOfDay(map['notification_time']
          as String?), // assuming you have the stringToTimeOfDay function in the same file or it's imported
      tags: List<String>.from(map['tags'] as List),
      updated: DateTime.parse(map['updated'] as String),
      created: DateTime.parse(map['created'] as String),
      parentHabitId: map['parent_habit'] as int?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Habit.fromJson(String source) =>
      Habit.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Habit(id: $id, name: $name)';

  @override
  bool operator ==(covariant Habit other) {
    return other.id == id && other.name == name;
  }
}
