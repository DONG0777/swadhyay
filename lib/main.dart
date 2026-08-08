import 'package:flutter/material.dart';

void main() {
  runApp(const SwadhyayApp());
}

class SwadhyayApp extends StatelessWidget {
  const SwadhyayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'স্বাধ্যায়',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B00),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('☀️ স্বাধ্যায়'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wb_sunny, size: 100, color: Color(0xFFFF6B00)),
            const SizedBox(height: 20),
            Text(
              'স্বাগতম, স্বাধ্যায়ী!',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF6B00),
                  ),
            ),
            const SizedBox(height: 20),
            const Text(
              'আজকের কুইজ শুরু হোক!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('কুইজ শুরু করুন', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  int? _selectedOption;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'রাষ্ট্রীয় স্বয়ংসেবক সংঘ কত সালে প্রতিষ্ঠিত হয়?',
      'options': ['১৯১৫', '১৯২০', '১৯২৫', '১৯৩০'],
      'correct': 2,
      'explanation': '১৯২৫ সালের বিজয়া দশমীতে ড. হেডগেওয়ার RSS প্রতিষ্ঠা করেন।',
    },
    {
      'question': 'ভারতের জাতীয় পতাকার নকশা কে তৈরি করেন?',
      'options': ['রবীন্দ্রনাথ', 'পিঙ্গালি ভেঙ্কাইয়া', 'গান্ধীজী', 'সুভাষচন্দ্র'],
      'correct': 1,
      'explanation': 'অন্ধ্রপ্রদেশের পিঙ্গালি ভেঙ্কাইয়া ১৯২১ সালে পতাকার নকশা করেন।',
    },
    {
      'question': 'বন্দে মাতরম গানটি কোন গ্রন্থ থেকে নেওয়া?',
      'options': ['গীতাঞ্জলি', 'আনন্দমঠ', 'দেবদাস', 'গোরা'],
      'correct': 1,
      'explanation': 'বঙ্কিমচন্দ্র চট্টোপাধ্যায়ের "আনন্দমঠ" উপন্যাস থেকে।',
    },
    {
      'question': 'ভারতের প্রথম উপগ্রহের নাম কী?',
      'options': ['চন্দ্রযান', 'আর্যভট্ট', 'মঙ্গলযান', 'ভাস্কর'],
      'correct': 1,
      'explanation': '১৯৭৫ সালে ভারতের প্রথম উপগ্রহ আর্যভট্ট উৎক্ষেপণ করা হয়।',
    },
    {
      'question': 'যোগের জনক কাকে বলা হয়?',
      'options': ['বুদ্ধ', 'পতঞ্জলি', 'বিবেকানন্দ', 'কৃষ্ণ'],
      'correct': 1,
      'explanation': 'পতঞ্জলি যোগসূত্র রচনা করেন এবং যোগের জনক হিসেবে পরিচিত।',
    },
  ];

  void _answerQuestion(int selected) {
    setState(() {
      _selectedOption = selected;
      if (selected == _questions[_currentQuestion]['correct']) {
        _score++;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentQuestion < _questions.length - 1) {
        setState(() {
          _currentQuestion++;
          _selectedOption = null;
        });
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('কুইজ শেষ!'),
        content: Text('আপনার স্কোর: $_score/${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('হোমে ফিরুন'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentQuestion];
    return Scaffold(
      appBar: AppBar(
        title: Text('প্রশ্ন ${_currentQuestion + 1}/${_questions.length}'),
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
              q['question'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ...List.generate(4, (i) {
              Color btnColor = Colors.grey[200]!;
              if (_selectedOption != null) {
                if (i == q['correct']) {
                  btnColor = Colors.green[100]!;
                } else if (i == _selectedOption && i != q['correct']) {
                  btnColor = Colors.red[100]!;
                }
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedOption == null ? () => _answerQuestion(i) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      q['options'][i],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              );
            }),
            if (_selectedOption != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  q['explanation'],
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}