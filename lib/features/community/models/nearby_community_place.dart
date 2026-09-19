class NearbyCommunityPlace {
  final String id;
  final String name;
  final String? description;
  final String address;
  final String timezone;
  final double distanceMeters;

  const NearbyCommunityPlace({
    required this.id,
    required this.name,
    this.description,
    required this.address,
    required this.timezone,
    required this.distanceMeters,
  });

  factory NearbyCommunityPlace.fromMap(
    Map<String, dynamic> map,
  ) {
    return NearbyCommunityPlace(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      address: map['address'] as String,
      timezone: map['timezone'] as String,
      distanceMeters:
          (map['distance_meters'] as num).toDouble(),
    );
  }

}
