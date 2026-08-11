import 'package:flutter/material.dart';
import '../services/quiz_service.dart';
import '../models/content_model.dart';
import '../generated/l10n/app_localizations.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  String? _selectedLetter;
  List<ContentModel> _questions = [];
  bool _isLoading = true;
  bool _isAnswering = false;

  final QuizService _quizService = QuizService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuestions();
    });
  }

  Future<void> _loadQuestions() async {
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;
    print('🔍 কুইজে ব্যবহৃত ভাষা: $lang');
    final data = await _quizService.fetchQuestions(limit: 5, languageCode: lang);
    setState(() {
      _questions = data;
      _isLoading = false;
    });
    print('✅ প্রশ্ন লোড হয়েছে: ${_questions.length} টি');
  }

  void _answerQuestion(String letter) {
    if (_isAnswering || _selectedLetter != null) return;

    final correct = _questions[_currentQuestion].correctOption!;
    setState(() {
      _selectedLetter = letter;
      _isAnswering = true;
      if (letter == correct) _score += 10;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (_currentQuestion >= _questions.length - 1) {
        Navigator.pop(context, {'score': _score, 'total': _questions.length});
        return;
      }
      setState(() {
        _currentQuestion++;
        _selectedLetter = null;
        _isAnswering = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(local.startQuiz),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('কোনো প্রশ্ন পাওয়া যায়নি।')),
      );
    }

    final q = _questions[_currentQuestion];
    final options = [
      q.optionA ?? '',
      q.optionB ?? '',
      q.optionC ?? '',
      q.optionD ?? '',
    ];
    final letters = ['A', 'B', 'C', 'D'];

    return Scaffold(
      appBar: AppBar(
        title: Text('${local.startQuiz} ${_currentQuestion + 1}/${_questions.length}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestion + 1) / _questions.length,
              backgroundColor: Colors.grey[300],
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 30),
            Text(
              q.title ?? q.content ?? 'প্রশ্ন নেই',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ...List.generate(4, (i) {
              Color btnColor = Colors.grey[200]!;
              if (_selectedLetter != null) {
                if (letters[i] == q.correctOption) {
                  btnColor = Colors.green[100]!;
                } else if (_selectedLetter == letters[i]) {
                  btnColor = Colors.red[100]!;
                }
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_selectedLetter == null && !_isAnswering)
                        ? () => _answerQuestion(letters[i])
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      options[i],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              );
            }),
            if (_selectedLetter != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  q.explanation ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
