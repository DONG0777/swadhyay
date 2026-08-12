import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminLocationScreen extends StatefulWidget {
  const AdminLocationScreen({super.key});

  @override
  State<AdminLocationScreen> createState() => _AdminLocationScreenState();
}

class _AdminLocationScreenState extends State<AdminLocationScreen> {
  final supabase = Supabase.instance.client;
  Map<String, int> _cityCounts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    setState(() => _isLoading = true);
    try {
      final response = await supabase
          .from('user_profiles')
          .select('city');
      
      final cities = <String, int>{};
      for (final item in response) {
        final city = item['city'] as String?;
        if (city != null && city.isNotEmpty) {
          cities[city] = (cities[city] ?? 0) + 1;
        }
      }
      setState(() {
        _cityCounts = cities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('❌ Error loading locations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedEntries = _cityCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('📍 লোকেশন অ্যানালিটিক্স'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLocations,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : sortedEntries.isEmpty
              ? const Center(child: Text('কোনো লোকেশন ডেটা নেই'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedEntries.length,
                  itemBuilder: (context, index) {
                    final entry = sortedEntries[index];
                    final percentage = _cityCounts.values.isNotEmpty
                        ? (entry.value / _cityCounts.values.reduce((a, b) => a + b)) * 100
                        : 0;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange[100],
                          child: Text(
                            entry.value.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(entry.key),
                        trailing: Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
