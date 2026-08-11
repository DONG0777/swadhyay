  // ========== পিলার্স (শ্লোক/উক্তি/বই) আলাদাভাবে আনার জন্য ==========
  Future<List<ContentModel>> getPillars({String languageCode = 'bn'}) async {
    final response = await supabase
        .from('contents')
        .select('*')
        .inFilter('content_type', ['shloka', 'quote', 'book'])
        .eq('language_code', languageCode)
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return List<ContentModel>.from(response.map((e) => ContentModel.fromJson(e)));
  }

  // ========== শুধু প্রশ্ন আনার জন্য (কুইজের কাজে লাগবে) ==========
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
