class Circle {
  final String id;
  final String name;
  final String description;
  final String inviteCode;
  final String createdBy;
  final List<String> members;
  final Map<String, int> leaderboard; // userId -> xp
  final DateTime createdAt;

  Circle({
    required this.id,
    required this.name,
    required this.description,
    required this.inviteCode,
    required this.createdBy,
    required this.members,
    required this.leaderboard,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'invite_code': inviteCode,
        'created_by': createdBy,
        'members': members,
        'leaderboard': leaderboard,
        'created_at': createdAt.toIso8601String(),
      };

  factory Circle.fromJson(Map<String, dynamic> json) => Circle(
        id: json['id'],
        name: json['name'],
        description: json['description'] ?? '',
        inviteCode: json['invite_code'],
        createdBy: json['created_by'],
        members: List<String>.from(json['members'] ?? []),
        leaderboard: Map<String, int>.from(json['leaderboard'] ?? {}),
        createdAt: DateTime.parse(json['created_at']),
      );
}
