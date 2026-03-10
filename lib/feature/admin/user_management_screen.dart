import 'package:flutter/material.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _searchQuery = '';
  String _selectedRole = 'All';
  String _selectedStatus = 'All';
  int _selectedUserIndex = -1;

  final List<String> _roles = ['All', 'Farmer', 'Agronomist', 'Researcher', 'Admin'];
  final List<String> _statuses = ['All', 'Active', 'Inactive', 'Suspended'];

  final List<_UserData> _users = [
    _UserData(id: 'USR001', name: 'Ahmed Hassan', email: 'ahmed@smartfarm.ai', role: 'Farmer', status: 'Active', joined: 'Jan 12, 2025', lastLogin: '2 hrs ago', requests: 234),
    _UserData(id: 'USR002', name: 'Sara Mohamed', email: 'sara@smartfarm.ai', role: 'Agronomist', status: 'Active', joined: 'Feb 3, 2025', lastLogin: '1 day ago', requests: 512),
    _UserData(id: 'USR003', name: 'Omar Khalil', email: 'omar@smartfarm.ai', role: 'Researcher', status: 'Active', joined: 'Mar 7, 2025', lastLogin: '3 hrs ago', requests: 891),
    _UserData(id: 'USR004', name: 'Nour Ali', email: 'nour@smartfarm.ai', role: 'Farmer', status: 'Inactive', joined: 'Jan 28, 2025', lastLogin: '2 weeks ago', requests: 45),
    _UserData(id: 'USR005', name: 'Mahmoud Samy', email: 'mahmoud@smartfarm.ai', role: 'Farmer', status: 'Active', joined: 'Apr 1, 2025', lastLogin: '5 min ago', requests: 178),
    _UserData(id: 'USR006', name: 'Laila Ibrahim', email: 'laila@smartfarm.ai', role: 'Agronomist', status: 'Suspended', joined: 'Feb 14, 2025', lastLogin: '1 month ago', requests: 67),
    _UserData(id: 'USR007', name: 'Khaled Nasser', email: 'khaled@smartfarm.ai', role: 'Researcher', status: 'Active', joined: 'Mar 19, 2025', lastLogin: '6 hrs ago', requests: 1203),
    _UserData(id: 'USR008', name: 'Dina Farouk', email: 'dina@smartfarm.ai', role: 'Farmer', status: 'Active', joined: 'Apr 10, 2025', lastLogin: '30 min ago', requests: 89),
  ];

  List<_UserData> get _filteredUsers {
    return _users.where((u) {
      final matchSearch = _searchQuery.isEmpty ||
          u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchRole = _selectedRole == 'All' || u.role == _selectedRole;
      final matchStatus = _selectedStatus == 'All' || u.status == _selectedStatus;
      return matchSearch && matchRole && matchStatus;
    }).toList();
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
                  const SizedBox(height: 20),
                  _buildSummaryCards(),
                  const SizedBox(height: 20),
                  _buildFiltersRow(),
                  const SizedBox(height: 16),
                  _buildUsersTable(),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('User Management', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
            SizedBox(height: 4),
            Text('Manage and monitor all platform users', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddUserDialog(context),
          icon: const Icon(Icons.person_add_outlined, size: 18),
          label: const Text('Add User'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    final summaries = [
      ('Total Users', '${_users.length}', Icons.people_outline, const Color(0xFF4CAF50), const Color(0xFFE8F5E9)),
      ('Active', '${_users.where((u) => u.status == 'Active').length}', Icons.check_circle_outline, const Color(0xFF2196F3), const Color(0xFFE3F2FD)),
      ('Inactive', '${_users.where((u) => u.status == 'Inactive').length}', Icons.pause_circle_outline, const Color(0xFFFF9800), const Color(0xFFFFF3E0)),
      ('Suspended', '${_users.where((u) => u.status == 'Suspended').length}', Icons.block_outlined, const Color(0xFFEF4444), const Color(0xFFFEF2F2)),
    ];

    return LayoutBuilder(builder: (ctx, constraints) {
      final cols = constraints.maxWidth > 700 ? 4 : 2;
      return Wrap(
        spacing: 14,
        runSpacing: 14,
        children: summaries.map((s) {
          final cardWidth = (constraints.maxWidth - (cols - 1) * 14) / cols;
          return SizedBox(
            width: cardWidth,
            child: Container(
              padding: const EdgeInsets.all(16),
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
                    decoration: BoxDecoration(color: s.$5, borderRadius: BorderRadius.circular(8)),
                    child: Icon(s.$3, color: s.$4, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.$2, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                      Text(s.$1, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
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

  Widget _buildFiltersRow() {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Search
        SizedBox(
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
                hintText: 'Search users...',
                hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                prefixIcon: Icon(Icons.search, size: 18, color: Color(0xFF9CA3AF)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        // Role filter
        _buildDropdownFilter('Role', _roles, _selectedRole, (v) => setState(() => _selectedRole = v!)),
        // Status filter
        _buildDropdownFilter('Status', _statuses, _selectedStatus, (v) => setState(() => _selectedStatus = v!)),
      ],
    );
  }

  Widget _buildDropdownFilter(String label, List<String> items, String value, ValueChanged<String?> onChanged) {
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
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF6B7280)),
          style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildUsersTable() {
    final users = _filteredUsers;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.06))),
            ),
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text('USER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF6B7280), letterSpacing: 0.8))),
                Expanded(flex: 2, child: Text('ROLE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF6B7280), letterSpacing: 0.8))),
                Expanded(flex: 2, child: Text('STATUS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF6B7280), letterSpacing: 0.8))),
                Expanded(flex: 2, child: Text('LAST LOGIN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF6B7280), letterSpacing: 0.8))),
                Expanded(flex: 1, child: Text('REQUESTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF6B7280), letterSpacing: 0.8))),
                SizedBox(width: 80, child: Text('ACTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF6B7280), letterSpacing: 0.8))),
              ],
            ),
          ),
          if (users.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: Text('No users found', style: TextStyle(color: Color(0xFF9CA3AF)))),
            )
          else
            ...users.asMap().entries.map((entry) => _buildUserRow(entry.value, entry.key, entry.key == users.length - 1)),
        ],
      ),
    );
  }

  Widget _buildUserRow(_UserData user, int index, bool isLast) {
    final avatarColors = [
      const Color(0xFF4CAF50), const Color(0xFF2196F3), const Color(0xFF9C27B0),
      const Color(0xFFFF9800), const Color(0xFFF44336), const Color(0xFF00BCD4),
    ];
    final color = avatarColors[index % avatarColors.length];
    final initials = user.name.split(' ').map((p) => p[0]).take(2).join();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.black.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          // User info
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                  child: Center(child: Text(initials, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2937))),
                      Text(user.email, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _roleColor(user.role).withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(user.role, style: TextStyle(fontSize: 12, color: _roleColor(user.role), fontWeight: FontWeight.w500)),
            ),
          ),
          // Status
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 7, height: 7,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(color: _statusColor(user.status), shape: BoxShape.circle),
                ),
                Text(user.status, style: TextStyle(fontSize: 12, color: _statusColor(user.status))),
              ],
            ),
          ),
          // Last login
          Expanded(flex: 2, child: Text(user.lastLogin, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)))),
          // Requests
          Expanded(flex: 1, child: Text('${user.requests}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2937)))),
          // Actions
          SizedBox(
            width: 80,
            child: Row(
              children: [
                InkWell(
                  onTap: () => _showUserDetail(context, user),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF6B7280)),
                  ),
                ),
                InkWell(
                  onTap: () => _showEditUser(context, user),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF6B7280)),
                  ),
                ),
                InkWell(
                  onTap: () => _confirmDelete(context, user),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.delete_outline, size: 16, color: Color(0xFFEF4444)),
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
      case 'Admin': return const Color(0xFFE65100);
      case 'Agronomist': return const Color(0xFF2196F3);
      case 'Researcher': return const Color(0xFF9C27B0);
      default: return const Color(0xFF4CAF50);
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Active': return const Color(0xFF4CAF50);
      case 'Inactive': return const Color(0xFF9CA3AF);
      case 'Suspended': return const Color(0xFFEF4444);
      default: return const Color(0xFF9CA3AF);
    }
  }

  void _showUserDetail(BuildContext context, _UserData user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(user.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Email', user.email),
            _detailRow('Role', user.role),
            _detailRow('Status', user.status),
            _detailRow('Joined', user.joined),
            _detailRow('Last Login', user.lastLogin),
            _detailRow('Total Requests', '${user.requests}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text('$label:', style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)))),
          Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showEditUser(BuildContext context, _UserData user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit User'),
        content: const Text('Edit user dialog would go here.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50)),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, _UserData user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () { setState(() => _users.remove(user)); Navigator.pop(ctx); },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add New User'),
        content: SizedBox(
          width: 340,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField('Full Name', 'Enter full name'),
              const SizedBox(height: 12),
              _buildDialogField('Email', 'Enter email address'),
              const SizedBox(height: 12),
              _buildDialogField('Password', 'Create password', obscure: true),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50)),
            child: const Text('Add User', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(String label, String hint, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF374151))),
        const SizedBox(height: 6),
        TextField(
          obscureText: obscure,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
            ),
          ),
        ),
      ],
    );
  }
}

class _UserData {
  final String id, name, email, role, status, joined, lastLogin;
  final int requests;
  _UserData({required this.id, required this.name, required this.email, required this.role, required this.status, required this.joined, required this.lastLogin, required this.requests});
}
