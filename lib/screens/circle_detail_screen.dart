import 'package:flutter/material.dart';
import '../models/circle_model.dart';
import '../generated/l10n/app_localizations.dart';

class CircleDetailScreen extends StatefulWidget {
  final Circle circle;
  final String userId;
  const CircleDetailScreen({
    super.key,
    required this.circle,
    required this.userId,
  });

  @override
  State<CircleDetailScreen> createState() => _CircleDetailScreenState();
}

class _CircleDetailScreenState extends State<CircleDetailScreen> {
  late Circle _circle;

  @override
  void initState() {
    super.initState();
    _circle = widget.circle;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final sortedLeaderboard = _circle.leaderboard.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: Text(_circle.name),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        _circle.description.isNotEmpty
                            ? _circle.description
                            : 'No description',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.code, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Invite Code: ${_circle.inviteCode}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.people, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('${_circle.members.length} members'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '🏆 ${local.score}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (sortedLeaderboard.isEmpty)
              const Center(child: Text('No members'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedLeaderboard.length,
                itemBuilder: (context, index) {
                  final entry = sortedLeaderboard[index];
                  final isCurrentUser = entry.key == widget.userId;
                  final rank = index + 1;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isCurrentUser ? Colors.orange[50] : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: isCurrentUser
                          ? Border.all(color: Colors.orange, width: 2)
                          : Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _getRankColor(rank),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$rank',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'User ${entry.key.substring(0, 6)}...',
                            style: TextStyle(
                              fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                              color: isCurrentUser ? Colors.orange : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '${entry.value} ${local.xp}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber[700]!;
    if (rank == 2) return Colors.grey[500]!;
    if (rank == 3) return Colors.brown[400]!;
    return Colors.blueGrey[300]!;
  }
}
