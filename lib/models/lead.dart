class Lead {
  final int id;
  final String uuid;
  final String name;
  final String phone;
  final String? email;
  final String? city;
  final String status;
  final String? source;
  final bool isStarred;
  final DateTime? lastActivityAt;
  final DateTime createdAt;
  final List<dynamic>? notes;
  final List<dynamic>? callLogs;

  Lead({
    required this.id,
    required this.uuid,
    required this.name,
    required this.phone,
    this.email,
    this.city,
    required this.status,
    this.source,
    required this.isStarred,
    this.lastActivityAt,
    required this.createdAt,
    this.notes,
    this.callLogs,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      city: json['city'],
      status: json['status'] ?? 'new',
      source: json['source'],
      isStarred: json['is_starred'] ?? false,
      lastActivityAt: json['last_activity_at'] != null
          ? DateTime.parse(json['last_activity_at'])
          : null,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      notes: json['notes'],
      callLogs: json['call_logs'],
    );
  }

  String get statusColor {
    switch (status.toLowerCase()) {
      case 'new':
        return '4CAF50';
      case 'contacted':
        return '2196F3';
      case 'qualified':
        return 'FF9800';
      case 'converted':
        return '9C27B0';
      case 'lost':
        return 'F44336';
      default:
        return '757575';
    }
  }

  String get sourceColor {
    switch (source?.toLowerCase() ?? '') {
      case 'website':
        return '3F51B5';
      case 'referral':
        return '00BCD4';
      case 'whatsapp':
        return '4CAF50';
      case 'mobile_app':
        return 'FF5722';
      default:
        return '9E9E9E';
    }
  }

  String get initials {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
