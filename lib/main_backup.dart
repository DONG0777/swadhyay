import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'generated/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(
      url: 'https://hgdfxziykvsggagghesb.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhnZGZ4eml5a3ZzZ2dhZ2doZXNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODYxMjI0NDksImV4cCI6MjEwMTY5ODQ0OX0.tcHn6XRtafgG8CrxYniJlN5CUnIO2Og2etjiODWSXqc',
    );
    print('✅ Supabase initialized!');
  } catch (e) {
    print('❌ Supabase error: $e');
  }
  runApp(const SwadhyayApp());
}

class SwadhyayApp extends StatefulWidget {
  const SwadhyayApp({super.key});

  @override
  State<SwadhyayApp> createState() => _SwadhyayAppState();
}

class _SwadhyayAppState extends State<SwadhyayApp> {
  Locale _locale = const Locale('bn');

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _handleAuthRedirect();
  }

  void _handleAuthRedirect() {
    // Web-এ OAuth রিডাইরেক্ট হ্যান্ডেল করুন
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final supabase = Supabase.instance.client;
      try {
        // ইউজার ইতিমধ্যে লগইন আছে কিনা চেক করুন
        final session = supabase.auth.currentSession;
        if (session != null) {
          print('✅ User already logged in: ${session.user.id}');
        }
      } catch (e) {
        print('⚠️ Auth check error: $e');
      }
    });
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('selected_language') ?? 'bn';
    setState(() => _locale = Locale(langCode));
  }

  void changeLanguage(Locale locale) async {
    setState(() => _locale = locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swadhyay',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('bn'), Locale('hi'), Locale('en')],
      routes: {
        '/login': (context) => LoginScreen(onLanguageChanged: changeLanguage),
        '/home': (context) => HomeScreen(onLanguageChanged: changeLanguage),
      },
      theme: ThemeData(
        primaryColor: const Color(0xFFFF6B00),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF6B00),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF6B00),
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF444444),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF555555),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFF6B00),
          secondary: Color(0xFFFFD700),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.black87,
          onSurface: Color(0xFF333333),
        ),
        useMaterial3: true,
      ),
      home: LoginScreen(onLanguageChanged: changeLanguage),
    );
  }
}
