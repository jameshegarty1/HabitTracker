// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/utils/utils.dart';

import 'habit_execution.dart';

enum HabitType { infinite, finite }

enum Priority { none, critical, high, medium, low }

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


String habitTypeToString(HabitType habitType) {
    return habitType.toString().split('.').last;
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
    Priority priority;
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
            this.priority = Priority.none,
            this.tags,
            this.updated,
            this.created,
            });

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
            Priority? priority,
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
                priority: priority ?? this.priority,
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
                    'habit_type': habitType.name,//habitTypeToString(habitType),
                    'goal_quantity': goalQuantity,
                    'current_quantity': currentQuantity,
                    'start_date': formatDateForAPI(startDate),
                    'end_date': formatDateForAPI(endDate),
                    'notification_time': timeOfDayToString(notificationTime),
                    'priority': priority.name,//priorityToString(priority),
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
            Priority priority = Priority.none,
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
                priority: priority,
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
                startDate: map['start_date'] != null ? DateTime.parse(map['start_date']) : null,                endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
                notificationTime: map['notification_time'] != null ? stringToTimeOfDay(map['notification_time'] as String) : null,
                priority: stringToPriority(map['priority']),
                tags: map['tags'] != null ? List<String>.from(map['tags'] as List) : [],
                updated: map['updated'] != null ? DateTime.parse(map['updated']) : null,
                created: map['created'] != null ? DateTime.parse(map['created']) : null,
                parentHabitId: map['parent_habit'] as int?,
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
                    'habitType: ${habitTypeToString(habitType)}, '
                    'goalQuantity: ${goalQuantity?.toString() ?? 'null'}, '
                    'currentQuantity: ${currentQuantity?.toString() ?? 'null'}, '
                    'startDate: "${startDate?.toIso8601String() ?? 'null'}", '
                    'endDate: "${endDate?.toIso8601String() ?? 'null'}", '
                    //'notificationTime: "${notificationTime?.format(context) ?? 'null'}", '
                    'priority: ${priorityToString(priority)}, '
                    //'tags: ${tags != null ? tags.join(', ') : 'null'}, '
                    'updated: "${updated?.toIso8601String() ?? 'null'}", '
                    'created: "${created?.toIso8601String() ?? 'null'}")';
        }
}
