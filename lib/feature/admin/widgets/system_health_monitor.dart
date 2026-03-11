import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SystemHealthMonitor
//
// Shows AI-model status tiles and recent audit log entries.
// Uses Wrap for model tiles → zero overflow on any screen width.
// ─────────────────────────────────────────────────────────────────────────────

class _ModelStatus {
  final String   name;
  final String   version;
  final String   accuracy;
  final bool     online;
  final IconData icon;
  final Color    color;
  const _ModelStatus({
    required this.name, required this.version, required this.accuracy,
    required this.online, required this.icon, required this.color,
  });
}

class _LogEntry {
  final String action, time, result;
  const _LogEntry({required this.action, required this.time, required this.result});
}

class SystemHealthMonitor extends StatelessWidget {
  const SystemHealthMonitor({super.key});

  static const List<_ModelStatus> _models = [
    _ModelStatus(name: 'Plant Disease Detection', version: 'v2.1.3', accuracy: '94.2%', online: true,  icon: Icons.local_florist_outlined,  color: Color(0xFF4CAF50)),
    _ModelStatus(name: 'Animal Weight Estimation',version: 'v1.4.0', accuracy: '91.7%', online: true,  icon: Icons.monitor_weight_outlined,  color: Color(0xFF2196F3)),
    _ModelStatus(name: 'Crop Recommendation',     version: 'v3.0.1', accuracy: '88.5%', online: false, icon: Icons.grass_outlined,           color: Color(0xFF9C27B0)),
    _ModelStatus(name: 'Soil Type Analysis',      version: 'v1.2.0', accuracy: '89.3%', online: true,  icon: Icons.layers_outlined,          color: Color(0xFFFF9800)),
    _ModelStatus(name: 'Fruit Quality Analysis',  version: 'v2.0.5', accuracy: '92.8%', online: true,  icon: Icons.apple_outlined,           color: Color(0xFFF44336)),
    _ModelStatus(name: 'Smart Farm Chatbot',      version: 'v1.8.2', accuracy: '87.1%', online: true,  icon: Icons.chat_bubble_outline,      color: Color(0xFF00BCD4)),
  ];

  static const List<_LogEntry> _logs = [
    _LogEntry(action: 'Admin login',              time: '09:14', result: 'Success'),
    _LogEntry(action: 'User USR006 suspended',    time: '08:50', result: 'Success'),
    _LogEntry(action: 'AI model config updated',  time: '08:12', result: 'Success'),
    _LogEntry(action: 'Failed login attempt',     time: '07:31', result: 'Failed'),
    _LogEntry(action: 'Database backup complete', time: '03:00', result: 'Success'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('AI Model Status', style: AppTextStyles.cardTitle),
        const SizedBox(height: 12),
        _ModelGrid(models: _models),
        const SizedBox(height: 24),
        const Text('Recent Audit Log', style: AppTextStyles.cardTitle),
        const SizedBox(height: 12),
        _AuditLog(logs: _logs),
      ],
    );
  }
}

// ── Model grid ────────────────────────────────────────────────────────────────

class _ModelGrid extends StatelessWidget {
  const _ModelGrid({required this.models});
  final List<_ModelStatus> models;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final cols      = constraints.maxWidth > AppSizes.wideBreak ? 3 : 2;
      final spacing   = 12.0;
      final cardWidth = (constraints.maxWidth - (cols - 1) * spacing) / cols;

      return Wrap(
        spacing:    spacing,
        runSpacing: spacing,
        children: models.map((m) {
          return SizedBox(
            width: cardWidth,
            child: _ModelTile(model: m),
          );
        }).toList(),
      );
    });
  }
}

class _ModelTile extends StatelessWidget {
  const _ModelTile({required this.model});
  final _ModelStatus model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(
          color: model.online
              ? model.color.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:    const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: model.online
                      ? model.color.withOpacity(0.12)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  model.icon,
                  size:  18,
                  color: model.online ? model.color : Colors.grey,
                ),
              ),
              const Spacer(),
              _OnlineDot(online: model.online),
            ],
          ),
          const SizedBox(height: 10),
          Text(model.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text('${model.version} • ${model.accuracy}',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _OnlineDot extends StatelessWidget {
  const _OnlineDot({required this.online});
  final bool online;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width:  7, height: 7,
          decoration: BoxDecoration(
            color: online ? AppColors.success : AppColors.error,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          online ? 'Online' : 'Offline',
          style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w500,
            color: online ? AppColors.success : AppColors.error,
          ),
        ),
      ],
    );
  }
}

// ── Audit log ─────────────────────────────────────────────────────────────────

class _AuditLog extends StatelessWidget {
  const _AuditLog({required this.logs});
  final List<_LogEntry> logs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Column(
        children: logs.asMap().entries.map((e) {
          final isLast  = e.key == logs.length - 1;
          final log     = e.value;
          final success = log.result == 'Success';
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: isLast ? null : Border(
                bottom: BorderSide(color: Colors.black.withOpacity(0.04)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 7, height: 7,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: success ? AppColors.success : AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(log.action,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: AppColors.textMid),
                  ),
                ),
                const SizedBox(width: 8),
                Text(log.time, style: AppTextStyles.caption),
                const SizedBox(width: 8),
                _ResultBadge(result: log.result, success: success),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.result, required this.success});
  final String result;
  final bool   success;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color:        success ? const Color(0xFFE8F5E9) : const Color(0xFFFEF2F2),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      result,
      style: TextStyle(
        fontSize: 10, fontWeight: FontWeight.w600,
        color: success ? AppColors.success : AppColors.error,
      ),
    ),
  );
}
