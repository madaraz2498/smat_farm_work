import 'package:flutter/material.dart';

class SystemReportsScreen extends StatefulWidget {
  const SystemReportsScreen({super.key});

  @override
  State<SystemReportsScreen> createState() => _SystemReportsScreenState();
}

class _SystemReportsScreenState extends State<SystemReportsScreen> {
  String _selectedPeriod = 'Last 7 Days';
  final List<String> _periods = ['Today', 'Last 7 Days', 'Last 30 Days', 'Last 3 Months', 'This Year'];

  // Bar chart mock data — requests per day (last 7 days)
  final List<_ChartBar> _requestsData = [
    _ChartBar(label: 'Mon', value: 620),
    _ChartBar(label: 'Tue', value: 880),
    _ChartBar(label: 'Wed', value: 740),
    _ChartBar(label: 'Thu', value: 1020),
    _ChartBar(label: 'Fri', value: 960),
    _ChartBar(label: 'Sat', value: 430),
    _ChartBar(label: 'Sun', value: 310),
  ];

  final List<_ModelReport> _modelReports = [
    _ModelReport(name: 'Plant Disease Detection', requests: 3214, success: 3089, failed: 125, avgTime: '1.2s', color: const Color(0xFF4CAF50)),
    _ModelReport(name: 'Animal Weight Estimation', requests: 1876, success: 1821, failed: 55, avgTime: '2.1s', color: const Color(0xFF2196F3)),
    _ModelReport(name: 'Crop Recommendation', requests: 1432, success: 1398, failed: 34, avgTime: '0.8s', color: const Color(0xFF9C27B0)),
    _ModelReport(name: 'Soil Type Analysis', requests: 987, success: 954, failed: 33, avgTime: '1.5s', color: const Color(0xFFFF9800)),
    _ModelReport(name: 'Fruit Quality Analysis', requests: 876, success: 843, failed: 33, avgTime: '1.8s', color: const Color(0xFFF44336)),
    _ModelReport(name: 'Smart Farm Chatbot', requests: 2103, success: 2067, failed: 36, avgTime: '0.4s', color: const Color(0xFF00BCD4)),
  ];

  final List<_UserReport> _topUsers = [
    _UserReport(name: 'Khaled Nasser', role: 'Researcher', requests: 1203, initials: 'KN', color: const Color(0xFF9C27B0)),
    _UserReport(name: 'Sara Mohamed', role: 'Agronomist', requests: 512, initials: 'SM', color: const Color(0xFF2196F3)),
    _UserReport(name: 'Ahmed Hassan', role: 'Farmer', requests: 234, initials: 'AH', color: const Color(0xFF4CAF50)),
    _UserReport(name: 'Mahmoud Samy', role: 'Farmer', requests: 178, initials: 'MS', color: const Color(0xFFFF9800)),
    _UserReport(name: 'Dina Farouk', role: 'Farmer', requests: 89, initials: 'DF', color: const Color(0xFFF44336)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF7),
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildKpiRow(),
                  const SizedBox(height: 24),
                  _buildRequestsChart(),
                  const SizedBox(height: 24),
                  LayoutBuilder(builder: (ctx, constraints) {
                    if (constraints.maxWidth > 700) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _buildModelTable()),
                          const SizedBox(width: 20),
                          Expanded(flex: 2, child: _buildTopUsersCard()),
                        ],
                      );
                    }
                    return Column(children: [
                      _buildModelTable(),
                      const SizedBox(height: 20),
                      _buildTopUsersCard(),
                    ]);
                  }),
                  const SizedBox(height: 24),
                  _buildExportRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 64,
      color: Colors.white,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.08))),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 3, offset: const Offset(0, 1))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF6B7280)),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(19)),
            child: const Icon(Icons.eco, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          const Text('Smart Farm AI', style: TextStyle(fontSize: 15, color: Color(0xFF1F2937))),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(8)),
            child: const Text('Admin', style: TextStyle(fontSize: 11, color: Color(0xFFE65100), fontWeight: FontWeight.w600)),
          ),
          const Spacer(),
          Container(
            width: 34, height: 34,
            decoration: const BoxDecoration(color: Color(0xFFE65100), shape: BoxShape.circle),
            child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('System Reports', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
            SizedBox(height: 4),
            Text('Analytics and usage statistics across the platform', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black.withOpacity(0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPeriod,
              style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
              icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF6B7280)),
              items: _periods.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (v) => setState(() => _selectedPeriod = v!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiRow() {
    final kpis = [
      ('Total Requests', '10,488', Icons.api_outlined, const Color(0xFF4CAF50), const Color(0xFFE8F5E9)),
      ('Success Rate', '96.8%', Icons.check_circle_outline, const Color(0xFF2196F3), const Color(0xFFE3F2FD)),
      ('Active Users', '1,284', Icons.people_outline, const Color(0xFF9C27B0), const Color(0xFFF3E5F5)),
      ('Avg Response', '1.3s', Icons.timer_outlined, const Color(0xFFFF9800), const Color(0xFFFFF3E0)),
    ];

    return LayoutBuilder(builder: (ctx, constraints) {
      final cols = constraints.maxWidth > 700 ? 4 : 2;
      return Wrap(
        spacing: 14,
        runSpacing: 14,
        children: kpis.map((k) {
          final w = (constraints.maxWidth - (cols - 1) * 14) / cols;
          return SizedBox(
            width: w,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withOpacity(0.06)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: k.$5, borderRadius: BorderRadius.circular(8)),
                    child: Icon(k.$3, color: k.$4, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(k.$2, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                      Text(k.$1, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildRequestsChart() {
    final maxVal = _requestsData.map((d) => d.value).reduce((a, b) => a > b ? a : b).toDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Requests Over Time', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
              Text(_selectedPeriod, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _requestsData.map((d) {
                final barHeight = (d.value / maxVal) * 120;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${d.value}', style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF))),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(d.label, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelTable() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AI Model Performance', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
          const SizedBox(height: 16),
          // Table headers
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.06))),
            ),
            child: Row(
              children: const [
                Expanded(flex: 4, child: Text('MODEL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF), letterSpacing: 0.8))),
                Expanded(flex: 2, child: Text('REQUESTS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF), letterSpacing: 0.8))),
                Expanded(flex: 2, child: Text('SUCCESS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF), letterSpacing: 0.8))),
                Expanded(flex: 2, child: Text('AVG TIME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF), letterSpacing: 0.8))),
              ],
            ),
          ),
          ..._modelReports.asMap().entries.map((e) => _buildModelRow(e.value, e.key == _modelReports.length - 1)),
        ],
      ),
    );
  }

  Widget _buildModelRow(_ModelReport model, bool isLast) {
    final successRate = model.requests > 0 ? (model.success / model.requests * 100).toStringAsFixed(1) : '0.0';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.black.withOpacity(0.04))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(width: 8, height: 8, margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: model.color, borderRadius: BorderRadius.circular(4))),
                Expanded(child: Text(model.name, style: const TextStyle(fontSize: 12, color: Color(0xFF374151)), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text('${model.requests}', style: const TextStyle(fontSize: 12, color: Color(0xFF1F2937), fontWeight: FontWeight.w500))),
          Expanded(
            flex: 2,
            child: Text('$successRate%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: double.parse(successRate) >= 95 ? const Color(0xFF4CAF50) : const Color(0xFFFF9800))),
          ),
          Expanded(flex: 2, child: Text(model.avgTime, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)))),
        ],
      ),
    );
  }

  Widget _buildTopUsersCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Users by Usage', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
          const SizedBox(height: 16),
          ..._topUsers.asMap().entries.map((e) => _buildTopUserRow(e.value, e.key + 1)),
        ],
      ),
    );
  }

  Widget _buildTopUserRow(_UserReport user, int rank) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 22, height: 22,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: rank == 1 ? const Color(0xFFFFC107) : rank == 2 ? const Color(0xFF9CA3AF) : rank == 3 ? const Color(0xFFCD7F32) : const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text('$rank', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: rank <= 3 ? Colors.white : const Color(0xFF6B7280)))),
          ),
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: user.color.withOpacity(0.15), shape: BoxShape.circle),
            child: Center(child: Text(user.initials, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: user.color))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2937))),
                Text(user.role, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${user.requests}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
              const Text('requests', style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExportRow() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_outlined, size: 16),
            label: const Text('Export as CSV'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4CAF50),
              side: const BorderSide(color: Color(0xFF4CAF50)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
            label: const Text('Export as PDF'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2196F3),
              side: const BorderSide(color: Color(0xFF2196F3)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChartBar {
  final String label;
  final int value;
  const _ChartBar({required this.label, required this.value});
}

class _ModelReport {
  final String name, avgTime;
  final int requests, success, failed;
  final Color color;
  const _ModelReport({required this.name, required this.requests, required this.success, required this.failed, required this.avgTime, required this.color});
}

class _UserReport {
  final String name, role, initials;
  final int requests;
  final Color color;
  const _UserReport({required this.name, required this.role, required this.requests, required this.initials, required this.color});
}
