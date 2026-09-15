class CommunityAgendaItemTranslation {
  final String languageCode;
  final String title;
  final String? description;

  const CommunityAgendaItemTranslation({
    required this.languageCode,
    required this.title,
    this.description,
  });

  factory CommunityAgendaItemTranslation.fromMap(
    Map<String, dynamic> map,
  ) {
    return CommunityAgendaItemTranslation(
      languageCode: map['language_code'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
    );
  }
}

class CommunityAgendaItem {
  final String id;
  final String sessionId;
  final int sequenceNumber;
  final String activityType;
  final String title;
  final String? description;
  final int durationMinutes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, CommunityAgendaItemTranslation> translations;

  const CommunityAgendaItem({
    required this.id,
    required this.sessionId,
    required this.sequenceNumber,
    required this.activityType,
    required this.title,
    this.description,
    required this.durationMinutes,
    this.createdAt,
    this.updatedAt,
    this.translations = const {},
  });

  factory CommunityAgendaItem.fromMap(
    Map<String, dynamic> map, {
    Map<String, CommunityAgendaItemTranslation> translations = const {},
  }) {
    return CommunityAgendaItem(
      id: map['id'] as String,
      sessionId: map['session_id'] as String,
      sequenceNumber: map['sequence_number'] as int,
      activityType: map['activity_type'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      durationMinutes: map['duration_minutes'] as int,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
      translations: translations,
    );
  }

  String titleFor(String languageCode) {
    return translations[languageCode]?.title ?? title;
  }

  String? descriptionFor(String languageCode) {
    return translations[languageCode]?.description ?? description;
  }
}
