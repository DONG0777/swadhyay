import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_screen.dart';
import 'score_card_screen.dart';
import 'challenge_screen.dart';
import 'circle_list_screen.dart';
import 'admin_login_screen.dart';
import 'checkin_screen.dart';
import '../widgets/daily_pillars_widget.dart';
import '../widgets/network_status_widget.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  int _streak = 0;
  int _totalXP = 0;
  String _lastDate = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = _auth.userId;
    setState(() {
      _streak = prefs.getInt('${userId}_streak') ?? 0;
      _totalXP = prefs.getInt('${userId}_totalXP') ?? 0;
      _lastDate = prefs.getString('${userId}_lastDate') ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = _auth.userId;
    await prefs.setInt('${userId}_streak', _streak);
    await prefs.setInt('${userId}_totalXP', _totalXP);
    await prefs.setString('${userId}_lastDate', _lastDate);
  }

  void _updateStreakAndXP(int earnedXP) {
    final today = DateTime.now().toIso8601String().split('T')[0];
    setState(() {
      _totalXP += earnedXP;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('☀️ Swadhyay'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('আমার প্রোফাইল'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('👤 নাম: ${_auth.userName ?? 'অতিথি'}'),
                      Text('📧 ইমেইল: ${_auth.userEmail ?? 'নেই'}'),
                      Text('🆔 আইডি: ${_auth.userId}'),
                      const Divider(),
                      Text('🔥 স্ট্রিক: $_streak দিন'),
                      Text('⭐ এক্সপি: $_totalXP'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('বন্ধ করুন'),
                    ),
                    if (_auth.isSignedIn)
                      TextButton(
                        onPressed: () async {
                          await _auth.signOut();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, '/');
                          }
                        },
                        child: const Text('লগআউট', style: TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              );
            },
            tooltip: 'প্রোফাইল',
          ),
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CircleListScreen(userId: _auth.userId),
                ),
              );
            },
            tooltip: 'সার্কেল',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
              );
            },
            tooltip: 'অ্যাডমিন প্যানেল',
          ),
        ],
      ),
      body: Column(
        children: [
          const NetworkStatusWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Icon(Icons.wb_sunny, size: 80, color: Color(0xFFFF6B00)),
                  const SizedBox(height: 10),
                  Text(
                    'স্বাগতম, ${_auth.userName ?? 'অতিথি'}!',
                    style: Theme.of(context).textTheme.headlineLarge
                        ?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFFF6B00)),
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
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                              context, MaterialPageRoute(builder: (context) => const QuizScreen()));
                          if (result != null && result is Map) {
                            _updateStreakAndXP(result['score'] as int);
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScoreCardScreen(
                                  score: result['score'],
                                  total: result['total'],
                                  streak: _streak,
                                  totalXP: _totalXP,
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Start Quiz', style: TextStyle(fontSize: 14)),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ChallengeScreen()),
                          );
                        },
                        icon: const Icon(Icons.eco, size: 18),
                        label: const Text('🌱 দীপ্ত যাত্রা', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CircleListScreen(userId: _auth.userId),
                            ),
                          );
                        },
                        icon: const Icon(Icons.people, size: 18),
                        label: const Text('🔄 সার্কেল', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      // 🔥 নতুন GPS চেক-ইন বাটন
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheckinScreen()),
                          );
                          if (result != null && result is Map) {
                            _updateStreakAndXP(result['xp'] as int);
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('🎉 +৫ এক্সপি পেয়েছেন!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.location_on, size: 18),
                        label: const Text('📍 চেক-ইন', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 10),
                  const DailyPillarsWidget(),
                ],
              ),
            ),
          ),
        ],
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
}
