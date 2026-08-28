import 'package:supabase_flutter/supabase_flutter.dart';

class AdminSuryaNamaskarService {
  final SupabaseClient _client;

  AdminSuryaNamaskarService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<void> updateBengaliContent({
    required String suryaNamaskarId,
    required String title,
    String? mantra,
    String? mantraMeaning,
    String? description,
    String? instructions,
    String? benefits,
  }) async {
    await _client
        .from('surya_namaskar_translations')
        .update({
          'title': title,
          'mantra': mantra,
          'mantra_meaning': mantraMeaning,
          'description': description,
          'instructions': instructions,
          'benefits': benefits,
        })
        .eq('surya_namaskar_id', suryaNamaskarId)
        .eq('language_code', 'bn');
  }
}
