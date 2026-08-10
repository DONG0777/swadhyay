import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import '../generated/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  const LoginScreen({super.key, required this.onLanguageChanged});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      await _auth.signInWithGoogle();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(onLanguageChanged: widget.onLanguageChanged),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ ${AppLocalizations.of(context).welcome}: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF6B00),
              Color(0xFFFF8C00),
              Colors.white,
            ],
            stops: [0.0, 0.4, 0.8],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ===== সূর্যের লোগো (কমলা + সাদা) =====
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.wb_sunny,
                      size: 70,
                      color: Color(0xFFFF6B00),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // ===== টাইটেল =====
                  Text(
                    '☀️ ${local.appTitle}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(blurRadius: 8, color: Colors.black26, offset: Offset(0, 2)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // ===== ট্যাগলাইন =====
                  Text(
                    local.tagline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      shadows: [
                        Shadow(blurRadius: 6, color: Colors.black26, offset: Offset(0, 1)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // ===== Google বাটন =====
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _signIn,
                            icon: const Icon(Icons.account_circle, color: Color(0xFFFF6B00)),
                            label: Text(
                              local.googleLogin,
                              style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF333333),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              shadowColor: Colors.black12,
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),
                  
                  // ===== গেস্ট মোড =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        local.guestMode,
                        style: const TextStyle(
                          color: Colors.white70,
                          shadows: [
                            Shadow(blurRadius: 4, color: Colors.black26, offset: Offset(0, 1)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(onLanguageChanged: widget.onLanguageChanged),
                            ),
                          );
                        },
                        child: Text(
                          '🚪 ${local.guest}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(blurRadius: 6, color: Colors.black26, offset: Offset(0, 1)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // ===== ভাষা ড্রপডাউন =====
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DropdownButton<Locale>(
                      value: Localizations.localeOf(context),
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFFF6B00)),
                      items: const [
                        DropdownMenuItem(value: Locale('bn'), child: Text('বাংলা')),
                        DropdownMenuItem(value: Locale('hi'), child: Text('हिन्दी')),
                        DropdownMenuItem(value: Locale('en'), child: Text('English')),
                      ],
                      onChanged: (Locale? newLocale) {
                        if (newLocale != null) {
                          widget.onLanguageChanged(newLocale);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(onLanguageChanged: widget.onLanguageChanged),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
