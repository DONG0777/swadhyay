import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/content_model.dart';
import 'offline_service.dart';

class QuizService {
  final supabase = Supabase.instance.client;
  final OfflineService _offlineService = OfflineService();

  // নতুন contents টেবিল থেকে প্রশ্ন লোড
  Future<List<ContentModel>> fetchQuestions({int limit = 5, String? languageCode}) async {
    final lang = languageCode ?? 'bn';
    print('🔍 সার্ভিসে ব্যবহৃত ভাষা: $lang');

    try {
      final response = await supabase
          .from('contents')
          .select('*')
          .eq('content_type', 'question')
          .eq('language_code', lang)
          .eq('is_active', true)
          .limit(limit)
          .order('created_at', ascending: false);

      print('📦 Supabase রেসপন্স: ${response.length} টি প্রশ্ন');

      if (response.isNotEmpty) {
        print('✅ $lang ভাষায় ${response.length} টি প্রশ্ন পাওয়া গেছে।');
        final questions = List<ContentModel>.from(
          response.map((e) => ContentModel.fromJson(e)),
        );
        // ক্যাশে সংরক্ষণ (পরবর্তীতে অফলাইনের জন্য)
        // _offlineService.cacheQuestions(questions); // পরে আপডেট হবে
        return questions;
      } else {
        print('⚠️ $lang ভাষায় প্রশ্ন নেই, বাংলা ফ্যালব্যাক ব্যবহার করছি।');
        return await _fetchFallbackQuestions(limit);
      }
    } catch (e) {
      print('❌ Supabase error: $e, ক্যাশ থেকে লোড করছি।');
      return await _getCachedQuestions();
    }
  }

  Future<List<ContentModel>> _fetchFallbackQuestions(int limit) async {
    try {
      final response = await supabase
          .from('contents')
          .select('*')
          .eq('content_type', 'question')
          .eq('language_code', 'bn')
          .eq('is_active', true)
          .limit(limit);

      if (response.isNotEmpty) {
        print('✅ বাংলা ফ্যালব্যাক প্রশ্ন পাওয়া গেছে।');
        return List<ContentModel>.from(response.map((e) => ContentModel.fromJson(e)));
      }
    } catch (e) {
      print('❌ ফ্যালব্যাক error: $e');
    }
    print('⚠️ কোনো প্রশ্ন পাওয়া যায়নি, লোকাল প্রশ্ন ব্যবহার করছি।');
    return _getLocalQuestions();
  }

  Future<List<ContentModel>> _getCachedQuestions() async {
    // TODO: OfflineService-এ ক্যাশ মেথড আপডেট করতে হবে
    // final cached = await _offlineService.getCachedQuestions();
    // if (cached.isNotEmpty) return cached;
    return _getLocalQuestions();
  }

  // লোকাল প্রশ্ন (সব ভাষার জন্য)
  List<ContentModel> _getLocalQuestions() {
    print('📝 লোকাল প্রশ্ন ব্যবহার করা হচ্ছে (ইংরেজি)');
    return [
      ContentModel(
        contentType: 'question',
        title: 'RSS founded in which year?',
        content: 'RSS founded in 1925.',
        optionA: '1915',
        optionB: '1920',
        optionC: '1925',
        optionD: '1930',
        correctOption: 'C',
        explanation: 'RSS was founded in 1925.',
        languageCode: 'en',
      ),
      ContentModel(
        contentType: 'question',
        title: 'Who designed the Indian flag?',
        content: 'Venkayya designed the Indian flag.',
        optionA: 'Tagore',
        optionB: 'Venkayya',
        optionC: 'Gandhi',
        optionD: 'Bose',
        correctOption: 'B',
        explanation: 'Pingali Venkayya designed the Indian flag.',
        languageCode: 'en',
      ),
      ContentModel(
        contentType: 'question',
        title: 'Vande Mataram is from which novel?',
        content: 'Vande Mataram is from Anandamath.',
        optionA: 'Gitanjali',
        optionB: 'Anandamath',
        optionC: 'Devdas',
        optionD: 'Gora',
        correctOption: 'B',
        explanation: 'Bankimchandra\'s Anandamath.',
        languageCode: 'en',
      ),
      ContentModel(
        contentType: 'question',
        title: 'First Indian satellite?',
        content: 'Aryabhata was the first Indian satellite.',
        optionA: 'Chandrayaan',
        optionB: 'Aryabhata',
        optionC: 'Mangalyaan',
        optionD: 'Bhaskara',
        correctOption: 'B',
        explanation: 'Aryabhata.',
        languageCode: 'en',
      ),
      ContentModel(
        contentType: 'question',
        title: 'Father of Yoga?',
        content: 'Patanjali is the father of Yoga.',
        optionA: 'Buddha',
        optionB: 'Patanjali',
        optionC: 'Vivekananda',
        optionD: 'Krishna',
        correctOption: 'B',
        explanation: 'Patanjali.',
        languageCode: 'en',
      ),
    ];
  }
}
