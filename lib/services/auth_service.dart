import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // গুগল দিয়ে সাইন-ইন (Web-এর জন্য সঠিক রিডাইরেক্ট)
  Future<void> signInWithGoogle() async {
    // 🔥 Web-এর জন্য রিডাইরেক্ট URL (লোকালহোস্ট বা প্রোডাকশন)
    final redirectUrl = 'http://localhost:5000'; // লোকাল টেস্টিং
    // final redirectUrl = 'https://DONG0777.github.io/swadhyay/'; // প্রোডাকশন

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
