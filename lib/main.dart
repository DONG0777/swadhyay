import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://hgdfxziykvsggagghesb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhnZGZ4eml5a3ZzZ2dhZ2doZXNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODYxMjI0NDksImV4cCI6MjEwMTY5ODQ0OX0.tcHn6XRtafgG8CrxYniJlN5CUnIO2Og2etjiODWSXqc',
  );
  runApp(const SwadhyayApp());
}

class SwadhyayApp extends StatelessWidget {
  const SwadhyayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swadhyay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF6B00),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B00),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B00),
          primary: const Color(0xFFFF6B00),
          secondary: const Color(0xFFFFD700),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(), // 🔥 লগইন স্ক্রিন দিয়ে শুরু
    );
  }
}
