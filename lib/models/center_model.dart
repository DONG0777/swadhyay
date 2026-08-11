class CenterModel {
  final String? id;
  final String name;
  final String centerType; // family, social, universal
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? meetingTime; // "06:00:00"
  final String? createdBy;
  final String? createdAt;

  CenterModel({
    this.id,
    required this.name,
    required this.centerType,
    this.address,
    this.latitude,
    this.longitude,
    this.meetingTime,
    this.createdBy,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'center_type': centerType,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'meeting_time': meetingTime,
        'created_by': createdBy,
        'created_at': createdAt,
      };

  factory CenterModel.fromJson(Map<String, dynamic> json) => CenterModel(
        id: json['id'],
        name: json['name'],
        centerType: json['center_type'],
        address: json['address'],
        latitude: json['latitude']?.toDouble(),
        longitude: json['longitude']?.toDouble(),
        meetingTime: json['meeting_time'],
        createdBy: json['created_by'],
        createdAt: json['created_at'],
      );
}
