import 'package:flutter/material.dart';

import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_strings.dart';

import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileService = ProfileService();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();

  String _languageCode = 'bn';

  bool _isLoading = true;
  bool _isSaving = false;

  static const _languages = <String, String>{
    'bn': 'বাংলা',
    'hi': 'हिन्दी',
    'en': 'English',
  };

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getCurrentProfile();

      if (!mounted) return;

      if (profile != null) {
        _nameController.text = profile.displayName ?? '';
        _phoneController.text = profile.phone ?? '';
        _cityController.text = profile.city ?? '';
        _areaController.text = profile.area ?? '';
        _languageCode = _languages.containsKey(profile.languageCode)
            ? profile.languageCode
            : 'bn';
        AppLanguageController.instance.setLanguage(_languageCode);
      }
    } catch (_) {
      if (mounted) {
        _showMessage(AppStrings.of(context).profileCouldNotBeLoaded);
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await _profileService.updateProfile(
        displayName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        city: _cityController.text.trim(),
        area: _areaController.text.trim(),
        languageCode: _languageCode,
      );

      if (mounted) {
        _showMessage(AppStrings.of(context).profileSavedSuccessfully);
      }
    } catch (_) {
      if (mounted) {
        _showMessage(AppStrings.of(context).profileCouldNotBeSaved);
      }
    }

    if (mounted) {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: !_isSaving,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.myProfile),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CircleAvatar(
                      radius: 42,
                      child: Icon(
                        Icons.person,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _field(
                      label: strings.name,
                      controller: _nameController,
                    ),
                    _field(
                      label: strings.phone,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    _field(
                      label: strings.city,
                      controller: _cityController,
                    ),
                    _field(
                      label: strings.area,
                      controller: _areaController,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strings.appLanguage,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _languageCode,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: _languages.entries
                          .map(
                            (entry) => DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(entry.value),
                            ),
                          )
                          .toList(),
                      onChanged: _isSaving
                          ? null
                          : (value) {
                              if (value == null) return;

                              setState(() {
                                _languageCode = value;
                              });
                              AppLanguageController.instance.setLanguage(value);
                            },
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _isSaving ? null : _saveProfile,
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(strings.saveProfile),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
