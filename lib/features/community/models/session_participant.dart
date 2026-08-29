class SessionParticipant {
  final String sessionId;
  final String userId;
  final DateTime joinedAt;
  final String attendanceStatus;
  final DateTime? attendedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SessionParticipant({
    required this.sessionId,
    required this.userId,
    required this.joinedAt,
    required this.attendanceStatus,
    this.attendedAt,
    this.createdAt,
    this.updatedAt,
  });

  bool get isPending => attendanceStatus == 'pending';
  bool get isAttended => attendanceStatus == 'attended';
  bool get isAbsent => attendanceStatus == 'absent';

  factory SessionParticipant.fromMap(Map<String, dynamic> map) {
    return SessionParticipant(
      sessionId: map['session_id'] as String,
      userId: map['user_id'] as String,
      joinedAt: DateTime.parse(map['joined_at'] as String),
      attendanceStatus: map['attendance_status'] as String,
      attendedAt: map['attended_at'] != null
          ? DateTime.tryParse(map['attended_at'] as String)
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
    );
  }
}
