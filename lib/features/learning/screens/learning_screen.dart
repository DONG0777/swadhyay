import 'package:flutter/material.dart';

import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_strings.dart';

import '../models/learning_content.dart';
import 'learning_detail_screen.dart';
import 'learning_progress_screen.dart';
import '../services/learning_service.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final LearningService _service = LearningService();

  bool _isLoading = true;
  String? _error;
  List<LearningContent> _contents = [];
  Map<String, LearningTranslation> _translations = {};

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  Future<void> _loadContents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final selectedLanguage =
          AppLanguageController.instance.languageCode;

      final contents = await _service.getPublishedContents(
        languageCode: selectedLanguage,
      );

      final translations = await _service.getTranslationsForContents(
        contentIds: contents.map((content) => content.id).toList(),
        languageCode: selectedLanguage,
      );

      if (!mounted) return;

      setState(() {
        _contents = contents;
        _translations = translations;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = AppStrings.of(context).learningLoadFailed;
      });
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

  String _contentKindLabel(String kind) {
    final strings = AppStrings.of(context);

    switch (kind) {
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
        return kind;
    }
  }

  String _difficultyLabel(String difficulty) {
    final strings = AppStrings.of(context);

    switch (difficulty.toLowerCase()) {
      case 'easy':
        return strings.learningDifficultyEasy;
      case 'medium':
        return strings.learningDifficultyMedium;
      case 'hard':
        return strings.learningDifficultyHard;
      default:
        return difficulty;
    }
  }
  Widget _buildContentCard(LearningContent content) {
    final strings = AppStrings.of(context);
    final translation = _translations[content.id];

    if (translation == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => LearningDetailScreen(
                content: content,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translation.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text(
                      _contentKindLabel(content.contentKind),
                    ),
                  ),
                  Chip(
                    label: Text(_contentCategoryLabel(content.category)),
                  ),
                  Chip(
                    label: Text(
                      '${content.estimatedMinutes} ${strings.minutes}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${strings.learningDifficulty}: ${_difficultyLabel(content.difficulty)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final strings = AppStrings.of(context);

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
                onPressed: _loadContents,
                icon: const Icon(Icons.refresh),
                label: Text(strings.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (_contents.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadContents,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 120),
            Center(
              child: Text(
                strings.learningNoContent,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadContents,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _contents.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildContentCard(_contents[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.learning),
        actions: [
          IconButton(
            tooltip: strings.learningProgress,
            icon: const Icon(Icons.insights_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const LearningProgressScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }
}



