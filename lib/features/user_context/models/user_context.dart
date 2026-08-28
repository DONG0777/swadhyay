class UserContext {
  final String userId;
  final String? currentSituation;
  final String? biggestNeed;
  final int? availableTimeMinutes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserContext({
    required this.userId,
    this.currentSituation,
    this.biggestNeed,
    this.availableTimeMinutes,
    this.createdAt,
    this.updatedAt,
  });

  factory UserContext.fromMap(Map<String, dynamic> map) {
    return UserContext(
      userId: map['user_id'] as String,
      currentSituation: map['current_situation'] as String?,
      biggestNeed: map['biggest_need'] as String?,
      availableTimeMinutes:
          map['available_time_minutes'] as int?,
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
      'user_id': userId,
      'current_situation': currentSituation,
      'biggest_need': biggestNeed,
      'available_time_minutes': availableTimeMinutes,
    };
  }
}
