import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/challenge_service.dart';
import '../models/challenge_model.dart';
import '../generated/l10n/app_localizations.dart';
import '../services/share_service.dart';
import '../services/auth_service.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final ChallengeService _service = ChallengeService();
  final AuthService _auth = AuthService();
  List<ChallengeDay> _days = [];
  double _progress = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final days = await _service.loadChallenge(context);
    final progress = await _service.getProgress(context);
    setState(() {
      _days = days;
      _progress = progress;
      _isLoading = false;
    });
  }

  Future<void> _completeDay(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = _auth.userId;
    final today = DateTime.now().toIso8601String().split('T')[0];
    final lastCompletedKey = '${userId}_last_challenge_day';
    final lastCompletedDate = prefs.getString(lastCompletedKey);

    if (lastCompletedDate == today) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ আজকে ইতিমধ্যে করেছেন!'), backgroundColor: Colors.orange),
      );
      return;
    }

    final ready = await _showReadyDialog();
    if (ready != true) return;

    // 🔥 টাইমার ডায়ালগ
    final xpAdded = await _showTimerDialog();
    if (xpAdded != true) return;

    await _service.completeDay(context, index);
    await prefs.setString(lastCompletedKey, today);
    await _loadData();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎉 দিন সম্পন্ন! +৫ XP!'), backgroundColor: Colors.green),
    );
  }

  Future<bool> _showReadyDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ReadyDialog(),
    ) ?? false;
  }

  // 🔥 নতুন টাইমার ডায়ালগ
  Future<bool> _showTimerDialog() async {
    final completer = Completer<bool>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TimerDialog(
        onComplete: (success) {
          if (!completer.isCompleted) {
            completer.complete(success);
          }
        },
      ),
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final completedCount = _days.where((d) => d.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('🌱 ${local.challenge}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ShareService.shareChallengeProgress(
                completed: completedCount,
                total: _days.length,
                streak: completedCount,
                xp: completedCount * 5,
                language: local.appTitle,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressCard(completedCount),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.9,
                ),
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  final day = _days[index];
                  return _DayCard(
                    day: day,
                    onTap: day.isUnlocked && !day.isCompleted
                        ? () => _completeDay(index)
                        : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int completedCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🌿 $completedCount/${_days.length}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                _getPlantEmoji(_progress),
                style: const TextStyle(fontSize: 40),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.white.withOpacity(0.3),
            color: Colors.yellow,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 4),
          Text(
            '${(_progress * 100).toInt()}%',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  String _getPlantEmoji(double progress) {
    if (progress < 0.1) return '🌱';
    if (progress < 0.25) return '🌿';
    if (progress < 0.5) return '🌳';
    if (progress < 0.75) return '🌲';
    if (progress < 0.95) return '🎄';
    return '🌟';
  }
}

class _DayCard extends StatelessWidget {
  final ChallengeDay day;
  final VoidCallback? onTap;

  const _DayCard({required this.day, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    IconData icon;
    Color iconColor;

    if (day.isCompleted) {
      bgColor = Colors.green[100]!;
      icon = Icons.check_circle;
      iconColor = Colors.green;
    } else if (day.isUnlocked) {
      bgColor = Colors.orange[100]!;
      icon = Icons.play_arrow;
      iconColor = Colors.orange;
    } else {
      bgColor = Colors.grey[300]!;
      icon = Icons.lock;
      iconColor = Colors.grey[600]!;
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: day.isUnlocked ? 2 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: bgColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: iconColor),
              const SizedBox(height: 4),
              Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: day.isUnlocked ? Colors.black87 : Colors.grey[600],
                ),
              ),
              if (day.isCompleted) const Text('✅', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 📌 "প্রস্তুত?" ডায়ালগ
// ============================================================
class ReadyDialog extends StatefulWidget {
  const ReadyDialog({super.key});

  @override
  State<ReadyDialog> createState() => _ReadyDialogState();
}

class _ReadyDialogState extends State<ReadyDialog> {
  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          if (_countdown > 0) _countdown--;
        });
      }
      return _countdown > 0 && mounted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('🧘 প্রস্তুত?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('৫ মিনিট ধ্যান বা চর্চা শুরু করতে প্রস্তুত হোন।', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.orange[50], shape: BoxShape.circle),
            child: Text(
              _countdown > 0 ? '$_countdown' : '🚀 শুরু!',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: _countdown > 0 ? Colors.orange : Colors.green,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _countdown == 0 ? () => Navigator.pop(context, true) : null,
          child: Text(_countdown == 0 ? 'শুরু করুন 🚀' : 'অপেক্ষা করুন...'),
        ),
      ],
    );
  }
}

// ============================================================
// 📌 টাইমার ডায়ালগ (Timer ক্লাস ব্যবহার)
// ============================================================
class TimerDialog extends StatefulWidget {
  final Function(bool) onComplete;

  const TimerDialog({super.key, required this.onComplete});

  @override
  State<TimerDialog> createState() => _TimerDialogState();
}

class _TimerDialogState extends State<TimerDialog> with TickerProviderStateMixin {
  int _remainingSeconds = 300; // ডিবাগ: ৫ সেকেন্ড
  bool _isComplete = false;
  bool _xpAdded = false;
  Timer? _timer;
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _breathAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _isComplete = true;
            timer.cancel();
            _addXPAndClose();
          }
        });
      }
    });
  }

  void _addXPAndClose() {
    if (_xpAdded) return;
    _xpAdded = true;
    _addXP();

    // ১ সেকেন্ড পর ডায়ালগ বন্ধ করুন
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pop(context, true);
        widget.onComplete(true);
      }
    });
  }

  void _addXP() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = 'guest_123';
      final xpKey = '${userId}_totalXP';
      int currentXP = prefs.getInt(xpKey) ?? 0;
      currentXP += 5;
      await prefs.setInt(xpKey, currentXP);
      print('✅ XP যোগ: $currentXP');
    } catch (e) {
      print('❌ XP Error: $e');
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSecs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSecs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isComplete ? '🎉 ধ্যান সম্পন্ন! +৫ XP' : '🧘 শ্বাসের সাথে সাথে...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _isComplete ? Colors.green : Colors.indigo[700],
              ),
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _breathController,
              builder: (context, child) {
                return Center(
                  child: Container(
                    width: 120 * _breathAnimation.value,
                    height: 120 * _breathAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Colors.indigo.shade200, Colors.indigo.shade50],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.shade200.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _isComplete ? '✨' : '🧘',
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: _isComplete ? Colors.green[50] : Colors.indigo[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _isComplete ? '✅ সম্পন্ন!' : _formatTime(_remainingSeconds),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _isComplete ? Colors.green : Colors.indigo[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathController.dispose();
    super.dispose();
  }
}
