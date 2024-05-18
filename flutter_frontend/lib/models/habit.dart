// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/utils/utils.dart';

import 'habit_execution.dart';

enum FrequencyPeriod { hourly, daily, weekly, monthly, yearly }

enum Priority { none, low, medium, high, critical }

Priority stringToPriority(String priorityString) {
  switch (priorityString) {
    case 'none':
      return Priority.none;
    case 'critical':
      return Priority.critical;
    case 'high':
      return Priority.high;
    case 'medium':
      return Priority.medium;
    case 'low':
      return Priority.low;
    default:
      throw ArgumentError('Unknown priority string: $priorityString');
  }
}

String priorityToString(Priority priority) {
  return priority.toString().split('.').last;
}

String frequencyPeriodToString(FrequencyPeriod period) {
  switch (period) {
    case FrequencyPeriod.hourly:
      return 'Hourly';
    case FrequencyPeriod.daily:
      return 'Daily';
    case FrequencyPeriod.weekly:
      return 'Weekly';
    case FrequencyPeriod.monthly:
      return 'Monthly';
    case FrequencyPeriod.yearly:
      return 'Yearly';
    default:
      return '';
  }
}

FrequencyPeriod stringToFrequencyPeriod(String periodString) {
  return FrequencyPeriod.values.firstWhere(
    (period) =>
        frequencyPeriodToString(period).toLowerCase() ==
        periodString.toLowerCase(),
    orElse: () => FrequencyPeriod.daily,
  );
}

String formatFrequency(int count, FrequencyPeriod period) {
  String periodString = frequencyPeriodToString(period)
      .toLowerCase(); // Convert the period to a string
  return "${count}x $periodString"; // Combine count and period into a single string
}

class Habit {
  int? id;
  int? parentHabitId;
  String name;
  String? description;
  int executionQuantity;
  TimeOfDay? notificationTime;
  Priority priority;
  List<String>? tags;
  DateTime? updated;
  DateTime? created;
  int frequencyCount;
  FrequencyPeriod frequencyPeriod;
  int periodQuantity;

  Habit(
      {this.id,
      required this.name,
      this.parentHabitId,
      this.description,
      this.executionQuantity = 0,
      this.notificationTime,
      this.priority = Priority.none,
      this.tags,
      this.updated,
      this.created,
      this.frequencyCount = 1,
      this.frequencyPeriod = FrequencyPeriod.daily, //Default is 1 time per day
      this.periodQuantity = 0});

  HabitExecution newExecution() {
    if (id == null) {
      throw Exception('Cannot execute a habit without an ID');
    }

    // Create an execution instance
    HabitExecution execution = HabitExecution(
      habitId: id!,
      note: "test",
    );

    return execution;
  }

  Habit copyWith(
      {int? id,
      int? parentHabitId,
      String? name,
      String? description,
      int? executionQuantity,
      TimeOfDay? notificationTime,
      Priority? priority,
      List<String>? tags,
      DateTime? updated,
      DateTime? created,
      int? frequencyCount,
      FrequencyPeriod? frequencyPeriod,
      int? periodQuantity}) {
    return Habit(
      id: id ?? this.id,
      parentHabitId: parentHabitId ?? this.parentHabitId,
      name: name ?? this.name,
      description: description ?? this.description,
      executionQuantity: executionQuantity ?? this.executionQuantity,
      notificationTime: notificationTime ?? this.notificationTime,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      updated: updated ?? this.updated,
      created: created ?? this.created,
      frequencyCount: frequencyCount ?? this.frequencyCount,
      frequencyPeriod: frequencyPeriod ?? this.frequencyPeriod,
      periodQuantity: periodQuantity ?? this.periodQuantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'parent_habit': parentHabitId,
      'name': name,
      'description': description,
      'execution_quantity': executionQuantity,
      'notification_time': timeOfDayToString(notificationTime),
      'priority': priority.name, //priorityToString(priority),
      'tags': tags,
      'updated': updated?.toIso8601String(),
      'created': created?.toIso8601String(),
      'frequency_count': frequencyCount,
      'frequency_period': frequencyPeriodToString(frequencyPeriod),
      'period_quantity': periodQuantity,
    };
  }

  factory Habit.newHabit(
      {required String name,
      int? parentHabitId,
      String? description,
      int? executionQuantity,
      TimeOfDay? notificationTime,
      Priority priority = Priority.none,
      List<String>? tags,
      int frequencyCount = 1,
      FrequencyPeriod frequencyPeriod = FrequencyPeriod.daily,
      int periodQuantity = 0}) {
    return Habit(
        id: null,
        name: name,
        parentHabitId: parentHabitId,
        description: description,
        executionQuantity: executionQuantity ?? 0,
        notificationTime: notificationTime,
        priority: priority,
        tags: tags,
        updated: null,
        created: null,
        frequencyCount: frequencyCount,
        frequencyPeriod: frequencyPeriod,
        periodQuantity: periodQuantity
        );
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    // TODO: Convert string to enum and handle TimeOfDay
    return Habit(
        id: map['id'] as int,
        name: map['name'] as String,
        description: map['description'] as String?,
        executionQuantity: map['execution_quantity'] as int,
        notificationTime: map['notification_time'] != null
            ? stringToTimeOfDay(map['notification_time'] as String)
            : null,
        priority: stringToPriority(map['priority']),
        tags: map['tags'] != null ? List<String>.from(map['tags'] as List) : [],
        updated: map['updated'] != null ? DateTime.parse(map['updated']) : null,
        created: map['created'] != null ? DateTime.parse(map['created']) : null,
        parentHabitId: map['parent_habit'] as int?,
        frequencyCount: map['frequency_count'] as int,
        frequencyPeriod: stringToFrequencyPeriod(
            map['frequencyPeriod'] as String? ?? 'daily'),
        periodQuantity: map['period_quantity']
        );

  }

  String toJson() => json.encode(toMap());

  factory Habit.fromJson(String source) =>
      Habit.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Habit('
        'id: $id, '
        'parentHabitId: $parentHabitId, '
        'name: "$name", '
        'description: "${description ?? 'null'}", '
        'executionQuantity: ${executionQuantity.toString()}, '
        //'notificationTime: "${notificationTime?.format(context) ?? 'null'}", '
        'priority: ${priorityToString(priority)}, '
        //'tags: ${tags != null ? tags.join(', ') : 'null'}, '
        'updated: "${updated?.toIso8601String() ?? 'null'}", '
        'created: "${created?.toIso8601String() ?? 'null'}"), '
        'frequency count: "$frequencyCount", '
        'frequency period: "$frequencyPeriodToString(frequencyPeriod)"'
        'period quantity: $periodQuantity';
  }
}
