import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/question_model.dart';
import 'offline_service.dart';

class QuizService {
  final supabase = Supabase.instance.client;
  final OfflineService _offlineService = OfflineService();

  // প্রথমে Supabase থেকে চেষ্টা করবে, না হলে ক্যাশ থেকে লোড করবে
  Future<List<Question>> fetchQuestions({int limit = 5}) async {
    try {
      final response = await supabase
          .from('questions')
          .select('*')
          .eq('is_active', true)
          .limit(limit);

      if (response.isNotEmpty) {
        final questions = List<Question>.from(
          response.map((e) => Question.fromJson(e)),
        );
        // ব্যাকগ্রাউন্ডে ক্যাশ আপডেট করুন
        _offlineService.cacheQuestions(questions);
        return questions;
      } else {
        // Supabase থেকে কিছু আসেনি – ক্যাশ চেষ্টা করুন
        return await _getCachedQuestions();
      }
    } catch (e) {
      // Supabase error – ক্যাশ চেষ্টা করুন
      print('Supabase error: $e, loading from cache');
      return await _getCachedQuestions();
    }
  }

  // শুধু ক্যাশ থেকে লোড (অফলাইন মোড)
  Future<List<Question>> _getCachedQuestions() async {
    final cached = await _offlineService.getCachedQuestions();
    if (cached.isNotEmpty) {
      return cached;
    } else {
      // শেষ উপায়: লোকাল হার্ডকোডেড প্রশ্ন
      return _getLocalQuestions();
    }
  }

  // লোকাল ফ্যালব্যাক (শেষ ভরসা)
  List<Question> _getLocalQuestions() {
    return [
      Question(
        questionText: 'LOCAL: RSS founded?',
        optionA: '1915',
        optionB: '1920',
        optionC: '1925',
        optionD: '1930',
        correctOption: 'C',
        explanation: '1925.',
        category: 'History',
      ),
      Question(
        questionText: 'LOCAL: Flag designer?',
        optionA: 'Tagore',
        optionB: 'Venkayya',
        optionC: 'Gandhi',
        optionD: 'Bose',
        correctOption: 'B',
        explanation: 'Venkayya.',
        category: 'History',
      ),
      Question(
        questionText: 'LOCAL: Vande Mataram?',
        optionA: 'Gitanjali',
        optionB: 'Anandamath',
        optionC: 'Devdas',
        optionD: 'Gora',
        correctOption: 'B',
        explanation: 'Anandamath.',
        category: 'Literature',
      ),
      Question(
        questionText: 'LOCAL: First satellite?',
        optionA: 'Chandrayaan',
        optionB: 'Aryabhata',
        optionC: 'Mangalyaan',
        optionD: 'Bhaskara',
        correctOption: 'B',
        explanation: 'Aryabhata.',
        category: 'Science',
      ),
      Question(
        questionText: 'LOCAL: Father of Yoga?',
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
