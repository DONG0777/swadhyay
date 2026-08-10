import 'package:flutter/material.dart';
import '../services/quiz_service.dart';
import '../models/question_model.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  String? _selectedLetter;
  List<Question> _questions = [];
  bool _isLoading = true;

  final QuizService _quizService = QuizService();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final data = await _quizService.fetchQuestions(limit: 5);
    if (data.isNotEmpty) {
      setState(() {
        _questions = data;
        _isLoading = false;
      });
    } else {
      _useLocalQuestions();
    }
  }

  void _useLocalQuestions() {
    setState(() {
      _questions = [
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
      _isLoading = false;
    });
  }

  void _answerQuestion(String letter) {
    final correct = _questions[_currentQuestion].correctOption;
    setState(() {
      _selectedLetter = letter;
      if (letter == correct) _score += 10;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (_currentQuestion < _questions.length - 1) {
        setState(() {
          _currentQuestion++;
          _selectedLetter = null;
        });
      } else {
        Navigator.pop(context, {'score': _score, 'total': _questions.length});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final q = _questions[_currentQuestion];
    final options = [q.optionA, q.optionB, q.optionC, q.optionD];
    final letters = ['A', 'B', 'C', 'D'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Q${_currentQuestion + 1}/${_questions.length}'),
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
            Text(q.questionText,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                    onPressed: _selectedLetter == null
                        ? () => _answerQuestion(letters[i])
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(options[i], style: const TextStyle(fontSize: 16)),
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
                    borderRadius: BorderRadius.circular(12)),
                child: Text(q.explanation ?? '',
                    style: const TextStyle(fontSize: 16)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
