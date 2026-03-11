import 'package:flutter/material.dart';

/// A single recent-activity row entry.
class AdminActivityItem {
  final String name, action, time, initials;
  final Color  color;

  const AdminActivityItem({
    required this.name,
    required this.action,
    required this.time,
    required this.initials,
    required this.color,
  });
}
