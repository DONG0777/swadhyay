class CommunityPlace {
  final String id;
  final String createdBy;
  final String name;
  final String? description;
  final String address;
  final String timezone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CommunityPlace({
    required this.id,
    required this.createdBy,
    required this.name,
    this.description,
    required this.address,
    required this.timezone,
    this.createdAt,
    this.updatedAt,
  });

  factory CommunityPlace.fromMap(Map<String, dynamic> map) {
    return CommunityPlace(
      id: map['id'] as String,
      createdBy: map['created_by'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      address: map['address'] as String,
      timezone: map['timezone'] as String,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
    );
  }
}
