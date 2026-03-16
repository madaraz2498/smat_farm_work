import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SystemManagementPage  —  configure AI models, general settings .
// Uses AnimatedBuilder for tab switching (no unnecessary rebuilds).
// ─────────────────────────────────────────────────────────────────────────────
class SystemManagementPage extends StatefulWidget {
  const SystemManagementPage({super.key});

  @override
  State<SystemManagementPage> createState() => _SystemManagementPageState();
}

class _SystemManagementPageState extends State<SystemManagementPage>
    with SingleTickerProviderStateMixin {

  late final TabController _tab;

  // AI model toggles
  var _plantDisease  = true;
  var _animalWeight  = true;
  var _cropRecommend = false;
  var _soilAnalysis  = true;
  var _fruitQuality  = true;
  var _chatbot       = true;

  // General settings
  var _maintenanceMode    = false;
  var _registrationOpen   = true;
  var _emailNotifications = true;
  var _autoBackup         = true;
  var _maxRequests        = '500';
  var _sessionTimeout     = '60';

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(() => setState(() {})); // refresh when tab changes
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('System Management', style: AppTextStyles.pageTitle),
          const SizedBox(height: 4),
          const Text('Configure platform settings, AI models, and system behaviour',
              style: AppTextStyles.pageSubtitle),
          const SizedBox(height: 24),
          _TabBar(controller: _tab),
          const SizedBox(height: 20),
          _buildCurrentTab(),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_tab.index) {
      case 1:  return _GeneralSettingsTab(
        maintenanceMode:    _maintenanceMode,
        emailNotifications: _emailNotifications,
        autoBackup:         _autoBackup,
        maxRequests:        _maxRequests,
        sessionTimeout:     _sessionTimeout,
        onToggle: (field, v) => setState(() {
          switch (field) {
            case 'maintenance':   _maintenanceMode    = v; break;
            case 'email':         _emailNotifications = v; break;
            case 'backup':        _autoBackup         = v; break;
          }
        }),
        onInputChange: (field, v) {
          if (field == 'requests') _maxRequests   = v;
          if (field == 'timeout')  _sessionTimeout = v;
        },
      );
      default: return _AIModelsTab(
        plantDisease:  _plantDisease,
        animalWeight:  _animalWeight,
        cropRecommend: _cropRecommend,
        soilAnalysis:  _soilAnalysis,
        fruitQuality:  _fruitQuality,
        chatbot:       _chatbot,
        onToggle: (field, v) => setState(() {
          switch (field) {
            case 'plant':    _plantDisease  = v; break;
            case 'animal':   _animalWeight  = v; break;
            case 'crop':     _cropRecommend = v; break;
            case 'soil':     _soilAnalysis  = v; break;
            case 'fruit':    _fruitQuality  = v; break;
            case 'chatbot':  _chatbot       = v; break;
          }
        }),
      );
    }
  }
}

// ── Custom tab bar ─────────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  const _TabBar({required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: TabBar(
        controller:           controller,
        indicator:            BoxDecoration(
          color:        AppColors.primary,
          borderRadius: BorderRadius.circular(AppSizes.radiusMid),
        ),
        indicatorSize:        TabBarIndicatorSize.tab,
        labelColor:           Colors.white,
        unselectedLabelColor: AppColors.textSubtle,
        labelStyle:           AppTextStyles.label.copyWith(fontSize: 13),
        padding:              const EdgeInsets.all(4),
        tabs: const [
          Tab(text: 'AI Models'),
          Tab(text: 'General Settings'),
        ],
      ),
    );
  }
}

// ── AI Models tab ──────────────────────────────────────────────────────────────

class _AIModelsTab extends StatelessWidget {
  const _AIModelsTab({
    required this.plantDisease, required this.animalWeight,
    required this.cropRecommend, required this.soilAnalysis,
    required this.fruitQuality, required this.chatbot,
    required this.onToggle,
  });

  final bool plantDisease, animalWeight, cropRecommend, soilAnalysis, fruitQuality, chatbot;
  final void Function(String field, bool value) onToggle;

  @override
  Widget build(BuildContext context) {
    final models = [
      (key: 'plant',   name: 'Plant Disease Detection',  desc: 'CNN-based leaf classification',       icon: Icons.local_florist_outlined, color: AppColors.primary,        version: 'v2.1.3', acc: '94.2%', enabled: plantDisease),
      (key: 'animal',  name: 'Animal Weight Estimation', desc: 'Computer vision weight estimation',   icon: Icons.monitor_weight_outlined, color: AppColors.info,           version: 'v1.4.0', acc: '91.7%', enabled: animalWeight),
      (key: 'crop',    name: 'Crop Recommendation',      desc: 'ML-based crop suggestion engine',     icon: Icons.grass_outlined,          color: const Color(0xFF9C27B0),  version: 'v3.0.1', acc: '88.5%', enabled: cropRecommend),
      (key: 'soil',    name: 'Soil Type Analysis',       desc: 'AI soil classification & fertility',  icon: Icons.layers_outlined,         color: AppColors.warning,        version: 'v1.2.0', acc: '89.3%', enabled: soilAnalysis),
      (key: 'fruit',   name: 'Fruit Quality Analysis',   desc: 'Deep learning fruit grading',         icon: Icons.apple_outlined,          color: AppColors.error,          version: 'v2.0.5', acc: '92.8%', enabled: fruitQuality),
      (key: 'chatbot', name: 'Smart Farm Chatbot',       desc: 'NLP farming assistant (AR / EN)',     icon: Icons.chat_bubble_outline,     color: const Color(0xFF00BCD4),  version: 'v1.8.2', acc: '87.1%', enabled: chatbot),
    ];

    return Column(
      children: [
        ...models.map((m) => _ModelCard(
          name:      m.name,
          desc:      m.desc,
          icon:      m.icon,
          color:     m.color,
          version:   m.version,
          accuracy:  m.acc,
          isEnabled: m.enabled,
          onToggle:  (v) => onToggle(m.key, v),
        )),
        const SizedBox(height: 12),
        _SaveButton(label: 'Save AI Configuration', onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('AI configuration saved!'),
                backgroundColor: AppColors.primary),
          );
        }),
      ],
    );
  }
}

class _ModelCard extends StatelessWidget {
  const _ModelCard({
    required this.name, required this.desc, required this.icon, required this.color,
    required this.version, required this.accuracy, required this.isEnabled, required this.onToggle,
  });

  final String name, desc, version, accuracy;
  final IconData icon;
  final Color    color;
  final bool     isEnabled;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow:   [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
      ),
      child: Row(
        children: [
          Container(
            padding:    const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isEnabled ? color.withOpacity(0.12) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: isEnabled ? color : Colors.grey, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(name,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(version, style: AppTextStyles.caption),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(desc, style: AppTextStyles.caption),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.analytics_outlined, size: 12, color: AppColors.textDisabled),
                    const SizedBox(width: 4),
                    Text('Accuracy: $accuracy', style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          Switch(value: isEnabled, onChanged: onToggle, activeColor: color),
        ],
      ),
    );
  }
}

// ── General settings tab ───────────────────────────────────────────────────────

class _GeneralSettingsTab extends StatelessWidget {
  const _GeneralSettingsTab({
    required this.maintenanceMode,
    required this.emailNotifications, required this.autoBackup,
    required this.maxRequests, required this.sessionTimeout,
    required this.onToggle, required this.onInputChange,
  });

  final bool maintenanceMode, emailNotifications, autoBackup;
  final String maxRequests, sessionTimeout;
  final void Function(String field, bool v) onToggle;
  final void Function(String field, String v) onInputChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SettingsCard(title: 'Platform Settings', children: [
          _ToggleRow('Maintenance Mode',    'Disable user access temporarily', maintenanceMode,    AppColors.error,   (v) => onToggle('maintenance',  v)),
          _ToggleRow('Email Notifications', 'System alerts via email',         emailNotifications, AppColors.info,    (v) => onToggle('email',        v)),
          _ToggleRow('Auto Backup',         'Daily database snapshots',        autoBackup,         const Color(0xFF9C27B0), (v) => onToggle('backup', v)),
        ]),
        const SizedBox(height: 16),
        _SaveButton(label: 'Save General Settings', onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('General settings saved!'),
                backgroundColor: AppColors.primary),
          );
        }),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.title, required this.children});
  final String       title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(AppSizes.pagePadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow:   [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow(this.label, this.desc, this.value, this.color, this.onChanged);
  final String label, desc;
  final bool   value;
  final Color  color;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.label),
                Text(desc,  style: AppTextStyles.caption),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: color),
        ],
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  const _InputRow(this.label, this.hint, this.value, this.onChanged);
  final String label, hint, value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.label),
                Text(hint,  style: AppTextStyles.caption),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: TextField(
              controller: TextEditingController(text: value),
              onChanged:  onChanged,
              textAlign:  TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                  borderSide:   BorderSide(color: Colors.black.withOpacity(0.12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                  borderSide:   BorderSide(color: Colors.black.withOpacity(0.12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                  borderSide:   const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// ── Shared save button ─────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.label, required this.onPressed});
  final String       label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation:       0,
          padding:         const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
