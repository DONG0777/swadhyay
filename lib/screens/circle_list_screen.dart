import 'package:flutter/material.dart';
import '../services/circle_service.dart';
import '../models/circle_model.dart';
import 'circle_type_selection_screen.dart';
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
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    _isGuest = widget.userId == 'guest_123';
    _loadCircles();
  }

  Future<void> _loadCircles() async {
    setState(() => _isLoading = true);
    try {
      final circles = await _service.getUserCircles(widget.userId);
      setState(() {
        _circles = circles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading circles: $e';
        _isLoading = false;
      });
    }
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
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CircleTypeSelectionScreen()),
              );
              if (result == true) {
                _loadCircles();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCircles,
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
                            'কোনো সার্কেল নেই',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '🔝 ডান পাশের + বাটন দিয়ে সার্কেল তৈরি শুরু করুন',
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
                              '👥 ${circle.members.length} সদস্য',
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
