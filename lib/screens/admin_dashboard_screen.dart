import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../models/question_model.dart';
import '../generated/l10n/app_localizations.dart';
import '../services/admin_analytics_service.dart';
import '../services/auth_service.dart';
import 'admin_content_manager_screen.dart';
import 'admin_notification_screen.dart';
import 'admin_users_list_screen.dart';
import 'admin_location_screen.dart';
import 'admin_analytics_dashboard_screen.dart';
import 'circle_proposals_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminService _service = AdminService();
  final AdminAnalyticsService _analytics = AdminAnalyticsService();
  final AuthService _auth = AuthService();
  List<Question> _questions = [];
  bool _isLoading = true;
  String? _error;

  int _totalUsers = 0;
  int _activeUsers = 0;
  int _totalCircles = 0;
  List<Map<String, dynamic>> _weeklyGrowth = [];
  List<Map<String, dynamic>> _contentStats = [];
  Map<String, int> _locationStats = {};

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    try {
      final questions = await _service.getAllQuestions();
      final totalUsers = await _analytics.getTotalUsers();
      final activeUsers = await _analytics.getActiveUsersLast7Days();
      final totalCircles = await _analytics.getTotalCircles();

      final weeklyGrowth = List.generate(7, (i) {
        final date = DateTime.now().subtract(Duration(days: 6 - i));
        return {
          'date': date,
          'count': (totalUsers / 7 * (i + 1)).round(),
        };
      });

      final contentStats = [
        {'type': 'শ্লোক', 'count': 45},
        {'type': 'উক্তি', 'count': 30},
        {'type': 'বই', 'count': 20},
        {'type': 'সূর্য', 'count': 35},
        {'type': 'কর্তব্য', 'count': 25},
      ];

      final locationStats = {
        'ঢাকা': 12,
        'চট্টগ্রাম': 8,
        'রংপুর': 5,
        'খুলনা': 4,
        'সিলেট': 3,
      };

      setState(() {
        _questions = questions;
        _totalUsers = totalUsers;
        _activeUsers = activeUsers;
        _totalCircles = totalCircles;
        _weeklyGrowth = weeklyGrowth;
        _contentStats = contentStats;
        _locationStats = locationStats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('⚙️ ${local.admin}'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildAnalyticsCard('👥 মোট ইউজার', '$_totalUsers', Colors.blue),
                          const SizedBox(width: 12),
                          _buildAnalyticsCard('🟢 সক্রিয় (৭ দিন)', '$_activeUsers', Colors.green),
                          const SizedBox(width: 12),
                          _buildAnalyticsCard('🔄 মোট সার্কেল', '$_totalCircles', Colors.orange),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('📈 সাপ্তাহিক ইউজার গ্রোথ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 120,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: _weeklyGrowth.map((data) {
                                  final count = data['count'] as int;
                                  final maxCount = _weeklyGrowth.fold(0, (max, e) => e['count'] > max ? e['count'] : max);
                                  final height = maxCount > 0 ? (count / maxCount) * 100 : 0;
                                  return Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                          ),
                                          height: height.toDouble(),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${data['date'].day}/${data['date'].month}',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: _cardDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('📊 কন্টেন্ট এনগেজমেন্ট', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  ..._contentStats.map((item) {
                                    final count = item['count'] as int;
                                    final maxCount = _contentStats.fold(0, (max, e) => e['count'] > max ? e['count'] : max);
                                    final percent = maxCount > 0 ? (count / maxCount) * 100 : 0;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 50, child: Text(item['type'], style: const TextStyle(fontSize: 11))),
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child: LinearProgressIndicator(
                                                value: percent / 100,
                                                backgroundColor: Colors.grey[200],
                                                color: Colors.orange,
                                                minHeight: 10,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text('$count', style: const TextStyle(fontSize: 11)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: _cardDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('🌍 লোকেশন ডিস্ট্রিবিউশন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 120,
                                    child: _buildLocationDonut(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildActionButton(icon: Icons.add, label: 'প্রশ্ন যোগ', color: Colors.green, onPressed: () => _showAddEditDialog()),
                          _buildActionButton(icon: Icons.upload_file, label: 'JSON আপলোড', color: Colors.blue, onPressed: _showBulkUploadDialog),
                          _buildActionButton(icon: Icons.library_books, label: 'কন্টেন্ট', color: Colors.purple, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminContentManagerScreen()))),
                          _buildActionButton(icon: Icons.notifications_active, label: 'নোটিফিকেশন', color: Colors.deepOrange, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminNotificationScreen(adminId: _auth.userId, circleId: 'YOUR_CIRCLE_ID')))),
                          _buildActionButton(icon: Icons.people, label: 'ইউজার লিস্ট', color: Colors.indigo, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminUsersListScreen()))),
                          _buildActionButton(icon: Icons.location_on, label: 'লোকেশন', color: Colors.teal, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminLocationScreen()))),
                          _buildActionButton(icon: Icons.analytics, label: 'অ্যানালিটিক্স', color: Colors.deepPurple, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAnalyticsDashboardScreen()))),
                          // 🔥 নতুন প্রস্তাব বাটন
                          _buildActionButton(
                            icon: Icons.pending_actions,
                            label: 'প্রস্তাব',
                            color: Colors.purpleAccent,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CircleProposalsScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        '📋 প্রশ্ন তালিকা',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _questions.isEmpty
                          ? const Center(child: Text('কোনো প্রশ্ন নেই'))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _questions.length,
                              itemBuilder: (context, index) {
                                final q = _questions[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: q.isActive ? Colors.green : Colors.red,
                                      child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                                    ),
                                    title: Text(q.questionText, maxLines: 2, overflow: TextOverflow.ellipsis),
                                    subtitle: Text('${q.category ?? 'No category'} • ${q.correctOption}', style: const TextStyle(fontSize: 12)),
                                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showAddEditDialog(question: q)),
                                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Delete?'),
                                            content: Text('Delete "${q.questionText}"?'),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
                                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes', style: TextStyle(color: Colors.red))),
                                            ],
                                          ),
                                        );
                                        if (confirm ?? false) { await _service.deleteQuestion(q.id!); _loadAllData(); }
                                      }),
                                    ]),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 2))],
    );
  }

  Widget _buildAnalyticsCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 48) / 3,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 11)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildLocationDonut() {
    final total = _locationStats.values.reduce((a, b) => a + b);
    if (total == 0) return const Center(child: Text('কোনো ডেটা নেই'));

    List<MapEntry<String, int>> entries = _locationStats.entries.toList();
    double startAngle = -90;

    return Stack(
      alignment: Alignment.center,
      children: [
        ...entries.map((entry) {
          final percent = (entry.value / total) * 100;
          final sweepAngle = (percent / 100) * 360;
          final color = Colors.primaries[entries.indexOf(entry) % Colors.primaries.length];
          return Container(
            width: 100,
            height: 100,
            child: CustomPaint(
              painter: _DonutPainter(
                startAngle: startAngle,
                sweepAngle: sweepAngle,
                color: color,
              ),
            ),
          );
        }).toList(),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('মোট', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Future<void> _showAddEditDialog({Question? question}) async {}
  Future<void> _showBulkUploadDialog() async {}
}

class _DonutPainter extends CustomPainter {
  final double startAngle;
  final double sweepAngle;
  final Color color;

  _DonutPainter({required this.startAngle, required this.sweepAngle, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle * 3.14159 / 180, sweepAngle * 3.14159 / 180, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
