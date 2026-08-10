class ChallengeDay {
  final int day;
  final String title;
  final String description;
  bool isCompleted;
  bool isUnlocked;

  ChallengeDay({
    required this.day,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.isUnlocked = false,
  });

  Map<String, dynamic> toJson() => {
        'day': day,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
        'isUnlocked': isUnlocked,
      };

  factory ChallengeDay.fromJson(Map<String, dynamic> json) => ChallengeDay(
        day: json['day'],
        title: json['title'],
        description: json['description'],
        isCompleted: json['isCompleted'] ?? false,
        isUnlocked: json['isUnlocked'] ?? false,
      );
}
