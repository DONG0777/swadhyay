import 'package:flutter/material.dart';

import '../models/learning_content.dart';
import 'learning_detail_screen.dart';
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
      final contents = await _service.getPublishedContents();

      if (!mounted) return;

      setState(() {
        _contents = contents;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = 'Learning content load failed.';
      });
    }
  }

  String _contentKindLabel(String kind) {
    switch (kind) {
      case 'knowledge':
        return 'Knowledge';
      case 'quote':
        return 'Quote';
      case 'story':
        return 'Story';
      case 'song':
        return 'Song';
      case 'reflection':
        return 'Reflection';
      case 'civic_thought':
        return 'Civic Thought';
      case 'seva_idea':
        return 'Seva Idea';
      case 'quiz':
        return 'Quiz';
      default:
        return kind;
    }
  }

  Widget _buildContentCard(LearningContent content) {
    final title = content.sourceTitle?.trim().isNotEmpty == true
        ? content.sourceTitle!
        : content.category;

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
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text(_contentKindLabel(content.contentKind)),
                  ),
                  Chip(
                    label: Text(content.category),
                  ),
                  Chip(
                    label: Text('${content.estimatedMinutes} min'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Difficulty: ${content.difficulty}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
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
                onPressed: _loadContents,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
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
          children: const [
            SizedBox(height: 120),
            Center(
              child: Text(
                'No learning content available yet.',
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
