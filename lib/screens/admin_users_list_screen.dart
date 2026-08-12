import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminUsersListScreen extends StatefulWidget {
  const AdminUsersListScreen({super.key});

  @override
  State<AdminUsersListScreen> createState() => _AdminUsersListScreenState();
}

class _AdminUsersListScreenState extends State<AdminUsersListScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final response = await supabase
          .from('user_profiles')
          .select('*')
          .order('created_at', ascending: false);
      setState(() {
        _users = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('❌ Error loading users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _users.where((user) {
      final name = (user['display_name'] ?? '').toLowerCase(); // 🔥 full_name → display_name
      final phone = (user['phone_number'] ?? '').toLowerCase();
      final city = (user['city'] ?? '').toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || phone.contains(query) || city.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('👥 ইউজার লিস্ট'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: '🔍 নাম, ফোন বা শহর দিয়ে খুঁজুন',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredUsers.isEmpty
                    ? const Center(child: Text('কোনো ইউজার নেই'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange,
                                child: Text(
                                  (user['display_name'] ?? 'U')[0].toUpperCase(), // 🔥 full_name → display_name
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(user['display_name'] ?? 'অজ্ঞাত'), // 🔥 full_name → display_name
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (user['phone_number'] != null)
                                    Text('📱 ${user['phone_number']}'),
                                  if (user['city'] != null)
                                    Text('📍 ${user['city']}'),
                                  if (user['blood_group'] != null)
                                    Text('🩸 ${user['blood_group']}'),
                                ],
                              ),
                              trailing: Text(
                                user['created_at'] != null
                                    ? DateTime.parse(user['created_at']).toLocal().toString().split(' ')[0]
                                    : '',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
