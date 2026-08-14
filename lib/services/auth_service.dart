import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // গুগল দিয়ে সাইন-ইন
  Future<void> signInWithGoogle() async {
    // 🔥 প্রোডাকশন URL (GitHub Pages)
    final redirectUrl = 'https://DONG0777.github.io/swadhyay/';
    
    // লোকাল ডেভেলপমেন্টের জন্য (টেস্টিং)
    // final redirectUrl = 'http://localhost:5000';

    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: redirectUrl,
    );
  }

  // সাইন-আউট
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // বর্তমান ইউজার
  User? get currentUser => supabase.auth.currentUser;

  // ইউজার লগইন আছে কিনা
  bool get isSignedIn => currentUser != null;

  // ইউজার আইডি
  String get userId => currentUser?.id ?? 'guest_123';

  // ইউজার ইমেইল
  String? get userEmail => currentUser?.email;

  // ইউজারের নাম
  String? get userName => currentUser?.userMetadata?['full_name'] ?? currentUser?.email?.split('@').first;

  // অথ স্টেট চেঞ্জ
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;
}
