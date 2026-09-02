import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppLanguageController extends ChangeNotifier {
  AppLanguageController._();

  static final AppLanguageController instance = AppLanguageController._();

  static const supportedLanguageCodes = <String>[
    'bn',
    'hi',
    'en',
  ];

  String _languageCode = 'bn';

  StreamSubscription<AuthState>? _authSubscription;

  String get languageCode => _languageCode;

  Locale get locale => Locale(_languageCode);

  bool setLanguage(String languageCode) {
    if (!supportedLanguageCodes.contains(languageCode)) {
      return false;
    }

    if (_languageCode == languageCode) {
      return false;
    }

    _languageCode = languageCode;
    notifyListeners();
    return true;
  }

  Future<void> initialize() async {
    await loadForCurrentUser();

    _authSubscription ??= Supabase.instance.client.auth.onAuthStateChange.listen(
      (authState) async {
        final session = authState.session;

        if (session == null) {
          resetToDefault();
          return;
        }

        await loadForCurrentUser();
      },
    );
  }

  Future<void> loadForCurrentUser() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return;
    }

    try {
      final data = await Supabase.instance.client
          .from('user_profiles')
          .select('language_code')
          .eq('id', user.id)
          .maybeSingle();

      final languageCode = data?['language_code'] as String?;

      if (languageCode != null &&
          supportedLanguageCodes.contains(languageCode)) {
        setLanguage(languageCode);
      }
    } catch (_) {
      // Keep the current language if the saved preference cannot be loaded.
    }
  }

  void resetToDefault() {
    setLanguage('bn');
  }
}
