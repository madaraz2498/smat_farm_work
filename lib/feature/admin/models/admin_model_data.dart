/// Represents a deployed AI model entry in the System Management table.
class AdminModelData {
  final String name, version, type, accuracy;

  const AdminModelData({
    required this.name,
    required this.version,
    required this.type,
    required this.accuracy,
  });
}
