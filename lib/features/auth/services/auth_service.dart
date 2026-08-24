import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static const String _mobileRedirectUrl =
      'org.swadhyay.app://login-callback';

  final SupabaseClient _client;

  AuthService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  Session? get currentSession => _client.auth.currentSession;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo:
          kIsWeb ? null : _mobileRedirectUrl,
    );
  }

  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo:
          kIsWeb ? null : _mobileRedirectUrl,
    );
  }

  Future<void> resendVerificationEmail({
    required String email,
  }) async {
    await _client.auth.resend(
      type: OtpType.signup,
      email: email,
      emailRedirectTo:
          kIsWeb ? null : _mobileRedirectUrl,
    );
  }

  Future<void> signOut() {
    return _client.auth.signOut();
  }
}
