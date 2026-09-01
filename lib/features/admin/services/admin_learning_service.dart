import 'package:supabase_flutter/supabase_flutter.dart';

class AdminLearningContentItem {
  final String id;
  final String contentKind;
  final String category;
  final String? sourceTitle;
  final String? sourceAuthor;
  final String? sourceReference;
  final String? sourceUrl;
  final int estimatedMinutes;
  final String difficulty;
  final String status;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AdminLearningContentItem({
    required this.id,
    required this.contentKind,
    required this.category,
    this.sourceTitle,
    this.sourceAuthor,
    this.sourceReference,
    this.sourceUrl,
    required this.estimatedMinutes,
    required this.difficulty,
    required this.status,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminLearningContentItem.fromMap(Map<String, dynamic> map) {
    return AdminLearningContentItem(
      id: map['id'] as String,
      contentKind: map['content_kind'] as String,
      category: map['category'] as String,
      sourceTitle: map['source_title'] as String?,
      sourceAuthor: map['source_author'] as String?,
      sourceReference: map['source_reference'] as String?,
      sourceUrl: map['source_url'] as String?,
      estimatedMinutes: (map['estimated_minutes'] as num).toInt(),
      difficulty: map['difficulty'] as String,
      status: map['status'] as String,
      publishedAt: map['published_at'] == null
          ? null
          : DateTime.parse(map['published_at'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}

class AdminLearningTranslation {
  final String languageCode;
  final String title;
  final String? summary;
  final String? body;
  final String? reflectionQuestion;
  final String? actionPrompt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AdminLearningTranslation({
    required this.languageCode,
    required this.title,
    this.summary,
    this.body,
    this.reflectionQuestion,
    this.actionPrompt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminLearningTranslation.fromMap(Map<String, dynamic> map) {
    return AdminLearningTranslation(
      languageCode: map['language_code'] as String,
      title: map['title'] as String,
      summary: map['summary'] as String?,
      body: map['body'] as String?,
      reflectionQuestion: map['reflection_question'] as String?,
      actionPrompt: map['action_prompt'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}

class AdminLearningService {
  final SupabaseClient _client;

  AdminLearningService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<String> createContent({
    required String contentKind,
    required String category,
    String? sourceTitle,
    String? sourceAuthor,
    String? sourceReference,
    String? sourceUrl,
    int estimatedMinutes = 5,
    String difficulty = 'easy',
  }) async {
    final result = await _client.rpc(
      'admin_create_learning_content',
      params: {
        'p_content_kind': contentKind,
        'p_category': category,
        'p_source_title': sourceTitle,
        'p_source_author': sourceAuthor,
        'p_source_reference': sourceReference,
        'p_source_url': sourceUrl,
        'p_estimated_minutes': estimatedMinutes,
        'p_difficulty': difficulty,
      },
    );

    return result as String;
  }

  Future<bool> updateContent({
    required String contentId,
    required String contentKind,
    required String category,
    String? sourceTitle,
    String? sourceAuthor,
    String? sourceReference,
    String? sourceUrl,
    int estimatedMinutes = 5,
    String difficulty = 'easy',
  }) async {
    final result = await _client.rpc(
      'admin_update_learning_content',
      params: {
        'p_content_id': contentId,
        'p_content_kind': contentKind,
        'p_category': category,
        'p_source_title': sourceTitle,
        'p_source_author': sourceAuthor,
        'p_source_reference': sourceReference,
        'p_source_url': sourceUrl,
        'p_estimated_minutes': estimatedMinutes,
        'p_difficulty': difficulty,
      },
    );

    return result == true;
  }

  Future<bool> setContentStatus({
    required String contentId,
    required String status,
  }) async {
    final result = await _client.rpc(
      'admin_set_learning_content_status',
      params: {
        'p_content_id': contentId,
        'p_status': status,
      },
    );

    return result == true;
  }

  Future<List<AdminLearningContentItem>> listContents({
    int limit = 50,
    int offset = 0,
  }) async {
    final result = await _client.rpc(
      'admin_list_learning_contents',
      params: {
        'p_limit': limit,
        'p_offset': offset,
      },
    );

    final rows = (result as List).cast<Map<String, dynamic>>();

    return rows
        .map(AdminLearningContentItem.fromMap)
        .toList();
  }

  Future<List<AdminLearningTranslation>> getTranslations({
    required String contentId,
  }) async {
    final result = await _client.rpc(
      'admin_get_learning_translations',
      params: {
        'p_content_id': contentId,
      },
    );

    final rows = (result as List).cast<Map<String, dynamic>>();

    return rows
        .map(AdminLearningTranslation.fromMap)
        .toList();
  }

  Future<bool> upsertTranslation({
    required String contentId,
    required String languageCode,
    required String title,
    String? summary,
    String? body,
    String? reflectionQuestion,
    String? actionPrompt,
  }) async {
    final result = await _client.rpc(
      'admin_upsert_learning_translation',
      params: {
        'p_content_id': contentId,
        'p_language_code': languageCode,
        'p_title': title,
        'p_summary': summary,
        'p_body': body,
        'p_reflection_question': reflectionQuestion,
        'p_action_prompt': actionPrompt,
      },
    );

    return result == true;
  }
}
