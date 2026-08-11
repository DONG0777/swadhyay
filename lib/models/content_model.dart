class ContentModel {
  final String? id;
  final String contentType; // shloka, quote, book, question
  final String? section;
  final String? title;
  final String? questionText;
  final String? optionA;
  final String? optionB;
  final String? optionC;
  final String? optionD;
  final String? correctOption;
  final String? content;
  final String? explanation;
  final String languageCode;
  final bool isActive;

  ContentModel({
    this.id,
    required this.contentType,
    this.section,
    this.title,
    this.questionText,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    this.correctOption,
    this.content,
    this.explanation,
    this.languageCode = 'bn',
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'content_type': contentType,
        'section': section,
        'title': title,
        'question_text': questionText,
        'option_a': optionA,
        'option_b': optionB,
        'option_c': optionC,
        'option_d': optionD,
        'correct_option': correctOption,
        'content': content,
        'explanation': explanation,
        'language_code': languageCode,
        'is_active': isActive,
      };

  factory ContentModel.fromJson(Map<String, dynamic> json) => ContentModel(
        id: json['id'],
        contentType: json['content_type'],
        section: json['section'],
        title: json['title'],
        questionText: json['question_text'],
        optionA: json['option_a'],
        optionB: json['option_b'],
        optionC: json['option_c'],
        optionD: json['option_d'],
        correctOption: json['correct_option'],
        content: json['content'],
        explanation: json['explanation'],
        languageCode: json['language_code'] ?? 'bn',
        isActive: json['is_active'] ?? true,
      );
}
