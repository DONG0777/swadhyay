class UserProfile {
  final String id;
  final String? displayName;
  final String? phone;
  final String? city;
  final String? area;
  final String? avatarUrl;
  final String languageCode;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.id,
    this.displayName,
    this.phone,
    this.city,
    this.area,
    this.avatarUrl,
    this.languageCode = 'bn',
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      displayName: map['display_name'] as String?,
      phone: map['phone'] as String?,
      city: map['city'] as String?,
      area: map['area'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      languageCode: map['language_code'] as String? ?? 'bn',
      isActive: map['is_active'] as bool? ?? true,
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
      'id': id,
      'display_name': displayName,
      'phone': phone,
      'city': city,
      'area': area,
      'avatar_url': avatarUrl,
      'language_code': languageCode,
      'is_active': isActive,
    };
  }
}
