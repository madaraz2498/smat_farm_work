import 'package:flutter/material.dart';

/// Immutable data class that represents one entry in the Admin sidebar.
/// Contains NO business logic or UI — pure data only.
class AdminNavItem {
  final IconData icon;
  final String   label;

  const AdminNavItem({required this.icon, required this.label});
}
