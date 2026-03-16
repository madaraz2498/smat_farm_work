import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/feature/admin/models/reports_data_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
/// Card listing the top users ranked by total AI requests.
///
/// [users] — list of [TopUser] entries (already sorted by rank).
// ─────────────────────────────────────────────────────────────────────────────
class ReportsTopUsers extends StatelessWidget {
  const ReportsTopUsers({super.key, required this.users});

  final List<TopUser> users;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.pagePadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Users by Usage', style: AppTextStyles.cardTitle),
          const SizedBox(height: 16),
          ...users.asMap().entries.map(
                (e) => _UserRow(user: e.value, rank: e.key + 1),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Single row inside [ReportsTopUsers].
// ─────────────────────────────────────────────────────────────────────────────
class _UserRow extends StatelessWidget {
  const _UserRow({required this.user, required this.rank});

  final TopUser user;
  final int     rank;

  /// Returns the medal colour for ranks 1–3, divider colour otherwise.
  Color _rankColor() {
    if (rank == 1) return const Color(0xFFFFC107); // gold
    if (rank == 2) return AppColors.textDisabled;   // silver
    if (rank == 3) return const Color(0xFFCD7F32);  // bronze
    return AppColors.divider;
  }

  @override
  Widget build(BuildContext context) {
    final rankColor = _rankColor();

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          // Rank badge
          Container(
            width:  22,
            height: 22,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: rankColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize:   10,
                  fontWeight: FontWeight.bold,
                  color: rank <= 3 ? Colors.white : AppColors.textSubtle,
                ),
              ),
            ),
          ),

          // Avatar
          Container(
            width:  34,
            height: 34,
            decoration: BoxDecoration(
              color: user.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.initials,
                style: TextStyle(
                  fontSize:   11,
                  fontWeight: FontWeight.bold,
                  color:      user.color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Name + role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(fontSize: 13),
                ),
                Text(user.role, style: AppTextStyles.caption),
              ],
            ),
          ),

          // Request count
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user.requests}',
                style: const TextStyle(
                  fontSize:   13,
                  fontWeight: FontWeight.bold,
                  color:      AppColors.textDark,
                ),
              ),
              const Text('requests', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}