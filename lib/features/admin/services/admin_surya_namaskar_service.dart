import 'package:supabase_flutter/supabase_flutter.dart';

class AdminSuryaNamaskarService {
  final SupabaseClient _client;

  AdminSuryaNamaskarService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<void> updateImageUrl({
    required String suryaNamaskarId,
    required String imageUrl,
  }) async {
    await _client
        .from('surya_namaskar')
        .update({
          'image_url': imageUrl,
        })
        .eq('id', suryaNamaskarId);
  }

  Future<List<Map<String, dynamic>>> getTranslations({
    required String suryaNamaskarId,
  }) async {
    final data = await _client
        .from('surya_namaskar_translations')
        .select()
        .eq('surya_namaskar_id', suryaNamaskarId);

    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> upsertTranslation({
    required String suryaNamaskarId,
    required String languageCode,
    required String title,
    String? mantra,
    String? mantraMeaning,
    String? description,
    String? instructions,
    String? benefits,
  }) async {
    await _client
        .from('surya_namaskar_translations')
        .upsert(
          {
            'surya_namaskar_id': suryaNamaskarId,
            'language_code': languageCode,
            'title': title,
            'mantra': mantra,
            'mantra_meaning': mantraMeaning,
            'description': description,
            'instructions': instructions,
            'benefits': benefits,
          },
          onConflict: 'surya_namaskar_id,language_code',
        );
  }
}
