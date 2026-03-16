import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/feature/admin/models/user_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// UserListTable
//
// Displays a searchable, filterable table of [UserData].
// Wraps rows in SingleChildScrollView to prevent vertical overflow.
// Uses Flexible/Expanded everywhere — no fixed-height containers.
// ─────────────────────────────────────────────────────────────────────────────
class UserListTable extends StatefulWidget {
  const UserListTable({super.key, required this.users});

  final List<UserData> users;

  @override
  State<UserListTable> createState() => _UserListTableState();
}

class _UserListTableState extends State<UserListTable> {
  String _searchQuery    = '';
  String _selectedRole   = 'All';
  String _selectedStatus = 'All';

  static const List<String> _roles    = ['All', 'Farmer', 'Agronomist', 'Researcher', 'Admin'];
  static const List<String> _statuses = ['All', 'Active', 'Inactive', 'Admins'];

  List<UserData> get _filtered => widget.users.where((u) {
    final q = _searchQuery.toLowerCase();
    return (q.isEmpty || u.name.toLowerCase().contains(q) || u.email.toLowerCase().contains(q))
        && (_selectedRole   == 'All' || u.role   == _selectedRole)
        && (_selectedStatus == 'All' || u.status == _selectedStatus);
  }).toList();

  @override
  Widget build(BuildContext context) {
    final rows = _filtered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FiltersRow(
          searchQuery:    _searchQuery,
          selectedRole:   _selectedRole,
          selectedStatus: _selectedStatus,
          roles:          _roles,
          statuses:       _statuses,
          onSearch:       (v) => setState(() => _searchQuery    = v),
          onRoleChanged:  (v) => setState(() => _selectedRole   = v),
          onStatusChanged:(v) => setState(() => _selectedStatus = v),
        ),
        const SizedBox(height: 12),

        // Table card
        Container(
          decoration: BoxDecoration(
            color:        AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusCard),
            border:       Border.all(color: Colors.black.withOpacity(0.06)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
            ],
          ),
          child: Column(
            children: [
              _TableHeader(),
              if (rows.isEmpty)
                const _EmptyState()
              else
                ...rows.asMap().entries.map(
                  (e) => _UserRow(
                    user:   e.value,
                    isLast: e.key == rows.length - 1,
                    onEdit:   () => _onEdit(context, e.value),
                    onDelete: () => _onDelete(context, e.value),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _onEdit(BuildContext ctx, UserData user) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text('Edit ${user.name} — coming soon'),
          backgroundColor: AppColors.primary),
    );
  }

  void _onDelete(BuildContext ctx, UserData user) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text('Delete ${user.name} — coming soon'),
          backgroundColor: AppColors.error),
    );
  }
}

// ── Filters row ───────────────────────────────────────────────────────────────

class _FiltersRow extends StatelessWidget {
  const _FiltersRow({
    required this.searchQuery,
    required this.selectedRole,
    required this.selectedStatus,
    required this.roles,
    required this.statuses,
    required this.onSearch,
    required this.onRoleChanged,
    required this.onStatusChanged,
  });

  final String               searchQuery, selectedRole, selectedStatus;
  final List<String>         roles, statuses;
  final ValueChanged<String> onSearch, onRoleChanged, onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12, runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Search
        SizedBox(
          width: 240,
          child: TextField(
            onChanged: onSearch,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText:        'Search name or email…',
              hintStyle:       AppTextStyles.caption,
              prefixIcon:      const Icon(Icons.search, size: 18, color: AppColors.textDisabled),
              contentPadding:  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              filled:          true,
              fillColor:       AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                borderSide:   BorderSide(color: Colors.black.withOpacity(0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                borderSide:   BorderSide(color: Colors.black.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                borderSide:   const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ),

        // Role filter
        _DropFilter(
          label: 'Role', value: selectedRole, items: roles, onChanged: onRoleChanged,
        ),

        // Status filter
        _DropFilter(
          label: 'Status', value: selectedStatus, items: statuses, onChanged: onStatusChanged,
        ),
      ],
    );
  }
}

class _DropFilter extends StatelessWidget {
  const _DropFilter({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });
  final String label, value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height:  40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMid),
        border:       Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          icon:  const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textDisabled),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }
}

// ── Table header ──────────────────────────────────────────────────────────────

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusCard)),
        border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.06))),
      ),
      child: Row(
        children: const [
          Expanded(flex: 3, child: Text('USER',         style: AppTextStyles.tableHeader)),
          Expanded(flex: 2, child: Text('ROLE',         style: AppTextStyles.tableHeader)),
          Expanded(flex: 2, child: Text('STATUS',       style: AppTextStyles.tableHeader)),
          Expanded(flex: 2, child: Text('LAST LOGIN',   style: AppTextStyles.tableHeader)),
          Expanded(flex: 1, child: Text('REQUESTS',     style: AppTextStyles.tableHeader)),
          SizedBox(width: 70),
        ],
      ),
    );
  }
}

// ── User row ──────────────────────────────────────────────────────────────────

class _UserRow extends StatelessWidget {
  const _UserRow({
    required this.user,
    required this.isLast,
    required this.onEdit,
    required this.onDelete,
  });
  final UserData      user;
  final bool          isLast;
  final VoidCallback  onEdit, onDelete;

  static const _roleColors = <String, Color>{
    'Admin':      Color(0xFFE65100),
    'Researcher': Color(0xFF9C27B0),
    'Agronomist': Color(0xFF2196F3),
    'Farmer':     Color(0xFF4CAF50),
  };

  static const _statusColors = <String, Color>{
    'Active':    Color(0xFF4CAF50),
    'Inactive':  Color(0xFFFF9800),
    'Admins': Color(0xFFEF4444),
  };

  @override
  Widget build(BuildContext context) {
    final roleColor   = _roleColors[user.role]   ?? AppColors.textSubtle;
    final statusColor = _statusColors[user.status] ?? AppColors.textSubtle;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.black.withOpacity(0.04))),
      ),
      child: Row(
        children: [
          // Avatar + name/email
          Expanded(
            flex: 3,
            child: Row(
              children: [
                _Avatar(initials: user.initials, color: roleColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label.copyWith(fontSize: 13),
                      ),
                      Text(user.email,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Role badge
          Expanded(
            flex: 2,
            child: _Badge(label: user.role, color: roleColor),
          ),

          // Status badge
          Expanded(
            flex: 2,
            child: _Badge(
              label: user.status,
              color: statusColor,
              filled: true,
            ),
          ),

          // Last login
          Expanded(
            flex: 2,
            child: Text(user.lastLogin,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption,
            ),
          ),

          // Requests count
          Expanded(
            flex: 1,
            child: Text(user.requests.toString(),
              style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark,
              ),
            ),
          ),

          // Action buttons
          SizedBox(
            width: 70,
            child: Row(
              children: [
                _ActionBtn(icon: Icons.edit_outlined,  color: AppColors.info,  onTap: onEdit),
                const SizedBox(width: 4),
                _ActionBtn(icon: Icons.delete_outline, color: AppColors.error, onTap: onDelete),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Small helpers ─────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials, required this.color});
  final String initials;
  final Color  color;

  @override
  Widget build(BuildContext context) => Container(
    width: 36, height: 36,
    decoration: BoxDecoration(
      color: color.withOpacity(0.12), shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(initials,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
      ),
    ),
  );
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color, this.filled = false});
  final String label;
  final Color  color;
  final bool   filled;

  @override
  Widget build(BuildContext context) => Container(
    padding:    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color:        filled ? color.withOpacity(0.12) : Colors.transparent,
      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      border:       filled ? null : Border.all(color: color.withOpacity(0.4)),
    ),
    child: Text(label,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
    ),
  );
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({required this.icon, required this.color, required this.onTap});
  final IconData     icon;
  final Color        color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap:        onTap,
    borderRadius: BorderRadius.circular(6),
    child: Container(
      padding:    const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color:        color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 15, color: color),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 40),
    child: Center(
      child: Text('No users match the current filters.',
        style: TextStyle(color: AppColors.textDisabled),
      ),
    ),
  );
}
