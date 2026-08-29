class DailyCommitment {
  final String id;
  final String userId;
  final DateTime commitmentDate;
  final String commitmentText;
  final String status;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DailyCommitment({
    required this.id,
    required this.userId,
    required this.commitmentDate,
    required this.commitmentText,
    required this.status,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  bool get isCompleted => status == 'completed';

  factory DailyCommitment.fromMap(Map<String, dynamic> map) {
    return DailyCommitment(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      commitmentDate:
          DateTime.parse(map['commitment_date'] as String),
      commitmentText: map['commitment_text'] as String,
      status: map['status'] as String,
      completedAt: map['completed_at'] != null
          ? DateTime.tryParse(map['completed_at'] as String)
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
