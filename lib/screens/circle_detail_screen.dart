import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/circle_model.dart';
import '../generated/l10n/app_localizations.dart';
import '../services/user_profile_service.dart';
import '../services/auth_service.dart';

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
  final UserProfileService _profileService = UserProfileService();
  final AuthService _auth = AuthService();
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = true;
  bool _isAdmin = false;
  String _inviteLink = '';

  @override
  void initState() {
    super.initState();
    _checkAdmin();
    _loadMembers();
    _generateInviteLink();
  }

  void _checkAdmin() {
    setState(() {
      _isAdmin = widget.circle.createdBy == widget.userId;
    });
  }

  Future<void> _loadMembers() async {
    setState(() => _isLoading = true);
    try {
      final members = await _profileService.getCircleMembersProfiles(widget.circle.members);
      setState(() {
        _members = members;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('❌ Error loading members: $e');
    }
  }

  void _generateInviteLink() {
    _inviteLink = 'https://DONG0777.github.io/swadhyay/?invite=${widget.circle.inviteCode}';
  }

  void _shareInviteLink() async {
    final text =
        '🌟 স্বাধ্যায় সার্কেলে যোগ দিন!\n'
        'সার্কেল: ${widget.circle.name}\n'
        'ইনভাইট কোড: ${widget.circle.inviteCode}\n'
        'লিংক: $_inviteLink';
    final encoded = Uri.encodeComponent(text);
    final url = Uri.parse('https://wa.me/?text=$encoded');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ শেয়ার করতে সমস্যা!'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final sortedLeaderboard = widget.circle.leaderboard.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.circle.name),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_isAdmin)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareInviteLink,
              tooltip: 'ইনভাইট লিংক শেয়ার করুন',
            ),
        ],
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
                      Expanded(
                        child: Text(
                          widget.circle.description.isNotEmpty
                              ? widget.circle.description
                              : 'No description',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.code, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'ইনভাইট কোড: ${widget.circle.inviteCode}',
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
                      Text('${widget.circle.members.length} জন সদস্য'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (_isAdmin)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _shareInviteLink,
                  icon: const Icon(Icons.share),
                  label: const Text('📤 ইনভাইট লিংক শেয়ার করুন'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),

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
