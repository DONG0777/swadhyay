class CommunityRoutine {
  final String id;
  final String placeId;
  final String createdBy;
  final int weekday;
  final String startTime;
  final int durationMinutes;
  final String title;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CommunityRoutine({
    required this.id,
    required this.placeId,
    required this.createdBy,
    required this.weekday,
    required this.startTime,
    required this.durationMinutes,
    required this.title,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory CommunityRoutine.fromMap(Map<String, dynamic> map) {
    return CommunityRoutine(
      id: map['id'] as String,
      placeId: map['place_id'] as String,
      createdBy: map['created_by'] as String,
      weekday: map['weekday'] as int,
      startTime: map['start_time'] as String,
      durationMinutes: map['duration_minutes'] as int,
      title: map['title'] as String,
      isActive: map['is_active'] as bool,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
    );
  }
}
