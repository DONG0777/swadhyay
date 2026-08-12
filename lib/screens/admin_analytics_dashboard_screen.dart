import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/download_service.dart';

class AdminAnalyticsDashboardScreen extends StatefulWidget {
  const AdminAnalyticsDashboardScreen({super.key});

  @override
  State<AdminAnalyticsDashboardScreen> createState() => _AdminAnalyticsDashboardScreenState();
}

class _AdminAnalyticsDashboardScreenState extends State<AdminAnalyticsDashboardScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _locationData = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final users = await supabase.from('user_profiles').select('user_id, display_name, city, phone_number');
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7)).toIso8601String();
      final activeUsers = await supabase
          .from('center_attendances')
          .select('user_id')
          .gte('check_in_date', sevenDaysAgo);
      
      final activeUserIds = activeUsers.map((e) => e['user_id'] as String).toSet();

      final Map<String, Map<String, dynamic>> cityMap = {};
      for (final user in users) {
        final city = user['city'] as String? ?? 'অজ্ঞাত';
        final userId = user['user_id'] as String;
        
        if (!cityMap.containsKey(city)) {
          cityMap[city] = {
            'city': city,
            'total': 0,
            'active': 0,
            'users': <String>[],
          };
        }
        cityMap[city]!['total'] = cityMap[city]!['total'] + 1;
        if (activeUserIds.contains(userId)) {
          cityMap[city]!['active'] = cityMap[city]!['active'] + 1;
        }
        cityMap[city]!['users'].add(user['display_name'] ?? userId);
      }

      final List<Map<String, dynamic>> result = cityMap.values.map((data) {
        return {
          'city': data['city'],
          'total': data['total'],
          'active': data['active'],
          'inactive': data['total'] - data['active'],
          'percentage': data['total'] > 0 ? (data['active'] / data['total'] * 100).toStringAsFixed(1) : '0.0',
          'users': data['users'],
        };
      }).toList()
        ..sort((a, b) => b['active'].compareTo(a['active']));

      setState(() {
        _locationData = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading data: $e';
        _isLoading = false;
      });
      print('❌ Error: $e');
    }
  }

  void _downloadCSV() {
    if (_locationData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ কোনো ডেটা নেই!'), backgroundColor: Colors.orange),
      );
      return;
    }

    final csvData = _locationData.map((row) => {
      'শহর': row['city'],
      'মোট ইউজার': row['total'],
      'সক্রিয় (৭ দিন)': row['active'],
      'নিষ্ক্রিয়': row['inactive'],
      'সক্রিয়তা (%)': row['percentage'],
    }).toList();

    DownloadService.downloadCSV(csvData, 'location_analytics');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 লোকেশন অ্যানালিটিক্স'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadCSV,
            tooltip: 'CSV ডাউনলোড',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('আবার চেষ্টা করুন'),
                      ),
                    ],
                  ),
                )
              : _locationData.isEmpty
                  ? const Center(child: Text('কোনো লোকেশন ডেটা নেই'))
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              _buildSummaryCard('🏙️ মোট শহর', '${_locationData.length}', Colors.blue),
                              const SizedBox(width: 12),
                              _buildSummaryCard('👥 মোট ইউজার', '${_locationData.fold<int>(0, (sum, item) => sum + (item['total'] as int))}', Colors.green),
                              const SizedBox(width: 12),
                              _buildSummaryCard('🟢 সক্রিয়', '${_locationData.fold<int>(0, (sum, item) => sum + (item['active'] as int))}', Colors.orange),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton.icon(
                            onPressed: _downloadCSV,
                            icon: const Icon(Icons.download),
                            label: const Text('📥 CSV ডাউনলোড করুন'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: _locationData.length,
                            itemBuilder: (context, index) {
                              final item = _locationData[index];
                              final rank = index + 1;
                              final activePercent = double.tryParse(item['percentage']) ?? 0;
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: rank <= 3 ? Colors.amber[700] : Colors.grey[300],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '$rank',
                                              style: TextStyle(
                                                color: rank <= 3 ? Colors.white : Colors.black87,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              item['city'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: activePercent >= 50 ? Colors.green[100] : Colors.red[100],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              '${item['percentage']}%',
                                              style: TextStyle(
                                                color: activePercent >= 50 ? Colors.green[800] : Colors.red[800],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      LinearProgressIndicator(
                                        value: activePercent / 100,
                                        backgroundColor: Colors.grey[200],
                                        color: activePercent >= 50 ? Colors.green : Colors.red,
                                        minHeight: 8,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.people, size: 16, color: Colors.grey[600]),
                                          const SizedBox(width: 4),
                                          Text(
                                            '👥 ${item['total']} জন',
                                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                          ),
                                          const SizedBox(width: 16),
                                          Icon(Icons.circle, size: 12, color: Colors.green),
                                          const SizedBox(width: 4),
                                          Text(
                                            '🟢 ${item['active']} জন',
                                            style: TextStyle(fontSize: 12, color: Colors.green[700]),
                                          ),
                                          const SizedBox(width: 16),
                                          Icon(Icons.circle, size: 12, color: Colors.red),
                                          const SizedBox(width: 4),
                                          Text(
                                            '🔴 ${item['inactive']} জন',
                                            style: TextStyle(fontSize: 12, color: Colors.red[700]),
                                          ),
                                        ],
                                      ),
                                    ],
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

  Widget _buildSummaryCard(String title, String value, Color color) {
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
}
