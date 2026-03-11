/// Immutable data class representing a platform user.
/// Used by UserListTable and UserManagementPage.
class UserData {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final String joined;
  final String lastLogin;
  final int    requests;

  const UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.joined,
    required this.lastLogin,
    required this.requests,
  });

  /// Returns initials from [name] (up to 2 characters).
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  /// Creates a copy with overridden fields.
  UserData copyWith({
    String? id, String? name, String? email, String? role,
    String? status, String? joined, String? lastLogin, int? requests,
  }) => UserData(
    id:        id        ?? this.id,
    name:      name      ?? this.name,
    email:     email     ?? this.email,
    role:      role      ?? this.role,
    status:    status    ?? this.status,
    joined:    joined    ?? this.joined,
    lastLogin: lastLogin ?? this.lastLogin,
    requests:  requests  ?? this.requests,
  );
}
