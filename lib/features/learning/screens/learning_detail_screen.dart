import 'package:flutter/material.dart';

import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_strings.dart';

import '../models/learning_content.dart';
import '../models/learning_progress.dart';
import '../services/learning_progress_service.dart';
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
  final LearningProgressService _progressService =
      LearningProgressService();

  bool _isLoading = true;
  bool _isCompleting = false;
  String? _error;
  LearningTranslation? _translation;
  LearningProgress? _progress;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final selectedLanguage =
          AppLanguageController.instance.languageCode;

      final translations = await _service.getTranslations(
        contentId: widget.content.id,
        languageCode: selectedLanguage,
      );

      final progress = await _progressService.getProgress(
        learningContentId: widget.content.id,
      );

      if (!mounted) return;

      setState(() {
        _translation =
            translations.isEmpty ? null : translations.first;
        _progress = progress;
        _isLoading = false;

        if (_translation == null) {
          _error = AppStrings.of(context).learningTranslationNotFound;
        }
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = AppStrings.of(context).learningLoadFailed;
      });
    }
  }

  Future<void> _completeContent() async {
    if (_isCompleting || _progress?.isCompleted == true) {
      return;
    }

    setState(() {
      _isCompleting = true;
    });

    try {
      final progress = await _progressService.completeContent(
        learningContentId: widget.content.id,
      );

      if (!mounted) return;

      setState(() {
        _progress = progress;
        _isCompleting = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isCompleting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.of(context).learningCompletionFailed,
          ),
        ),
      );
    }
  }

  String _contentCategoryLabel(String category) {
    final strings = AppStrings.of(context);

    switch (category.toLowerCase()) {
      case 'knowledge':
        return strings.learningKindKnowledge;
      case 'quote':
        return strings.learningKindQuote;
      case 'story':
        return strings.learningKindStory;
      case 'song':
        return strings.learningKindSong;
      case 'reflection':
        return strings.learningKindReflection;
      case 'civic_thought':
        return strings.learningKindCivicThought;
      case 'seva_idea':
        return strings.learningKindSevaIdea;
      case 'quiz':
        return strings.learningKindQuiz;
      default:
        return category;
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

  Widget _buildCompletionAction() {
    final strings = AppStrings.of(context);

    if (_progress?.isCompleted == true) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest,
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                strings.learningCompleted,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _isCompleting ? null : _completeContent,
        icon: _isCompleting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.check),
        label: Text(strings.learningMarkComplete),
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
                onPressed: _loadContent,
                icon: const Icon(Icons.refresh),
                label: Text(AppStrings.of(context).retry),
              ),
            ],
          ),
        ),
      );
    }

    final translation = _translation!;
    final strings = AppStrings.of(context);

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
                label: Text(
                  _contentCategoryLabel(widget.content.category),
                ),
              ),
              Chip(
                label: Text(
                  '${widget.content.estimatedMinutes} ${strings.minutes}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: strings.learningSummary,
            text: translation.summary,
          ),
          _buildSection(
            title: strings.learningMainContent,
            text: translation.body,
          ),
          _buildSection(
            title: strings.learningReflectionQuestion,
            text: translation.reflectionQuestion,
          ),
          _buildSection(
            title: strings.learningActionPrompt,
            text: translation.actionPrompt,
          ),
          const SizedBox(height: 8),
          _buildCompletionAction(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.learning),
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }
}
