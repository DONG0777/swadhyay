import 'package:flutter/material.dart';
import '../services/challenge_service.dart';
import '../models/challenge_model.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final ChallengeService _service = ChallengeService();
  List<ChallengeDay> _days = [];
  double _progress = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final days = await _service.loadChallenge();
    final progress = await _service.getProgress();
    setState(() {
      _days = days;
      _progress = progress;
      _isLoading = false;
    });
  }

  Future<void> _completeDay(int index) async {
    await _service.completeDay(index);
    await _loadData(); // রিলোড
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 দিন ${index + 1} সম্পন্ন!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final completedCount = _days.where((d) => d.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌱 দীপ্ত যাত্রা'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          // প্রগ্রেস বার ও প্ল্যান্ট ইমোজি
          Container(
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
                      '🌿 $completedCount/${_days.length} দিন',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
                  '${(_progress * 100).toInt()}% সম্পন্ন',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          // দিনের গ্রিড
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

  // প্রগ্রেস অনুযায়ী প্ল্যান্ট ইমোজি
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
      iconColor = Colors.grey[600]!;  // 🔥 ফিক্স: ! যোগ করা হয়েছে
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
                'দিন ${day.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: day.isUnlocked ? Colors.black87 : Colors.grey[600],
                ),
              ),
              if (day.isCompleted)
                const Text(
                  '✅',
                  style: TextStyle(fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
