class CommunitySession {
  final String id;
  final String createdBy;
  final String title;
  final String? description;
  final String locationName;
  final String? locationDetails;
  final DateTime startsAt;
  final DateTime endsAt;
  final int? capacity;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CommunitySession({
    required this.id,
    required this.createdBy,
    required this.title,
    this.description,
    required this.locationName,
    this.locationDetails,
    required this.startsAt,
    required this.endsAt,
    this.capacity,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  bool get isPlanned => status == 'planned';
  bool get isCancelled => status == 'cancelled';
  bool get isCompleted => status == 'completed';

  factory CommunitySession.fromMap(Map<String, dynamic> map) {
    return CommunitySession(
      id: map['id'] as String,
      createdBy: map['created_by'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      locationName: map['location_name'] as String,
      locationDetails: map['location_details'] as String?,
      startsAt: DateTime.parse(map['starts_at'] as String),
      endsAt: DateTime.parse(map['ends_at'] as String),
      capacity: map['capacity'] as int?,
      status: map['status'] as String,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
    );
  }
}
