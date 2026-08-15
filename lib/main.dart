import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/profile/profile_edit_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://hgdfxziykvsggagghesb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhnZGZ4eml5a3ZzZ2dhZ2doZXNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDk4NzY1NDMsImV4cCI6MjAyNTQ1MjU0M30.9vZkf7YqZJfQhHgKqRpv4GcG1tVnYvEGpLqyDk2bJzQ',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swadhyay',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> _getUserProfile() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        final response = await supabase
            .from('profiles')
            .select()
            .eq('id', userId)
            .single();
        return response;
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.sunny, size: 28),
            SizedBox(width: 8),
            Text('???????', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.public), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileEditScreen(),
                ),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: const Color(0xFF388E3C),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '?????? - ???? ???? ????',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            FutureBuilder<Map<String, dynamic>>(
              future: _getUserProfile(),
              builder: (context, snapshot) {
                String displayName = 'Sukanta';
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  displayName = snapshot.data!['full_name'] ?? 'Sukanta';
                }
                return Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.orangeAccent, blurRadius: 15, spreadRadius: 2)],
                      ),
                      child: Icon(Icons.sunny, size: 50, color: Colors.orange.shade700),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '???????, $displayName!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: _buildStatCard(Icons.local_fire_department, '???????', '0 days')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildStatCard(Icons.star, '??????', '0')),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(Colors.orange.shade700, Icons.play_arrow, '???? ???? ????'),
                  _buildActionButton(const Color(0xFF2E7D32), Icons.eco, '??? ????'),
                  _buildActionButton(const Color(0xFF1565C0), Icons.people_alt, '???????'),
                  _buildActionButton(const Color(0xFF43A047), Icons.location_on, '??????'),
                  _buildActionButton(const Color(0xFF7B1FA2), Icons.verified_user, '??????? ?????????'),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.orange.shade700, size: 24),
          const SizedBox(height: 5),
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          const SizedBox(height: 5),
          Text(value, style: TextStyle(color: Colors.orange.shade800, fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionButton(Color color, IconData icon, String label) {
    return Container(
      width: 65,
      height: 75,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
