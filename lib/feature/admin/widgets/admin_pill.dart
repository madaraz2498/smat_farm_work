import 'package:flutter/material.dart';

/// Coloured pill / badge label used on stat cards and table rows.
class AdminPill extends StatelessWidget {
  final String text;
  final Color  bg, fg;

  const AdminPill(
    this.text, {
    super.key,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color:        bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize:   11,
          color:      fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
