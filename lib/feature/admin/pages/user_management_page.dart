import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/feature/admin/models/user_data.dart';
import 'package:smart_farm/feature/admin/widgets/admin_stat_cards.dart';
import 'package:smart_farm/feature/admin/widgets/user_list_table.dart';
import 'package:smart_farm/feature/admin/widgets/admin_forms.dart';

// ─────────────────────────────────────────────────────────────────────────────
// UserManagementPage  —  thin page; all table/form logic lives in widgets.
// ─────────────────────────────────────────────────────────────────────────────
class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  // Sample dataset (in production, inject from a repository / provider)
  static const List<UserData> _users = [
    UserData(id: 'USR001', name: 'Ahmed Hassan',   email: 'ahmed@smartfarm.ai',   role: 'Farmer',     status: 'Active',    joined: 'Jan 12, 2025', lastLogin: '2 hrs ago',    requests: 234),
    UserData(id: 'USR002', name: 'Sara Mohamed',   email: 'sara@smartfarm.ai',    role: 'Agronomist', status: 'Active',    joined: 'Feb 3, 2025',  lastLogin: '1 day ago',    requests: 512),
    UserData(id: 'USR003', name: 'Omar Khalil',    email: 'omar@smartfarm.ai',    role: 'Researcher', status: 'Active',    joined: 'Mar 7, 2025',  lastLogin: '3 hrs ago',    requests: 891),
    UserData(id: 'USR004', name: 'Nour Ali',       email: 'nour@smartfarm.ai',    role: 'Farmer',     status: 'Inactive',  joined: 'Jan 28, 2025', lastLogin: '2 weeks ago',  requests: 45),
    UserData(id: 'USR005', name: 'Mahmoud Samy',   email: 'mahmoud@smartfarm.ai', role: 'Farmer',     status: 'Active',    joined: 'Apr 1, 2025',  lastLogin: '5 min ago',    requests: 178),
    UserData(id: 'USR006', name: 'Laila Ibrahim',  email: 'laila@smartfarm.ai',   role: 'Agronomist', status: 'Suspended', joined: 'Feb 14, 2025', lastLogin: '1 month ago',  requests: 67),
    UserData(id: 'USR007', name: 'Khaled Nasser',  email: 'khaled@smartfarm.ai',  role: 'Researcher', status: 'Active',    joined: 'Mar 19, 2025', lastLogin: '6 hrs ago',    requests: 1203),
    UserData(id: 'USR008', name: 'Dina Farouk',    email: 'dina@smartfarm.ai',    role: 'Farmer',     status: 'Active',    joined: 'Apr 10, 2025', lastLogin: '30 min ago',   requests: 89),
  ];

  static List<StatCardData> _buildSummaryCards(List<UserData> users) => [
    StatCardData(
      label:     'Total Users',
      value:     '${users.length}',
      icon:      Icons.people_outline,
      iconColor: AppColors.primary,
      iconBg:    AppColors.primarySurface,
    ),
    StatCardData(
      label:     'Active',
      value:     '${users.where((u) => u.status == 'Active').length}',
      icon:      Icons.check_circle_outline,
      iconColor: AppColors.info,
      iconBg:    Color(0xFFE3F2FD),
    ),
    StatCardData(
      label:     'Inactive',
      value:     '${users.where((u) => u.status == 'Inactive').length}',
      icon:      Icons.pause_circle_outline,
      iconColor: AppColors.warning,
      iconBg:    Color(0xFFFFF3E0),
    ),
    StatCardData(
      label:     'Admins',
      value:     '${users.where((u) => u.status == 'Suspended').length}',
      icon:      Icons.block_outlined,
      iconColor: AppColors.error,
      iconBg:    Color(0xFFFEF2F2),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page header + action button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User Management', style: AppTextStyles.pageTitle),
                    SizedBox(height: 4),
                    Text('Manage and monitor all platform users',
                        style: AppTextStyles.pageSubtitle),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => AdminForms.showAddUser(context),
                icon:  const Icon(Icons.person_add_outlined, size: 18),
                label: const Text('Add User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation:       0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Summary cards (Wrap — no overflow)
          AdminStatCards(cards: _buildSummaryCards(_users)),
          const SizedBox(height: 20),

          // Filterable table
          UserListTable(users: _users),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
