/// Represents a single user row in the User Management table.
class AdminUserData {
  final String name, status, joined,role ;
  final int    requests;

  const AdminUserData({
    required this.name,
    required this.status,
    required this.joined,
    required this.requests,
    required this.role,
  });
}
