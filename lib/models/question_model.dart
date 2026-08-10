class Question {
  final int? id;
  final String questionText;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctOption;
  final String? explanation;
  final String? category;
  final bool isActive;

  Question({
    this.id,
    required this.questionText,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    this.explanation,
    this.category,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'question_text': questionText,
        'option_a': optionA,
        'option_b': optionB,
        'option_c': optionC,
        'option_d': optionD,
        'correct_option': correctOption,
        'explanation': explanation,
        'category': category,
        'is_active': isActive,
      };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'],
        questionText: json['question_text'],
        optionA: json['option_a'],
        optionB: json['option_b'],
        optionC: json['option_c'],
        optionD: json['option_d'],
        correctOption: json['correct_option'],
        explanation: json['explanation'],
        category: json['category'],
        isActive: json['is_active'] ?? true,
      );
}
