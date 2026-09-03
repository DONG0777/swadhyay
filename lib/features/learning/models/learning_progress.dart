class LearningProgress {
  final String id;
  final String userId;
  final String learningContentId;
  final String status;
  final DateTime completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LearningProgress({
    required this.id,
    required this.userId,
    required this.learningContentId,
    required this.status,
    required this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isCompleted => status == 'completed';

  factory LearningProgress.fromMap(Map<String, dynamic> map) {
    return LearningProgress(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      learningContentId: map['learning_content_id'] as String,
      status: map['status'] as String,
      completedAt: DateTime.parse(map['completed_at'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
