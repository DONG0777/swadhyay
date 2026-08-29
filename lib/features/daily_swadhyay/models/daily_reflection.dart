class DailyReflection {
  final String id;
  final String userId;
  final String commitmentId;
  final DateTime reflectionDate;
  final String? egoReflection;
  final String? idealGapReflection;
  final String? learningReflection;
  final String? obstacleReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DailyReflection({
    required this.id,
    required this.userId,
    required this.commitmentId,
    required this.reflectionDate,
    this.egoReflection,
    this.idealGapReflection,
    this.learningReflection,
    this.obstacleReason,
    this.createdAt,
    this.updatedAt,
  });

  factory DailyReflection.fromMap(Map<String, dynamic> map) {
    return DailyReflection(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      commitmentId: map['commitment_id'] as String,
      reflectionDate: DateTime.parse(map['reflection_date'] as String),
      egoReflection: map['ego_reflection'] as String?,
      idealGapReflection: map['ideal_gap_reflection'] as String?,
      learningReflection: map['learning_reflection'] as String?,
      obstacleReason: map['obstacle_reason'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'commitment_id': commitmentId,
      'reflection_date': _dateOnly(reflectionDate),
      'ego_reflection': egoReflection,
      'ideal_gap_reflection': idealGapReflection,
      'learning_reflection': learningReflection,
      'obstacle_reason': obstacleReason,
    };
  }

  String _dateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
