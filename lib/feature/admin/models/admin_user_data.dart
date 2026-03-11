/// Represents a single user row in the User Management table.
class AdminUserData {
  final String name, email, role, status, joined, lastLogin;
  final int    requests;

  const AdminUserData({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.joined,
    required this.lastLogin,
    required this.requests,
  });
}
