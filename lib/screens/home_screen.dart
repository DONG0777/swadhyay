import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_screen.dart';
import 'score_card_screen.dart';
import 'challenge_screen.dart';
import 'circle_list_screen.dart';
import 'admin_login_screen.dart';
import 'checkin_screen.dart';
import 'circle_proposals_screen.dart';
import '../widgets/daily_pillars_widget.dart';
import '../widgets/network_status_widget.dart';
import '../services/auth_service.dart';
import '../generated/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  const HomeScreen({super.key, required this.onLanguageChanged});

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
    final local = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wb_sunny, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(local.appTitle, style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            tooltip: local.changeLanguage,
            onSelected: (Locale locale) {
              widget.onLanguageChanged(locale);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(onLanguageChanged: widget.onLanguageChanged),
                ),
              );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: Locale('bn'), child: Text('বাংলা')),
              const PopupMenuItem(value: Locale('hi'), child: Text('हिन्दी')),
              const PopupMenuItem(value: Locale('en'), child: Text('English')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(local.profile),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('👤 ${local.welcome}: ${_auth.userName ?? local.guest}'),
                      Text('📧 ${_auth.userEmail ?? 'N/A'}'),
                      Text('🆔 ${_auth.userId}'),
                      const Divider(),
                      Text('🔥 ${local.streak}: $_streak days'),
                      Text('⭐ ${local.xp}: $_totalXP'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(local.backHome),
                    ),
                    if (_auth.isSignedIn)
                      TextButton(
                        onPressed: () async {
                          await _auth.signOut();
                          if (context.mounted) Navigator.pushReplacementNamed(context, '/');
                        },
                        child: Text(local.logout, style: const TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              );
            },
            tooltip: local.profile,
          ),
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CircleListScreen(userId: _auth.userId)),
            ),
            tooltip: local.circle,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
            ),
            tooltip: local.admin,
          ),
        ],
      ),
      body: Column(
        children: [
          const NetworkStatusWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.wb_sunny,
                      size: 60,
                      color: Color(0xFFFF6B00),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${local.welcome}, ${_auth.userName ?? local.guest}!',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF6B00),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatCard('🔥 ${local.streak}', '$_streak days', Colors.orange),
                      const SizedBox(width: 16),
                      _buildStatCard('⭐ ${local.xp}', '$_totalXP', Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const QuizScreen()),
                          );
                          if (result != null && result is Map) {
                            _updateStreakAndXP(result['score'] as int);
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
                        child: Text(local.startQuiz, style: const TextStyle(fontSize: 13)),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChallengeScreen()),
                        ),
                        icon: const Icon(Icons.eco, size: 18),
                        label: Text(local.challenge, style: const TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CircleListScreen(userId: _auth.userId),
                          ),
                        ),
                        icon: const Icon(Icons.people, size: 18),
                        label: Text(local.circle, style: const TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheckinScreen()),
                          );
                          if (result != null && result is Map) {
                            _updateStreakAndXP(result['xp'] as int);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('🎉 +5 ${local.xp}!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.location_on, size: 18),
                        label: Text(local.checkin, style: const TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                        ),
                      ),
                      // 🔥 NEW: সার্বিক প্রস্তাব বাটন
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CircleProposalsScreen()),
                          );
                        },
                        icon: const Icon(Icons.how_to_vote, size: 18),
                        label: const Text('🗳️ সার্বিক প্রস্তাব', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B1FA2),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 8),
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
      width: 120,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
