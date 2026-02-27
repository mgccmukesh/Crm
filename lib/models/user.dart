class User {
  final int id;
  final String name;
  final String email;
  final int vendorId;
  final String? vendorName;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.vendorId,
    this.vendorName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      vendorId: json['vendor_id'] ?? 0,
      vendorName: json['vendor_name'],
    );
  }
}
