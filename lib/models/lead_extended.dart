import 'lead.dart';
import 'lead_note.dart';

class LeadExtended extends Lead {
  final List<LeadNote>? notes;
  final List<dynamic>? callLogs;

  LeadExtended({
    required super.id,
    required super.uuid,
    required super.name,
    required super.phone,
    super.email,
    super.city,
    required super.status,
    super.source,
    required super.isStarred,
    super.lastActivityAt,
    required super.createdAt,
    this.notes,
    this.callLogs,
  });

  factory LeadExtended.fromJson(Map<String, dynamic> json) {
    final lead = Lead.fromJson(json);
    
    List<LeadNote>? notes;
    if (json['notes'] != null) {
      notes = (json['notes'] as List)
          .map((n) => LeadNote.fromJson(n))
          .toList();
    }

    return LeadExtended(
      id: lead.id,
      uuid: lead.uuid,
      name: lead.name,
      phone: lead.phone,
      email: lead.email,
      city: lead.city,
      status: lead.status,
      source: lead.source,
      isStarred: lead.isStarred,
      lastActivityAt: lead.lastActivityAt,
      createdAt: lead.createdAt,
      notes: notes,
      callLogs: json['call_logs'],
    );
  }
}
