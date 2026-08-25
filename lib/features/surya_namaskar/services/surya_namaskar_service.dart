import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/surya_namaskar.dart';
import '../models/surya_namaskar_content.dart';
import '../models/surya_namaskar_translation.dart';

class SuryaNamaskarService {
  final SupabaseClient _client;

  SuryaNamaskarService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<SuryaNamaskarContent>> getContent(
    String languageCode,
  ) async {
    final baseData = await _client
        .from('surya_namaskar')
        .select()
        .eq('is_active', true)
        .order('step_number');

    final translationData = await _client
        .from('surya_namaskar_translations')
        .select()
        .eq('language_code', languageCode);

    final baseItems = (baseData as List)
        .map(
          (item) => SuryaNamaskar.fromMap(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();

    final translations = (translationData as List)
        .map(
          (item) => SuryaNamaskarTranslation.fromMap(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();

    final translationsByStep = <String, SuryaNamaskarTranslation>{
      for (final translation in translations)
        translation.suryaNamaskarId: translation,
    };

    return baseItems.map((base) {
      final translation = translationsByStep[base.id];

      return SuryaNamaskarContent(
        id: base.id,
        stepNumber: base.stepNumber,
        languageCode: translation?.languageCode ?? base.languageCode,
        title: translation?.title ?? base.title,
        mantra: translation?.mantra ?? base.mantra,
        mantraTransliteration: translation?.mantraTransliteration,
        mantraMeaning: translation?.mantraMeaning,
        description: translation?.description ?? base.description,
        imageUrl: base.imageUrl,
        instructions: translation?.instructions,
        benefits: translation?.benefits,
      );
    }).toList();
  }
}
