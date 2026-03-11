import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

/// Widget-based vertical bar chart.
///
/// [data] is a list of (label, value) records.
/// Bars are rendered with a green gradient and auto-scale to [height].
class AdminBarChart extends StatelessWidget {
  final List<(String, double)> data;
  final double                 height;

  const AdminBarChart({
    super.key,
    required this.data,
    this.height = 140,
  });

  @override
  Widget build(BuildContext context) {
    // Find the maximum value to scale the bars correctly
    final maxV = data.isEmpty ? 1.0 : data.map((d) => d.$2).reduce(math.max);
    final safeMaxV = maxV == 0 ? 1.0 : maxV;
    
    return SizedBox(
      height: height + 36, // Increased space for labels
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((d) {
          // Calculate bar height proportionally
          final barH = (d.$2 / safeMaxV * height).clamp(4.0, height);
          
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Use Flexible to prevent overflow
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      height: barH,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin:  Alignment.topCenter,
                          end:    Alignment.bottomCenter,
                          colors: [
                            AppColors.primaryLight,
                            AppColors.primary,
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Label text using professional theme colors
                  Text(
                    d.$1,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSubtle,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
