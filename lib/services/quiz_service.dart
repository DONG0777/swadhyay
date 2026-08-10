import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/question_model.dart';
import 'offline_service.dart';

class QuizService {
  final supabase = Supabase.instance.client;
  final OfflineService _offlineService = OfflineService();

  Future<List<Question>> fetchQuestions({int limit = 5, String? languageCode}) async {
    final lang = languageCode ?? 'bn'; // ডিফল্ট বাংলা
    print('🔍 সার্ভিসে ব্যবহৃত ভাষা: $lang');

    try {
      final response = await supabase
          .from('questions')
          .select('*')
          .eq('is_active', true)
          .eq('language_code', lang)
          .limit(limit);

      print('📦 Supabase রেসপন্স: ${response.length} টি প্রশ্ন');

      if (response.isNotEmpty) {
        print('✅ $lang ভাষায় ${response.length} টি প্রশ্ন পাওয়া গেছে।');
        final questions = List<Question>.from(
          response.map((e) => Question.fromJson(e)),
        );
        await _offlineService.cacheQuestions(questions);
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

  Future<List<Question>> _fetchFallbackQuestions(int limit) async {
    try {
      final response = await supabase
          .from('questions')
          .select('*')
          .eq('is_active', true)
          .eq('language_code', 'bn')
          .limit(limit);

      if (response.isNotEmpty) {
        print('✅ বাংলা ফ্যালব্যাক প্রশ্ন পাওয়া গেছে।');
        return List<Question>.from(response.map((e) => Question.fromJson(e)));
      }
    } catch (e) {
      print('❌ ফ্যালব্যাক error: $e');
    }
    print('⚠️ কোনো প্রশ্ন পাওয়া যায়নি, লোকাল প্রশ্ন ব্যবহার করছি।');
    return _getLocalQuestions();
  }

  Future<List<Question>> _getCachedQuestions() async {
    final cached = await _offlineService.getCachedQuestions();
    if (cached.isNotEmpty) {
      print('✅ ক্যাশ থেকে প্রশ্ন লোড করা হয়েছে।');
      return cached;
    }
    return _getLocalQuestions();
  }

  List<Question> _getLocalQuestions() {
    print('📝 লোকাল প্রশ্ন ব্যবহার করা হচ্ছে (ইংরেজি)');
    return [
      Question(
        questionText: 'RSS founded in which year? (EN)',
        optionA: '1915',
        optionB: '1920',
        optionC: '1925',
        optionD: '1930',
        correctOption: 'C',
        explanation: '1925.',
        category: 'History',
      ),
      Question(
        questionText: 'Who designed the Indian flag? (EN)',
        optionA: 'Tagore',
        optionB: 'Venkayya',
        optionC: 'Gandhi',
        optionD: 'Bose',
        correctOption: 'B',
        explanation: 'Venkayya.',
        category: 'History',
      ),
      Question(
        questionText: 'Vande Mataram is from which novel? (EN)',
        optionA: 'Gitanjali',
        optionB: 'Anandamath',
        optionC: 'Devdas',
        optionD: 'Gora',
        correctOption: 'B',
        explanation: 'Anandamath.',
        category: 'Literature',
      ),
      Question(
        questionText: 'First Indian satellite? (EN)',
        optionA: 'Chandrayaan',
        optionB: 'Aryabhata',
        optionC: 'Mangalyaan',
        optionD: 'Bhaskara',
        correctOption: 'B',
        explanation: 'Aryabhata.',
        category: 'Science',
      ),
      Question(
        questionText: 'Father of Yoga? (EN)',
        optionA: 'Buddha',
        optionB: 'Patanjali',
        optionC: 'Vivekananda',
        optionD: 'Krishna',
        correctOption: 'B',
        explanation: 'Patanjali.',
        category: 'Yoga',
      ),
    ];
  }
}
