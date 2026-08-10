import 'package:flutter/material.dart';
import '../services/circle_service.dart';
import '../models/circle_model.dart';
import 'circle_create_screen.dart';
import 'circle_detail_screen.dart';
import '../generated/l10n/app_localizations.dart';

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
        _error = '${AppLocalizations.of(context).welcome}: $e';
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
        final local = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ ${local.circle} ${local.score}!')),
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
    final local = AppLocalizations.of(context);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(local.circle),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Invite Code',
            hintText: 'XXXXXX',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(local.backHome),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim().toUpperCase()),
            child: Text(local.circle),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('🔄 ${local.circle}'),
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
                          Text(local.circle),
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
                              '👥 ${circle.members.length} members • 📝 ${circle.leaderboard.length} active',
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
