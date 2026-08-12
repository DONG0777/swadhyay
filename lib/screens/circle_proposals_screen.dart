import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../generated/l10n/app_localizations.dart';

class CircleProposalsScreen extends StatefulWidget {
  const CircleProposalsScreen({super.key});

  @override
  State<CircleProposalsScreen> createState() => _CircleProposalsScreenState();
}

class _CircleProposalsScreenState extends State<CircleProposalsScreen> {
  final supabase = Supabase.instance.client;
  final AuthService _auth = AuthService();
  List<Map<String, dynamic>> _proposals = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProposals();
  }

  Future<void> _loadProposals() async {
    setState(() => _isLoading = true);
    try {
      final response = await supabase
          .from('community_centers')
          .select('*')
          .eq('center_type', 'universal')
          .inFilter('status', ['pending', 'gps_verified', 'vouching', 'voting'])
          .order('created_at', ascending: false);
      setState(() {
        _proposals = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading proposals: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateStatus(String proposalId, String status) async {
    try {
      await supabase
          .from('community_centers')
          .update({'status': status})
          .eq('id', proposalId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ স্ট্যাটাস পরিবর্তন: $status'), backgroundColor: Colors.green),
      );
      _loadProposals();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 সার্বিক সার্কেল প্রস্তাব'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProposals,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _proposals.isEmpty
                  ? const Center(child: Text('কোনো প্রস্তাব নেই'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _proposals.length,
                      itemBuilder: (context, index) {
                        final proposal = _proposals[index];
                        final status = proposal['status'] ?? 'pending';
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(proposal['name'] ?? 'নাম নেই'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('📍 ${proposal['proposed_location'] ?? 'ঠিকানা নেই'}'),
                                Text('👤 ${proposal['created_by'] ?? ''}'),
                                Text('📌 স্ট্যাটাস: $status', style: TextStyle(color: _getStatusColor(status))),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (status == 'pending')
                                  IconButton(
                                    icon: const Icon(Icons.check_circle, color: Colors.green),
                                    onPressed: () => _updateStatus(proposal['id'], 'gps_verified'),
                                    tooltip: 'GPS ভেরিফাইড',
                                  ),
                                if (status == 'gps_verified')
                                  IconButton(
                                    icon: const Icon(Icons.thumb_up, color: Colors.blue),
                                    onPressed: () => _updateStatus(proposal['id'], 'active'),
                                    tooltip: 'অ্যাক্টিভ করুন',
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('প্রস্তাব ডিলিট?'),
                                        content: Text('"${proposal['name']}" ডিলিট করবেন?'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('না')),
                                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('হ্যাঁ', style: TextStyle(color: Colors.red))),
                                        ],
                                      ),
                                    );
                                    if (confirm ?? false) {
                                      await supabase
                                          .from('community_centers')
                                          .update({'status': 'rejected'})
                                          .eq('id', proposal['id']);
                                      _loadProposals();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'gps_verified': return Colors.blue;
      case 'vouching': return Colors.purple;
      case 'voting': return Colors.teal;
      case 'active': return Colors.green;
      case 'rejected': return Colors.red;
      default: return Colors.grey;
    }
  }
}
