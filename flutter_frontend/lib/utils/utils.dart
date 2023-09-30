import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String? timeOfDayToString(TimeOfDay? tod) {
  if (tod == null) return null;
  final String hour = tod.hour.toString().padLeft(2, '0');
  final String minute = tod.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

TimeOfDay? stringToTimeOfDay(String? tod) {
  if (tod == null) return null;
  final List<String> parts = tod.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

String formatDate(DateTime dateTime) {
  return DateFormat.yMMMMd('en_UK').format(dateTime);
}

String? formatDateForAPI(DateTime? date) {
  if (date == null) {
    return null;
  }
  return DateFormat('yyyy-MM-dd').format(date);
}
