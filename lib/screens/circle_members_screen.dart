import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../generated/l10n/app_localizations.dart';

class CircleMembersScreen extends StatefulWidget {
  final String circleId;
  final String adminId;

  const CircleMembersScreen({
    super.key,
    required this.circleId,
    required this.adminId,
  });

  @override
  State<CircleMembersScreen> createState() => _CircleMembersScreenState();
}

class _CircleMembersScreenState extends State<CircleMembersScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    setState(() => _isLoading = true);
    try {
      // ১. সার্কেলের সদস্যদের আইডি বের করুন
      final circle = await supabase
          .from('community_centers')
          .select('members, created_by')
          .eq('id', widget.circleId)
          .single();

      final List<String> memberIds = List<String>.from(circle['members'] ?? []);
      final String createdBy = circle['created_by'] ?? '';

      if (memberIds.isEmpty) {
        setState(() {
          _members = [];
          _isLoading = false;
        });
        return;
      }

      // ২. প্রতিটি সদস্যের প্রোফাইল ও শেষ উপস্থিতি লোড করুন
      final List<Map<String, dynamic>> membersData = [];
      for (final userId in memberIds) {
        // প্রোফাইল
        final profile = await supabase
            .from('user_profiles')
            .select('*')
            .eq('user_id', userId)
            .maybeSingle();

        // শেষ উপস্থিতি (সার্কেল অ্যাটেন্ডেন্স থেকে)
        final attendance = await supabase
            .from('center_attendances')
            .select('check_in_date')
            .eq('user_id', userId)
            .eq('center_id', widget.circleId)
            .order('check_in_date', ascending: false)
            .limit(1)
            .maybeSingle();

        if (profile != null) {
          membersData.add({
            ...profile,
            'last_active': attendance?['check_in_date'],
            'is_admin': userId == createdBy,
          });
        }
      }

      setState(() {
        _members = membersData;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading members: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _contactMember(String phone, String name) async {
    if (phone.isEmpty || phone == 'N/A') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ মোবাইল নম্বর নেই'), backgroundColor: Colors.orange),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('📞 $name এর সাথে যোগাযোগ করুন', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse('tel:$phone');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text('কল করুন'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse('https://wa.me/91$phone');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('হোয়াটসঅ্যাপ'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('বন্ধ করুন'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('👥 সদস্য তালিকা (${_members.length})'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMembers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _members.isEmpty
              ? const Center(child: Text('এই সার্কেলে এখনও কোনো সদস্য নেই'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _members.length,
                  itemBuilder: (context, index) {
                    final member = _members[index];
                    final isAdmin = member['is_admin'] ?? false;
                    final lastActive = member['last_active'];
                    final daysAgo = lastActive != null
                        ? DateTime.now().difference(DateTime.parse(lastActive)).inDays
                        : null;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isAdmin ? Colors.green : Colors.orange,
                          child: Text(
                            (member['display_name'] ?? 'U')[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(member['display_name'] ?? 'অজ্ঞাত'),
                            if (isAdmin) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'ADMIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('📱 ${member['phone'] ?? 'N/A'}'),
                            Text('📍 ${member['city'] ?? 'N/A'}'),
                            if (member['blood_group'] != null)
                              Text('🩸 ${member['blood_group']}'),
                            if (daysAgo != null)
                              Text(
                                '🟢 শেষ উপস্থিতি: ${daysAgo == 0 ? "আজ" : "$daysAgo দিন আগে"}',
                                style: TextStyle(
                                  color: daysAgo <= 3 ? Colors.green : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.phone, color: Colors.green),
                          onPressed: () => _contactMember(
                            member['phone'] ?? '',
                            member['display_name'] ?? '',
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
