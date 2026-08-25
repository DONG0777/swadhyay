class SuryaNamaskar {
  final String id;
  final int stepNumber;
  final String title;
  final String? mantra;
  final String? description;
  final String? imageUrl;
  final String languageCode;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SuryaNamaskar({
    required this.id,
    required this.stepNumber,
    required this.title,
    this.mantra,
    this.description,
    this.imageUrl,
    required this.languageCode,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory SuryaNamaskar.fromMap(Map<String, dynamic> map) {
    return SuryaNamaskar(
      id: map['id'] as String,
      stepNumber: map['step_number'] as int,
      title: map['title'] as String,
      mantra: map['mantra'] as String?,
      description: map['description'] as String?,
      imageUrl: map['image_url'] as String?,
      languageCode: map['language_code'] as String,
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
      'step_number': stepNumber,
      'title': title,
      'mantra': mantra,
      'description': description,
      'image_url': imageUrl,
      'language_code': languageCode,
      'is_active': isActive,
    };
  }
}
