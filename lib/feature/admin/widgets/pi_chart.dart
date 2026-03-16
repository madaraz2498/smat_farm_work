import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/feature/admin/pages/admin_dashboard_page.dart';

class ActiveUsersChart extends StatelessWidget {
  const ActiveUsersChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // زودنا الارتفاع عشان الرسمة تاخد راحتها
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Active Users",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1A1C1E)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 20),
            child: Text(
              "Daily active users this week",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: 60,
                barTouchData: BarTouchData(enabled: true), // فعلنا التفاعل عشان لو لمست العمود
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 30,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 10,
                          child: Text(
                            days[value.toInt()],
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 15,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xFFF1F5F9),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _buildBarGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final data = [30.0, 42.0, 35.0, 52.0, 48.0, 28.0, 22.0];
    return List.generate(data.length, (i) => BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
          toY: data[i],
          color: const Color(0xFF53B175), // اللون الأخضر الهادئ
          width: 20, // صغرنا العرض شوية عشان ميبقوش متكدسين
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 60,
            color: const Color(0xFFF8FAFC), // خلفية رمادية فاتحة جداً
          ),
        ),
      ],
    ));
  }
}

class ServicePieChart extends StatelessWidget {
  const ServicePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Service Distribution",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("Usage by AI service",
              style: TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              children: [
                // الرسم البياني
                Expanded(
                  flex: 1,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 45,
                      sections: _buildSections(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // قائمة البيانات (Legend)
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildLegend(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // إنشاء أقسام الدائرة الستة
  List<PieChartSectionData> _buildSections() {
    final data = [
      {'val': 25.0, 'color': const Color(0xFF4CAF50)}, // Plant
      {'val': 21.0, 'color': const Color(0xFF66BB6A)}, // Chatbot
      {'val': 18.0, 'color': const Color(0xFF81C784)}, // Animal
      {'val': 14.0, 'color': const Color(0xFFA5D6A7)}, // Recommendation
      {'val': 12.0, 'color': const Color(0xFFC8E6C9)}, // Soil
      {'val': 10.0, 'color': const Color(0xFFE8F5E9)}, // Fruit
    ];

    return data.map((item) => PieChartSectionData(
      value: item['val'] as double,
      color: item['color'] as Color,
      radius: 40,
      showTitle: false, // شيلنا العنوان من جوه عشان الزحمة
    )).toList();
  }

  // إنشاء وسيلة الإيضاح بجانب الرسمة
  List<Widget> _buildLegend() {
    final labels = [
      {'name': 'Plant Disease', 'pct': '25%', 'color': Color(0xFF4CAF50)},
      {'name': 'Chatbot', 'pct': '21%', 'color': Color(0xFF66BB6A)},
      {'name': 'Animal Weight', 'pct': '18%', 'color': Color(0xFF81C784)},
      {'name': 'Recommendation', 'pct': '14%', 'color': Color(0xFFA5D6A7)},
      {'name': 'Soil Analysis', 'pct': '12%', 'color': Color(0xFFC8E6C9)},
      {'name': 'Fruit Quality', 'pct': '10%', 'color': Color(0xFFE8F5E9)},
    ];

    return labels.map((item) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: item['color'] as Color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(item['name'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
          Text(item['pct'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    )).toList();
  }
}

class UsageChart extends StatelessWidget {
  const UsageChart();
  @override
  Widget build(BuildContext context) {
    return _ChartWrapper(
      title: "Usage Over Time",
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, interval: 150, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                  if (value.toInt() < labels.length) return Text(labels[value.toInt()], style: const TextStyle(fontSize: 10));
                  return const SizedBox();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [FlSpot(0, 150), FlSpot(1, 200), FlSpot(2, 240), FlSpot(3, 300), FlSpot(4, 380), FlSpot(5, 420)],
              isCurved: true,
              color: AppColors.primary,
              barWidth: 4,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: AppColors.primary.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }
}


class _ChartWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  const _ChartWrapper({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Expanded(child: child),
        ],
      ),
    );
  }
}