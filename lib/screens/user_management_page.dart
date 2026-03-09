import 'package:flutter/material.dart';

// ─── Mock user model ──────────────────────────────────────────────────────────

class _MockUser {
  final String id;
  final String name;
  final String email;
  final String role;
  bool isActive;

  _MockUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isActive = true,
  });
}

// ─── User Management Page ─────────────────────────────────────────────────────

/// Admin-only page. Lists mock users and allows delete / deactivate (UI only).
/// Security: only reachable through [AdminDashboardPage] which guards on
/// [AuthProvider.isAdmin]. A regular user can never navigate here.
class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  String _searchQuery = '';
  String _filterRole = 'All';

  final List<String> _roles = [
    'All',
    'Farmer',
    'Agronomist',
    'Researcher',
  ];

  // Mock users — replace with API list later.
  final List<_MockUser> _users = [
    _MockUser(id: 'U001', name: 'Ahmed Hassan', email: 'ahmed@smartfarm.ai', role: 'Farmer'),
    _MockUser(id: 'U002', name: 'Sara Mohamed', email: 'sara@smartfarm.ai', role: 'Agronomist'),
    _MockUser(id: 'U003', name: 'Omar Khalil', email: 'omar@smartfarm.ai', role: 'Researcher'),
    _MockUser(id: 'U004', name: 'Nour Ali', email: 'nour@smartfarm.ai', role: 'Farmer', isActive: false),
    _MockUser(id: 'U005', name: 'Mahmoud Samy', email: 'mahmoud@smartfarm.ai', role: 'Farmer'),
    _MockUser(id: 'U006', name: 'Laila Ibrahim', email: 'laila@smartfarm.ai', role: 'Agronomist'),
    _MockUser(id: 'U007', name: 'Khaled Nasser', email: 'khaled@smartfarm.ai', role: 'Researcher'),
    _MockUser(id: 'U008', name: 'Dina Farouk', email: 'dina@smartfarm.ai', role: 'Farmer'),
  ];

  List<_MockUser> get _filtered => _users.where((u) {
        final matchSearch = _searchQuery.isEmpty ||
            u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            u.email.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchRole = _filterRole == 'All' || u.role == _filterRole;
        return matchSearch && matchRole;
      }).toList();

  // ── Actions ───────────────────────────────────────────────────────────────

  void _toggleActive(_MockUser user) {
    setState(() => user.isActive = !user.isActive);
    final msg = user.isActive ? 'User activated.' : 'User deactivated.';
    _showSnack(msg, user.isActive ? const Color(0xFF4CAF50) : const Color(0xFFFF9800));
  }

  void _deleteUser(_MockUser user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete User'),
        content: Text('Permanently delete ${user.name}? This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              setState(() => _users.remove(user));
              Navigator.pop(ctx);
              _showSnack('${user.name} deleted.', const Color(0xFFEF4444));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final users = _filtered;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User Management',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937))),
                  SizedBox(height: 4),
                  Text('Manage platform users — deactivate or remove accounts.',
                      style:
                          TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                ],
              ),
              // Total badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${_users.length} users',
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filters row
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildSearchBox(),
              _buildRoleFilter(),
            ],
          ),
          const SizedBox(height: 20),

          // Summary chips
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _summaryChip('Total', _users.length, const Color(0xFF4CAF50)),
              _summaryChip('Active',
                  _users.where((u) => u.isActive).length, const Color(0xFF2196F3)),
              _summaryChip('Inactive',
                  _users.where((u) => !u.isActive).length, const Color(0xFFFF9800)),
            ],
          ),
          const SizedBox(height: 20),

          // Table
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withOpacity(0.06)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2))
              ],
            ),
            child: users.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                        child: Text('No users found.',
                            style: TextStyle(color: Color(0xFF9CA3AF)))),
                  )
                : Column(
                    children: [
                      _buildTableHeader(),
                      ...users.asMap().entries.map((e) =>
                          _buildUserRow(e.value, e.key == users.length - 1)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return SizedBox(
      width: 240,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withOpacity(0.1)),
        ),
        child: TextField(
          onChanged: (v) => setState(() => _searchQuery = v),
          style: const TextStyle(fontSize: 13),
          decoration: const InputDecoration(
            hintText: 'Search users…',
            hintStyle:
                TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
            prefixIcon:
                Icon(Icons.search, size: 18, color: Color(0xFF9CA3AF)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleFilter() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _filterRole,
          icon: const Icon(Icons.keyboard_arrow_down,
              size: 16, color: Color(0xFF6B7280)),
          style: const TextStyle(
              fontSize: 13, color: Color(0xFF1F2937)),
          items: _roles
              .map((r) =>
                  DropdownMenuItem(value: r, child: Text(r)))
              .toList(),
          onChanged: (v) => setState(() => _filterRole = v!),
        ),
      ),
    );
  }

  Widget _summaryChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('$label: $count',
          style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
            bottom:
                BorderSide(color: Colors.black.withOpacity(0.06))),
      ),
      child: Row(
        children: const [
          Expanded(
              flex: 3,
              child: _HeaderCell('USER')),
          Expanded(
              flex: 2,
              child: _HeaderCell('ROLE')),
          Expanded(
              flex: 2,
              child: _HeaderCell('STATUS')),
          SizedBox(width: 140, child: _HeaderCell('ACTIONS')),
        ],
      ),
    );
  }

  Widget _buildUserRow(_MockUser user, bool isLast) {
    final colors = [
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFF9C27B0),
      const Color(0xFFFF9800),
      const Color(0xFFF44336),
    ];
    final idx = _users.indexOf(user) % colors.length;
    final avatarColor = colors[idx];
    final initials =
        user.name.split(' ').map((p) => p[0]).take(2).join();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                    color: Colors.black.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          // User info
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: avatarColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(initials,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: avatarColor)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1F2937))),
                      Text(user.email,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF))),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Role
          Expanded(
            flex: 2,
            child: Container(
              width: 80,
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _roleColor(user.role).withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(user.role,
                  style: TextStyle(
                      fontSize: 12,
                      color: _roleColor(user.role),
                      fontWeight: FontWeight.w500)),
            ),
          ),

          // Status
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: user.isActive
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF9CA3AF),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  user.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                      fontSize: 12,
                      color: user.isActive
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ),

          // Actions
          SizedBox(
            width: 140,
            child: Row(
              children: [
                // Deactivate / Activate
                Tooltip(
                  message: user.isActive ? 'Deactivate' : 'Activate',
                  child: InkWell(
                    onTap: () => _toggleActive(user),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: user.isActive
                            ? const Color(0xFFFFF3E0)
                            : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        user.isActive
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                        size: 16,
                        color: user.isActive
                            ? const Color(0xFFFF9800)
                            : const Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Delete
                Tooltip(
                  message: 'Delete user',
                  child: InkWell(
                    onTap: () => _deleteUser(user),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.delete_outline,
                          size: 16, color: Color(0xFFEF4444)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'Agronomist':
        return const Color(0xFF2196F3);
      case 'Researcher':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF4CAF50);
    }
  }
}

// ── Small helper widget ───────────────────────────────────────────────────────

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
            letterSpacing: 0.8));
  }
}
