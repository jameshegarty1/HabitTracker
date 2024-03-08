import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/habit.dart';

Map<Priority, IconData> priorityIcons = {
  Priority.none: Icons.remove_circle_outline, // Representing 'None' - no specific priority
  Priority.low: Icons.arrow_downward, // Lower priority, down arrow
  Priority.medium: Icons.remove, // Medium priority, a horizontal line
  Priority.high: Icons.arrow_upward, // Higher priority, up arrow
  Priority.critical: Icons.report_problem, // Critical priority, a warning symbol
};


