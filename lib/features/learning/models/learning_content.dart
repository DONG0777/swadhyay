class LearningContent {
  final String id;
  final String contentKind;
  final String category;
  final String? sourceTitle;
  final String? sourceAuthor;
  final String? sourceReference;
  final String? sourceUrl;
  final int estimatedMinutes;
  final String difficulty;
  final DateTime? publishedAt;

  const LearningContent({
    required this.id,
    required this.contentKind,
    required this.category,
    this.sourceTitle,
    this.sourceAuthor,
    this.sourceReference,
    this.sourceUrl,
    required this.estimatedMinutes,
    required this.difficulty,
    this.publishedAt,
  });

  factory LearningContent.fromMap(Map<String, dynamic> map) {
    return LearningContent(
      id: map['id'] as String,
      contentKind: map['content_kind'] as String,
      category: map['category'] as String,
      sourceTitle: map['source_title'] as String?,
      sourceAuthor: map['source_author'] as String?,
      sourceReference: map['source_reference'] as String?,
      sourceUrl: map['source_url'] as String?,
      estimatedMinutes: (map['estimated_minutes'] as num).toInt(),
      difficulty: map['difficulty'] as String,
      publishedAt: map['published_at'] == null
          ? null
          : DateTime.parse(map['published_at'] as String),
    );
  }
}
