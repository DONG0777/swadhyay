import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // গুগল দিয়ে সাইন-ইন (সঠিক OAuthProvider ব্যবহার)
  Future<void> signInWithGoogle() async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'http://localhost:5000', // ওয়েবের জন্য রিডাইরেক্ট URL
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

  // ইউজারের নাম (গুগল থেকে)
  String? get userName => currentUser?.userMetadata?['full_name'] ?? currentUser?.email?.split('@').first;

  // স্ট্রিম: অথ স্টেট চেঞ্জ
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;
}
