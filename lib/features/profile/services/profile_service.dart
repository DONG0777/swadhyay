import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/localization/app_language_controller.dart';
import '../models/user_profile.dart';

class ProfileService {
  final SupabaseClient _client;

  ProfileService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<UserProfile?> getCurrentProfile() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final data = await _client
        .from('user_profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return UserProfile.fromMap(data);
  }

  Future<UserProfile> updateLanguageCode(String languageCode) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException('User is not signed in.');
    }

    if (!AppLanguageController.supportedLanguageCodes
        .contains(languageCode)) {
      throw ArgumentError('Unsupported language code.');
    }

    final data = await _client
        .from('user_profiles')
        .update({
          'language_code': languageCode,
        })
        .eq('id', user.id)
        .select()
        .single();

    return UserProfile.fromMap(data);
  }
  Future<UserProfile> updateProfile({
    String? displayName,
    String? phone,
    String? city,
    String? area,
    String? avatarUrl,
    String? languageCode,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException('User is not signed in.');
    }

    final data = await _client
        .from('user_profiles')
        .update({
          'display_name': displayName,
          'phone': phone,
          'city': city,
          'area': area,
          'avatar_url': avatarUrl,
          if (languageCode != null) 'language_code': languageCode,
        })
        .eq('id', user.id)
        .select()
        .single();

    return UserProfile.fromMap(data);
  }
}
