// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Habit {
  int id;
  String habit;
  Habit({
    required this.id,
    required this.habit,
  });

  Habit copyWith({
    int? id,
    String? habit,
  }) {
    return Habit(
      id: id ?? this.id,
      habit: habit ?? this.habit,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'body': habit,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      habit: map['body'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Habit.fromJson(String source) =>
      Habit.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Habit(id: $id, habit: $habit)';

  @override
  bool operator ==(covariant Habit other) {
    if (identical(this, other)) return true;

    return other.id == id && other.habit == habit;
  }

  @override
  int get hashCode => id.hashCode ^ habit.hashCode;
}
