import 'package:flutter/material.dart';

class SystemManagementScreen extends StatefulWidget {
  const SystemManagementScreen({super.key});

  @override
  State<SystemManagementScreen> createState() => _SystemManagementScreenState();
}

class _SystemManagementScreenState extends State<SystemManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // AI Model toggles
  bool _plantDiseaseEnabled = true;
  bool _animalWeightEnabled = true;
  bool _cropRecommendEnabled = false;
  bool _soilAnalysisEnabled = true;
  bool _fruitQualityEnabled = true;
  bool _chatbotEnabled = true;

  // System settings
  bool _maintenanceMode = false;
  bool _registrationOpen = true;
  bool _emailNotifications = true;
  bool _autoBackup = true;
  String _maxRequestsPerDay = '500';
  String _sessionTimeout = '60';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                  _buildTabBar(),
                  const SizedBox(height: 20),
                  _buildTabContent(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('System Management', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
        SizedBox(height: 4),
        Text('Configure platform settings, AI models, and system behavior', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF4CAF50),
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF6B7280),
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.all(4),
        tabs: const [
          Tab(text: 'AI Models'),
          Tab(text: 'General Settings'),
          Tab(text: 'Security'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        switch (_tabController.index) {
          case 0: return _buildAIModelsTab();
          case 1: return _buildGeneralSettingsTab();
          case 2: return _buildSecurityTab();
          default: return _buildAIModelsTab();
        }
      },
    );
  }

  Widget _buildAIModelsTab() {
    final models = [
      _AIModel(name: 'Plant Disease Detection', desc: 'CNN-based leaf disease classification', icon: Icons.local_florist_outlined, color: const Color(0xFF4CAF50), isEnabled: _plantDiseaseEnabled, onToggle: (v) => setState(() => _plantDiseaseEnabled = v), version: 'v2.1.3', accuracy: '94.2%'),
      _AIModel(name: 'Animal Weight Estimation', desc: 'Computer vision weight estimation', icon: Icons.monitor_weight_outlined, color: const Color(0xFF2196F3), isEnabled: _animalWeightEnabled, onToggle: (v) => setState(() => _animalWeightEnabled = v), version: 'v1.4.0', accuracy: '91.7%'),
      _AIModel(name: 'Crop Recommendation', desc: 'ML-based crop suggestion engine', icon: Icons.grass_outlined, color: const Color(0xFF9C27B0), isEnabled: _cropRecommendEnabled, onToggle: (v) => setState(() => _cropRecommendEnabled = v), version: 'v3.0.1', accuracy: '88.5%'),
      _AIModel(name: 'Soil Type Analysis', desc: 'AI soil classification and fertility', icon: Icons.layers_outlined, color: const Color(0xFFFF9800), isEnabled: _soilAnalysisEnabled, onToggle: (v) => setState(() => _soilAnalysisEnabled = v), version: 'v1.2.0', accuracy: '89.3%'),
      _AIModel(name: 'Fruit Quality Analysis', desc: 'Deep learning fruit grading', icon: Icons.apple_outlined, color: const Color(0xFFF44336), isEnabled: _fruitQualityEnabled, onToggle: (v) => setState(() => _fruitQualityEnabled = v), version: 'v2.0.5', accuracy: '92.8%'),
      _AIModel(name: 'Smart Farm Chatbot', desc: 'NLP farming assistant (AR/EN)', icon: Icons.chat_bubble_outline, color: const Color(0xFF00BCD4), isEnabled: _chatbotEnabled, onToggle: (v) => setState(() => _chatbotEnabled = v), version: 'v1.8.2', accuracy: '87.1%'),
    ];

    return Column(
      children: [
        ...models.map((m) => _buildModelCard(m)),
        const SizedBox(height: 16),
        _buildSaveButton('Save AI Configuration'),
      ],
    );
  }

  Widget _buildModelCard(_AIModel model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: model.isEnabled ? model.color.withOpacity(0.12) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(model.icon, color: model.isEnabled ? model.color : Colors.grey, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(model.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                      child: Text(model.version, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(model.desc, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.analytics_outlined, size: 12, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 4),
                    Text('Accuracy: ${model.accuracy}', style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: model.isEnabled,
            onChanged: model.onToggle,
            activeColor: model.color,
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettingsTab() {
    return Column(
      children: [
        _buildSettingsCard('Platform Settings', [
          _buildToggleSetting('Maintenance Mode', 'Temporarily disable user access', _maintenanceMode, (v) => setState(() => _maintenanceMode = v), const Color(0xFFEF4444)),
          _buildToggleSetting('Open Registration', 'Allow new users to sign up', _registrationOpen, (v) => setState(() => _registrationOpen = v), const Color(0xFF4CAF50)),
          _buildToggleSetting('Email Notifications', 'Send system notifications via email', _emailNotifications, (v) => setState(() => _emailNotifications = v), const Color(0xFF2196F3)),
          _buildToggleSetting('Automatic Backup', 'Daily database backups', _autoBackup, (v) => setState(() => _autoBackup = v), const Color(0xFF9C27B0)),
        ]),
        const SizedBox(height: 16),
        _buildSettingsCard('Limits & Quotas', [
          _buildInputSetting('Max Requests Per Day', 'Per user limit', _maxRequestsPerDay, (v) => _maxRequestsPerDay = v),
          _buildInputSetting('Session Timeout (min)', 'Auto logout after inactivity', _sessionTimeout, (v) => _sessionTimeout = v),
        ]),
        const SizedBox(height: 16),
        _buildSaveButton('Save General Settings'),
      ],
    );
  }

  Widget _buildSettingsCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildToggleSetting(String label, String desc, bool value, ValueChanged<bool> onChanged, Color activeColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2937))),
                Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: activeColor),
        ],
      ),
    );
  }

  Widget _buildInputSetting(String label, String hint, String value, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2937))),
                Text(hint, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: TextField(
              controller: TextEditingController(text: value),
              onChanged: onChanged,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return Column(
      children: [
        _buildSettingsCard('Access Control', [
          _buildInfoRow(Icons.lock_outline, 'Password Policy', 'Min 8 chars, uppercase, number required', const Color(0xFF4CAF50)),
          _buildInfoRow(Icons.security, 'Two-Factor Auth', 'Available for Admin accounts', const Color(0xFF2196F3)),
          _buildInfoRow(Icons.block_outlined, 'Failed Login Lockout', 'Lock after 5 failed attempts (30 min)', const Color(0xFFFF9800)),
          _buildInfoRow(Icons.vpn_lock_outlined, 'API Rate Limiting', '100 requests/min per IP', const Color(0xFF9C27B0)),
        ]),
        const SizedBox(height: 16),
        _buildSettingsCard('Audit Log', [
          _buildAuditEntry('Admin login', '2025-04-28 09:14:22', 'Success'),
          _buildAuditEntry('User deleted: USR006', '2025-04-27 16:45:01', 'Success'),
          _buildAuditEntry('System settings changed', '2025-04-27 14:12:44', 'Success'),
          _buildAuditEntry('Failed login attempt', '2025-04-26 22:31:09', 'Failed'),
        ]),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_outlined, size: 16),
                label: const Text('Export Audit Log'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4CAF50),
                  side: const BorderSide(color: Color(0xFF4CAF50)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2937))),
                Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditEntry(String action, String time, String result) {
    final isSuccess = result == 'Success';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 8, height: 8,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: isSuccess ? const Color(0xFF4CAF50) : const Color(0xFFEF4444),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(child: Text(action, style: const TextStyle(fontSize: 12, color: Color(0xFF374151)))),
          Text(time, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: isSuccess ? const Color(0xFFE8F5E9) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(result, style: TextStyle(fontSize: 10, color: isSuccess ? const Color(0xFF4CAF50) : const Color(0xFFEF4444), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(String label) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label saved!'), backgroundColor: const Color(0xFF4CAF50)),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(label),
      ),
    );
  }
}

class _AIModel {
  final String name, desc, version, accuracy;
  final IconData icon;
  final Color color;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  const _AIModel({required this.name, required this.desc, required this.icon, required this.color, required this.isEnabled, required this.onToggle, required this.version, required this.accuracy});
}
