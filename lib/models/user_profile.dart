class UserProfile {
  final String id;
  final String? phone;
  final String? area;
  final String? bloodGroup;
  final String? displayName;
  final String? email;
  final Map<String, dynamic>? otherData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    this.phone,
    this.area,
    this.bloodGroup,
    this.displayName,
    this.email,
    this.otherData,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      phone: json['phone'],
      area: json['area'],
      bloodGroup: json['blood_group'],
      displayName: json['display_name'],
      email: json['email'],
      otherData: json['other_data'] ?? {},
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'area': area,
      'blood_group': bloodGroup,
      'display_name': displayName,
      'email': email,
      'other_data': otherData,
    };
  }

  bool get isComplete {
    return phone != null && phone!.isNotEmpty &&
           area != null && area!.isNotEmpty &&
           bloodGroup != null && bloodGroup!.isNotEmpty;
  }
}
