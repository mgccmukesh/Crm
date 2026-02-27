class LeadNote {
  final int id;
  final String note;
  final String userName;
  final DateTime createdAt;

  LeadNote({
    required this.id,
    required this.note,
    required this.userName,
    required this.createdAt,
  });

  factory LeadNote.fromJson(Map<String, dynamic> json) {
    return LeadNote(
      id: json['id'] ?? 0,
      note: json['note'] ?? '',
      userName: json['user']?['name'] ?? 'Unknown',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
