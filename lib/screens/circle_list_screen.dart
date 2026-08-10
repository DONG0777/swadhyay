import 'package:flutter/material.dart';
import '../services/circle_service.dart';
import '../models/circle_model.dart';
import 'circle_create_screen.dart';
import 'circle_detail_screen.dart';

class CircleListScreen extends StatefulWidget {
  final String userId;

  const CircleListScreen({super.key, required this.userId});

  @override
  State<CircleListScreen> createState() => _CircleListScreenState();
}

class _CircleListScreenState extends State<CircleListScreen> {
  final CircleService _service = CircleService();
  List<Circle> _circles = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCircles();
  }

  Future<void> _loadCircles() async {
    try {
      final circles = await _service.getUserCircles(widget.userId);
      setState(() {
        _circles = circles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'সার্কেল লোড করতে সমস্যা: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _joinCircle() async {
    final code = await _showJoinDialog();
    if (code != null && code.isNotEmpty) {
      try {
        final circle = await _service.joinCircle(code, widget.userId);
        setState(() {
          _circles.add(circle);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ সার্কেলে জয়েন করেছেন!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ $e')),
        );
      }
    }
  }

  Future<String?> _showJoinDialog() {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('সার্কেলে জয়েন করুন'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'ইনভাইট কোড',
            hintText: 'XXXXXX',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim().toUpperCase()),
            child: const Text('জয়েন করুন'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔄 আমার সার্কেল'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CircleCreateScreen(),
                ),
              );
              if (result != null) {
                _loadCircles();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: _joinCircle,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _circles.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.group_off, size: 80, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            'আপনি এখনো কোনো সার্কেলে জয়েন করেননি',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '🔝 ডান পাশের + বাটন দিয়ে সার্কেল তৈরি করুন',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            'অথবা 📥 বাটন দিয়ে ইনভাইট কোড দিয়ে জয়েন করুন',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _circles.length,
                      itemBuilder: (context, index) {
                        final circle = _circles[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange[100],
                              child: Text(
                                circle.name[0].toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            title: Text(
                              circle.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '👥 ${circle.members.length} সদস্য • 📝 ${circle.leaderboard.length} জন সক্রিয়',
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CircleDetailScreen(
                                    circle: circle,
                                    userId: widget.userId,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
