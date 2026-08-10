import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/question_model.dart';

class AdminService {
  final supabase = Supabase.instance.client;

  // সব প্রশ্ন লোড করা
  Future<List<Question>> getAllQuestions() async {
    final response = await supabase
        .from('questions')
        .select('*')
        .order('id', ascending: false);
    return List<Question>.from(response.map((e) => Question.fromJson(e)));
  }

  // নতুন প্রশ্ন যোগ করা
  Future<Question> addQuestion(Question question) async {
    final response = await supabase
        .from('questions')
        .insert(question.toJson())
        .select()
        .single();
    return Question.fromJson(response);
  }

  // প্রশ্ন আপডেট করা
  Future<Question> updateQuestion(int id, Question question) async {
    final response = await supabase
        .from('questions')
        .update(question.toJson())
        .eq('id', id)
        .select()
        .single();
    return Question.fromJson(response);
  }

  // প্রশ্ন ডিলিট করা
  Future<void> deleteQuestion(int id) async {
    await supabase.from('questions').delete().eq('id', id);
  }

  // JSON ব্যাচ আপলোড
  Future<int> bulkUpload(List<Map<String, dynamic>> questions) async {
    final response = await supabase
        .from('questions')
        .insert(questions)
        .select();
    return response.length;
  }

  // ক্যাটাগরি অনুযায়ী ফিল্টার
  Future<List<Question>> getQuestionsByCategory(String category) async {
    final response = await supabase
        .from('questions')
        .select('*')
        .eq('category', category)
        .order('id', ascending: false);
    return List<Question>.from(response.map((e) => Question.fromJson(e)));
  }
}
