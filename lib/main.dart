import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hgdfxziykvsggagghesb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhnZGZ4eml5a3ZzZ2dhZ2doZXNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODYxMjI0NDksImV4cCI6MjEwMTY5ODQ0OX0.tcHn6XRtafgG8CrxYniJlN5CUnIO2Og2etjiODWSXqc',
  );

  runApp(const SwadhyayApp());
}

class SwadhyayApp extends StatelessWidget {
  const SwadhyayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swadhyay',
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _streak = 0;
  int _totalXP = 0;
  String _lastDate = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _streak = prefs.getInt('streak') ?? 0;
      _totalXP = prefs.getInt('totalXP') ?? 0;
      _lastDate = prefs.getString('lastDate') ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streak', _streak);
    await prefs.setInt('totalXP', _totalXP);
    await prefs.setString('lastDate', _lastDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('☀️ Swadhyay'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wb_sunny, size: 80, color: Color(0xFFFF6B00)),
            const SizedBox(height: 20),
            Text(
              'Welcome, Swadhyayi!',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF6B00),
                  ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatCard('🔥 Streak', '$_streak days', Colors.orange),
                const SizedBox(width: 20),
                _buildStatCard('⭐ XP', '$_totalXP', Colors.amber),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizScreen()),
                );
                if (result != null && result is Map) {
                  final today = DateTime.now().toIso8601String().split('T')[0];
                  setState(() {
                    _totalXP += result['score'] as int;
                    if (_lastDate != today) {
                      final yesterday = DateTime.now().subtract(const Duration(days: 1)).toIso8601String().split('T')[0];
                      if (_lastDate == yesterday) {
                        _streak++;
                      } else {
                        _streak = 1;
                      }
                      _lastDate = today;
                    }
                  });
                  _saveData();
                  _showScoreCard(result['score'] as int, result['total'] as int);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Start Quiz', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  void _showScoreCard(int score, int total) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreCardScreen(score: score, total: total, streak: _streak, totalXP: _totalXP),
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
      'question': 'In which year was RSS founded?',
      'options': ['1915', '1920', '1925', '1930'],
      'correct': 2,
      'explanation': 'RSS was founded by Dr. Hedgewar on Vijayadashami in 1925.',
    },
    {
      'question': 'Who designed the Indian national flag?',
      'options': ['Rabindranath', 'Pingali Venkayya', 'Gandhiji', 'Subhas Chandra'],
      'correct': 1,
      'explanation': 'Pingali Venkayya from Andhra Pradesh designed the flag in 1921.',
    },
    {
      'question': 'Which book contains the song Vande Mataram?',
      'options': ['Gitanjali', 'Anandamath', 'Devdas', 'Gora'],
      'correct': 1,
      'explanation': 'From Bankim Chandra Chatterjee\'s "Anandamath".',
    },
    {
      'question': 'What was India\'s first satellite?',
      'options': ['Chandrayaan', 'Aryabhata', 'Mangalyaan', 'Bhaskara'],
      'correct': 1,
      'explanation': 'Aryabhata was launched in 1975.',
    },
    {
      'question': 'Who is called the father of Yoga?',
      'options': ['Buddha', 'Patanjali', 'Vivekananda', 'Krishna'],
      'correct': 1,
      'explanation': 'Patanjali wrote the Yoga Sutras.',
    },
  ];

  void _answerQuestion(int selected) {
    setState(() {
      _selectedOption = selected;
      if (selected == _questions[_currentQuestion]['correct']) {
        _score += 10;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentQuestion < _questions.length - 1) {
        setState(() {
          _currentQuestion++;
          _selectedOption = null;
        });
      } else {
        Navigator.pop(context, {'score': _score, 'total': _questions.length});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentQuestion];
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
            Text(q['question'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(q['options'][i], style: const TextStyle(fontSize: 16)),
                  ),
                ),
              );
            }),
            if (_selectedOption != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(12)),
                child: Text(q['explanation'], style: const TextStyle(fontSize: 16)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ScoreCardScreen extends StatelessWidget {
  final int score;
  final int total;
  final int streak;
  final int totalXP;

  const ScoreCardScreen({
    super.key,
    required this.score,
    required this.total,
    required this.streak,
    required this.totalXP,
  });

  Future<void> _shareScoreCard(BuildContext context) async {
    final text = '''
☀️ *Swadhyay Quiz Scorecard*
📊 Score: $score/$total
🔥 Streak: $streak days
⭐ Total XP: $totalXP
📅 Date: ${DateTime.now().toString().split(' ')[0]}
''';
    final encoded = Uri.encodeComponent(text);
    final url = Uri.parse('https://wa.me/?text=$encoded');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scorecard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B00), Color(0xFFFFD700)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wb_sunny, size: 60, color: Colors.white),
                  const SizedBox(height: 10),
                  const Text('SWADHYAY', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 20),
                  Text('Score: $score/$total', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.white, size: 24),
                      const SizedBox(width: 5),
                      Text('$streak day streak', style: const TextStyle(fontSize: 18, color: Colors.white)),
                      const SizedBox(width: 20),
                      const Icon(Icons.star, color: Colors.white, size: 24),
                      const SizedBox(width: 5),
                      Text('$totalXP XP', style: const TextStyle(fontSize: 18, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(DateTime.now().toString().split(' ')[0], style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _shareScoreCard(context),
              icon: const Icon(Icons.share),
              label: const Text('Share to WhatsApp'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}