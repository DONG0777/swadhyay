class SuryaNamaskarTranslation {
  final String id;
  final String suryaNamaskarId;
  final String languageCode;
  final String title;
  final String? mantra;
  final String? description;
  final String? instructions;
  final String? benefits;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SuryaNamaskarTranslation({
    required this.id,
    required this.suryaNamaskarId,
    required this.languageCode,
    required this.title,
    this.mantra,
    this.description,
    this.instructions,
    this.benefits,
    this.createdAt,
    this.updatedAt,
  });

  factory SuryaNamaskarTranslation.fromMap(Map<String, dynamic> map) {
    return SuryaNamaskarTranslation(
      id: map['id'] as String,
      suryaNamaskarId: map['surya_namaskar_id'] as String,
      languageCode: map['language_code'] as String,
      title: map['title'] as String,
      mantra: map['mantra'] as String?,
      description: map['description'] as String?,
      instructions: map['instructions'] as String?,
      benefits: map['benefits'] as String?,
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
      'surya_namaskar_id': suryaNamaskarId,
      'language_code': languageCode,
      'title': title,
      'mantra': mantra,
      'description': description,
      'instructions': instructions,
      'benefits': benefits,
    };
  }
}
