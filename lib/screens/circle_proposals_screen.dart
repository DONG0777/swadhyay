import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'propose_circle_screen.dart'; // 🔥 ইম্পোর্ট যোগ করা হয়েছে
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
          .inFilter('status', ['pending', 'gps_verified', 'vouching', 'voting', 'active'])
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

  Future<void> _vote(String proposalId, bool vote) async {
    final userId = _auth.userId;
    if (userId == 'guest_123') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🔑 দয়া করে লগইন করুন'), backgroundColor: Colors.orange),
      );
      return;
    }

    try {
      final existing = await supabase
          .from('circle_proposal_votes')
          .select('id')
          .eq('proposal_id', proposalId)
          .eq('voter_id', userId)
          .maybeSingle();

      if (existing != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ আপনি ইতিমধ্যে ভোট দিয়েছেন!'), backgroundColor: Colors.orange),
        );
        return;
      }

      await supabase.from('circle_proposal_votes').insert({
        'proposal_id': proposalId,
        'voter_id': userId,
        'vote': vote,
      });

      final votes = await supabase
          .from('circle_proposal_votes')
          .select('vote')
          .eq('proposal_id', proposalId);
      
      final totalVotes = votes.length;
      final positiveVotes = votes.where((v) => v['vote'] == true).length;

      String newStatus = 'voting';
      if (totalVotes >= 6 && positiveVotes >= 4) {
        newStatus = 'active';
      } else if (totalVotes >= 6 && positiveVotes < 4) {
        newStatus = 'rejected';
      }

      await supabase
          .from('community_centers')
          .update({
            'vote_count': totalVotes,
            'status': newStatus,
          })
          .eq('id', proposalId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vote ? '✅ সমর্থন দিয়েছেন!' : '❌ বিপক্ষে ভোট দিয়েছেন!'),
          backgroundColor: vote ? Colors.green : Colors.red,
        ),
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
        title: const Text('🌍 সার্বিক সার্কেল প্রস্তাব'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProposeCircleScreen()),
              );
            },
            tooltip: 'নতুন প্রস্তাব দিন',
          ),
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
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.hourglass_empty, size: 80, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            'কোনো প্রস্তাব নেই',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'আপনি প্রথম সার্বিক সার্কেলের প্রস্তাব দিন!',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProposeCircleScreen()),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('📤 প্রস্তাব দিন'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B00),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _proposals.length,
                      itemBuilder: (context, index) {
                        final proposal = _proposals[index];
                        final status = proposal['status'] ?? 'pending';
                        final voteCount = proposal['vote_count'] ?? 0;
                        final userId = _auth.userId;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: _getStatusColor(status),
                                      child: Icon(
                                        status == 'active' ? Icons.check : 
                                        status == 'rejected' ? Icons.close : 
                                        Icons.pending,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            proposal['name'] ?? 'নাম নেই',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '📌 স্ট্যাটাস: $status',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: _getStatusColor(status),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '$voteCount ভোট',
                                        style: TextStyle(
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  proposal['description'] ?? 'কোনো বিবরণ নেই',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${proposal['proposed_latitude']?.toStringAsFixed(4)}, ${proposal['proposed_longitude']?.toStringAsFixed(4)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (status == 'pending' || status == 'gps_verified' || status == 'vouching' || status == 'voting')
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (userId != 'guest_123') ...[
                                        ElevatedButton.icon(
                                          onPressed: () => _vote(proposal['id'], true),
                                          icon: const Icon(Icons.thumb_up, size: 16),
                                          label: const Text('সমর্থন'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton.icon(
                                          onPressed: () => _vote(proposal['id'], false),
                                          icon: const Icon(Icons.thumb_down, size: 16),
                                          label: const Text('বিপক্ষে'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacementNamed(context, '/login');
                                          },
                                          child: const Text('🔑 লগইন করে ভোট দিন'),
                                        ),
                                      ],
                                    ],
                                  ),
                                if (status == 'active')
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          '✅ সক্রিয়',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (status == 'rejected')
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.close, color: Colors.red, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          '❌ প্রত্যাখ্যাত',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
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
