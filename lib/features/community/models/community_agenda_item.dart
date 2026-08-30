class CommunityAgendaItem {
  final String id;
  final String sessionId;
  final int sequenceNumber;
  final String activityType;
  final String title;
  final String? description;
  final int durationMinutes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CommunityAgendaItem({
    required this.id,
    required this.sessionId,
    required this.sequenceNumber,
    required this.activityType,
    required this.title,
    this.description,
    required this.durationMinutes,
    this.createdAt,
    this.updatedAt,
  });

  factory CommunityAgendaItem.fromMap(Map<String, dynamic> map) {
    return CommunityAgendaItem(
      id: map['id'] as String,
      sessionId: map['session_id'] as String,
      sequenceNumber: map['sequence_number'] as int,
      activityType: map['activity_type'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      durationMinutes: map['duration_minutes'] as int,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
    );
  }
}
