import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/content_model.dart';

class ContentService {
  final supabase = Supabase.instance.client;

  // সব কন্টেন্ট লোড করুন (টাইপ অনুযায়ী ফিল্টার করতে পারেন)
  Future<List<ContentModel>> getContents({String? contentType}) async {
    var query = supabase.from('contents').select('*').eq('is_active', true);
    if (contentType != null && contentType != 'all') {
      query = query.eq('content_type', contentType);
    }
    final response = await query.order('created_at', ascending: false);
    return List<ContentModel>.from(response.map((e) => ContentModel.fromJson(e)));
  }

  // ========== পিলার্স (শ্লোক/উক্তি/বই/সূর্য/কর্তব্য) ==========
  Future<List<ContentModel>> getPillars({String languageCode = 'bn'}) async {
    final response = await supabase
        .from('contents')
        .select('*')
        // 🔥 সব পিলার টাইপ যোগ করা হয়েছে
        .inFilter('content_type', ['shloka', 'quote', 'book', 'surya', 'duty'])
        .eq('language_code', languageCode)
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return List<ContentModel>.from(response.map((e) => ContentModel.fromJson(e)));
  }

  // ========== শুধু প্রশ্ন আনার জন্য ==========
  Future<List<ContentModel>> getQuestions({String languageCode = 'bn', int limit = 5}) async {
    final response = await supabase
        .from('contents')
        .select('*')
        .eq('content_type', 'question')
        .eq('language_code', languageCode)
        .eq('is_active', true)
        .limit(limit)
        .order('created_at', ascending: false);

    return List<ContentModel>.from(response.map((e) => ContentModel.fromJson(e)));
  }

  // নতুন কন্টেন্ট যোগ করুন
  Future<ContentModel> addContent(ContentModel content) async {
    final response = await supabase
        .from('contents')
        .insert(content.toJson())
        .select()
        .single();
    return ContentModel.fromJson(response);
  }

  // কন্টেন্ট আপডেট করুন
  Future<ContentModel> updateContent(String id, ContentModel content) async {
    final response = await supabase
        .from('contents')
        .update(content.toJson())
        .eq('id', id)
        .select()
        .single();
    return ContentModel.fromJson(response);
  }

  // কন্টেন্ট ডিলিট করুন (সফট ডিলিট)
  Future<void> deleteContent(String id) async {
    await supabase
        .from('contents')
        .update({'is_active': false})
        .eq('id', id);
  }

  // ব্যাচ আপলোড
  Future<int> bulkUpload(List<Map<String, dynamic>> contents) async {
    final response = await supabase
        .from('contents')
        .insert(contents)
        .select();
    return response.length;
  }
}
