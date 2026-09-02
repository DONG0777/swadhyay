import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/learning_content.dart';

class LearningTranslation {
  final String contentId;
  final String languageCode;
  final String title;
  final String? summary;
  final String? body;
  final String? reflectionQuestion;
  final String? actionPrompt;

  const LearningTranslation({
    required this.contentId,
    required this.languageCode,
    required this.title,
    this.summary,
    this.body,
    this.reflectionQuestion,
    this.actionPrompt,
  });

  factory LearningTranslation.fromMap(Map<String, dynamic> map) {
    return LearningTranslation(
      contentId: map['content_id'] as String,
      languageCode: map['language_code'] as String,
      title: map['title'] as String,
      summary: map['summary'] as String?,
      body: map['body'] as String?,
      reflectionQuestion: map['reflection_question'] as String?,
      actionPrompt: map['action_prompt'] as String?,
    );
  }
}

class LearningService {
  final SupabaseClient _client;

  LearningService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<LearningContent>> getPublishedContents() async {
    final result = await _client
        .from('learning_contents')
        .select(
          'id, content_kind, category, source_title, source_author, '
          'source_reference, source_url, estimated_minutes, difficulty, '
          'published_at',
        )
        .eq('status', 'published')
        .order('published_at', ascending: false);

    return (result as List)
        .cast<Map<String, dynamic>>()
        .map(LearningContent.fromMap)
        .toList();
  }

  Future<List<LearningTranslation>> getTranslations({
    required String contentId,
    required String languageCode,
  }) async {
    final result = await _client
        .from('learning_content_translations')
        .select(
          'content_id, language_code, title, summary, body, '
          'reflection_question, action_prompt',
        )
        .eq('content_id', contentId)
        .eq('language_code', languageCode);

    return (result as List)
        .cast<Map<String, dynamic>>()
        .map(LearningTranslation.fromMap)
        .toList();
  }

  Future<Map<String, LearningTranslation>> getTranslationsForContents({
    required List<String> contentIds,
    required String languageCode,
  }) async {
    if (contentIds.isEmpty) {
      return {};
    }

    final result = await _client
        .from('learning_content_translations')
        .select(
          'content_id, language_code, title, summary, body, '
          'reflection_question, action_prompt',
        )
        .inFilter('content_id', contentIds)
        .eq('language_code', languageCode);

    final translations = (result as List)
        .cast<Map<String, dynamic>>()
        .map(LearningTranslation.fromMap)
        .toList();

    return {
      for (final translation in translations)
        translation.contentId: translation,
    };
  }
}
