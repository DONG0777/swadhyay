import 'package:flutter/material.dart';

import '../models/learning_content.dart';
import '../services/learning_service.dart';

class LearningDetailScreen extends StatefulWidget {
  final LearningContent content;

  const LearningDetailScreen({
    super.key,
    required this.content,
  });

  @override
  State<LearningDetailScreen> createState() =>
      _LearningDetailScreenState();
}

class _LearningDetailScreenState extends State<LearningDetailScreen> {
  final LearningService _service = LearningService();

  bool _isLoading = true;
  String? _error;
  LearningTranslation? _translation;

  @override
  void initState() {
    super.initState();
    _loadTranslation();
  }

  Future<void> _loadTranslation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final translations = await _service.getTranslations(
        contentId: widget.content.id,
        languageCode: 'bn',
      );

      if (!mounted) return;

      setState(() {
        _translation =
            translations.isEmpty ? null : translations.first;
        _isLoading = false;

        if (_translation == null) {
          _error = 'এই Learning content-এর বাংলা অনুবাদ পাওয়া যায়নি।';
        }
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = 'Learning content load failed.';
      });
    }
  }

  Widget _buildSection({
    required String title,
    required String? text,
  }) {
    if (text == null || text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _loadTranslation,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final translation = _translation!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translation.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: Text(widget.content.category),
              ),
              Chip(
                label: Text(
                  '${widget.content.estimatedMinutes} min',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'সারাংশ',
            text: translation.summary,
          ),
          _buildSection(
            title: 'মূল লেখা',
            text: translation.body,
          ),
          _buildSection(
            title: 'ভাবার প্রশ্ন',
            text: translation.reflectionQuestion,
          ),
          _buildSection(
            title: 'আজকের করণীয়',
            text: translation.actionPrompt,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning'),
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }
}
