import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

/// Pie chart rendered with [CustomPainter].
///
/// [segments] is a list of (label, fraction, color) records
/// where fractions should sum to 1.0.
class AdminPieChart extends StatelessWidget {
  final List<(String, double, Color)> segments;

  const AdminPieChart({super.key, required this.segments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            width:  160,
            height: 160,
            child: CustomPaint(
              painter: _PiePainter(
                segments: segments.map((s) => (s.$3, s.$2)).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing:    10,
          runSpacing: 6,
          children: segments
              .map(
                (s) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width:  10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: s.$3,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${s.$1}: ${(s.$2 * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 11,
                        color:    AppColors.textSubtle,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _PiePainter extends CustomPainter {
  final List<(Color, double)> segments;
  _PiePainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;
    double start = -math.pi / 2;

    for (final (color, frac) in segments) {
      final sweep = 2 * math.pi * frac;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start, sweep, true,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
      // White separator stroke
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start, sweep, true,
        Paint()
          ..color       = AppColors.surface
          ..style       = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_PiePainter _) => false;
}
