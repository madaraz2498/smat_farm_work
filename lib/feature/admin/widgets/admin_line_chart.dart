import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

/// Animated line chart rendered with [CustomPainter].
///
/// Accepts [values] (y-axis data points) and [xLabels] (x-axis labels).
/// Uses [AppColors.primary] for the line and gradient fill.
class AdminLineChart extends StatelessWidget {
  final List<double> values;
  final List<String> xLabels;
  final double       height;

  const AdminLineChart({
    super.key,
    required this.values,
    required this.xLabels,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
          child: CustomPaint(
            painter: _LineChartPainter(values: values),
            size: Size.infinite,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: xLabels
              .map((l) => Text(
                    l,
                    style: const TextStyle(
                      fontSize: 11,
                      color:    AppColors.textDisabled,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  _LineChartPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final maxV = values.reduce(math.max);
    if (maxV == 0) return;

    // Grid lines
    final grid = Paint()
      ..color      = AppColors.textDisabled.withOpacity(0.15)
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = size.height * (1 - i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // Y-axis value labels
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i <= 4; i++) {
      tp.text = TextSpan(
        text:  '${(maxV * i / 4).round()}',
        style: const TextStyle(fontSize: 10, color: AppColors.textDisabled),
      );
      tp.layout();
      final y = size.height * (1 - i / 4);
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    const leftPad = 28.0;
    final usableW = size.width - leftPad;

    Offset pt(int i) => Offset(
          leftPad + i / (values.length - 1) * usableW,
          size.height - values[i] / maxV * size.height,
        );

    // Gradient fill under the line
    final fillPath = Path()
      ..moveTo(pt(0).dx, size.height)
      ..lineTo(pt(0).dx, pt(0).dy);
    for (int i = 1; i < values.length; i++) {
      fillPath.lineTo(pt(i).dx, pt(i).dy);
    }
    fillPath
      ..lineTo(pt(values.length - 1).dx, size.height)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin:  Alignment.topCenter,
          end:    Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.20),
            AppColors.primary.withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Main line
    final linePath = Path()..moveTo(pt(0).dx, pt(0).dy);
    for (int i = 1; i < values.length; i++) {
      linePath.lineTo(pt(i).dx, pt(i).dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color       = AppColors.primary
        ..strokeWidth = 2.5
        ..style       = PaintingStyle.stroke
        ..strokeCap   = StrokeCap.round,
    );

    // Data-point dots
    for (int i = 0; i < values.length; i++) {
      canvas.drawCircle(pt(i), 5, Paint()..color = AppColors.surface);
      canvas.drawCircle(pt(i), 3.5, Paint()..color = AppColors.primary);
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter old) => old.values != values;
}
