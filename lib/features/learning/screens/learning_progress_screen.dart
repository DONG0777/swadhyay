import 'package:flutter/material.dart';

import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_strings.dart';

import '../models/learning_content.dart';
import '../models/learning_progress.dart';
import '../services/learning_progress_service.dart';
import '../services/learning_service.dart';
import 'learning_detail_screen.dart';

class LearningProgressScreen extends StatefulWidget {
  const LearningProgressScreen({super.key});

  @override
  State<LearningProgressScreen> createState() =>
      _LearningProgressScreenState();
}

class _LearningProgressScreenState extends State<LearningProgressScreen> {
  final LearningProgressService _progressService =
      LearningProgressService();
  final LearningService _learningService = LearningService();

  bool _isLoading = true;
  String? _error;

  List<LearningProgress> _progress = [];
  Map<String, LearningContent> _contents = {};
  Map<String, LearningTranslation> _translations = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final selectedLanguage =
          AppLanguageController.instance.languageCode;

      final progress = await _progressService.getCompletedProgress();

      if (progress.isEmpty) {
        if (!mounted) return;

        setState(() {
          _progress = [];
          _contents = {};
          _translations = {};
          _isLoading = false;
        });
        return;
      }

      final contents = await _learningService.getPublishedContents(
        languageCode: selectedLanguage,
      );

      final contentIds =
          contents.map((content) => content.id).toSet();

      final visibleProgress = progress
          .where(
            (item) => contentIds.contains(item.learningContentId),
          )
          .toList();

      final translations =
          await _learningService.getTranslationsForContents(
        contentIds: visibleProgress
            .map((item) => item.learningContentId)
            .toList(),
        languageCode: selectedLanguage,
      );

      if (!mounted) return;

      setState(() {
        _progress = visibleProgress;
        _contents = {
          for (final content in contents) content.id: content,
        };
        _translations = translations;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = AppStrings.of(context).learningProgressLoadFailed;
      });
    }
  }

  Widget _buildCompletedCount() {
    final strings = AppStrings.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '${strings.learningCompletedCount}: ${_progress.length}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(LearningProgress progress) {
    final strings = AppStrings.of(context);
    final content = _contents[progress.learningContentId];
    final translation = _translations[progress.learningContentId];

    if (content == null || translation == null) {
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translation.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${strings.learningCompletedCount}: '
                      '${MaterialLocalizations.of(context).formatMediumDate(
                        progress.completedAt.toLocal(),
                      )}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
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
                onPressed: _loadProgress,
                icon: const Icon(Icons.refresh),
                label: Text(strings.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (_progress.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadProgress,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 120),
            Center(
              child: Text(
                strings.learningNoProgress,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProgress,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _progress.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCompletedCount();
          }

          return _buildProgressCard(
            _progress[index - 1],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.learningProgress),
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }
}
