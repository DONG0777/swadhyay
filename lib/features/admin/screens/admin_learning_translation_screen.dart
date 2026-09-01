import 'package:flutter/material.dart';

import '../services/admin_learning_service.dart';

class AdminLearningTranslationScreen extends StatefulWidget {
  final AdminLearningContentItem content;

  const AdminLearningTranslationScreen({
    super.key,
    required this.content,
  });

  @override
  State<AdminLearningTranslationScreen> createState() =>
      _AdminLearningTranslationScreenState();
}

class _AdminLearningTranslationScreenState
    extends State<AdminLearningTranslationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final AdminLearningService _service = AdminLearningService();

  final Map<String, TextEditingController> _titleControllers = {};
  final Map<String, TextEditingController> _summaryControllers = {};
  final Map<String, TextEditingController> _bodyControllers = {};
  final Map<String, TextEditingController> _reflectionControllers = {};
  final Map<String, TextEditingController> _actionControllers = {};

  bool _isLoading = true;
  bool _isSaving = false;

  final List<String> _languages = ['bn', 'hi', 'en'];

  final Map<String, String> _languageNames = const {
    'bn': 'বাংলা',
    'hi': 'हिन्दी',
    'en': 'English',
  };

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: _languages.length,
      vsync: this,
    );

    for (final language in _languages) {
      _titleControllers[language] = TextEditingController();
      _summaryControllers[language] = TextEditingController();
      _bodyControllers[language] = TextEditingController();
      _reflectionControllers[language] = TextEditingController();
      _actionControllers[language] = TextEditingController();
    }

    _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    try {
      final translations = await _service.getTranslations(
        contentId: widget.content.id,
      );

      for (final translation in translations) {
        final language = translation.languageCode;

        if (!_languages.contains(language)) {
          continue;
        }

        _titleControllers[language]!.text = translation.title;
        _summaryControllers[language]!.text = translation.summary ?? '';
        _bodyControllers[language]!.text = translation.body ?? '';
        _reflectionControllers[language]!.text =
            translation.reflectionQuestion ?? '';
        _actionControllers[language]!.text =
            translation.actionPrompt ?? '';
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Translation load failed: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveCurrentLanguage() async {
    final index = _tabController.index;
    final language = _languages[index];

    final title = _titleControllers[language]!.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_languageNames[language]} Title আবশ্যক।',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _service.upsertTranslation(
        contentId: widget.content.id,
        languageCode: language,
        title: title,
        summary: _summaryControllers[language]!.text,
        body: _bodyControllers[language]!.text,
        reflectionQuestion: _reflectionControllers[language]!.text,
        actionPrompt: _actionControllers[language]!.text,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_languageNames[language]} translation saved.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Save failed: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildEditor(String language) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          controller: _titleControllers[language],
          decoration: const InputDecoration(
            labelText: 'Title *',
            border: OutlineInputBorder(),
          ),
          maxLength: 300,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _summaryControllers[language],
          decoration: const InputDecoration(
            labelText: 'Summary',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          maxLength: 1000,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _bodyControllers[language],
          decoration: const InputDecoration(
            labelText: 'Body',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 10,
          maxLength: 10000,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _reflectionControllers[language],
          decoration: const InputDecoration(
            labelText: 'Reflection Question',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          maxLength: 1000,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _actionControllers[language],
          decoration: const InputDecoration(
            labelText: 'Action Prompt',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          maxLength: 1000,
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 48,
          child: FilledButton.icon(
            onPressed: _isSaving ? null : _saveCurrentLanguage,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.save),
            label: Text(
              _isSaving ? 'Saving...' : 'Save ${_languageNames[language]}',
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();

    for (final controller in _titleControllers.values) {
      controller.dispose();
    }
    for (final controller in _summaryControllers.values) {
      controller.dispose();
    }
    for (final controller in _bodyControllers.values) {
      controller.dispose();
    }
    for (final controller in _reflectionControllers.values) {
      controller.dispose();
    }
    for (final controller in _actionControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Translations'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _languages
              .map(
                (language) => Tab(
                  text: _languageNames[language],
                ),
              )
              .toList(),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: _tabController,
              children: _languages
                  .map(_buildEditor)
                  .toList(),
            ),
    );
  }
}
