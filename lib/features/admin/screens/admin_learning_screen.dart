import 'package:flutter/material.dart';

import '../services/admin_learning_service.dart';
import 'admin_learning_translation_screen.dart';

class AdminLearningScreen extends StatefulWidget {
  const AdminLearningScreen({super.key});

  @override
  State<AdminLearningScreen> createState() => _AdminLearningScreenState();
}

class _AdminLearningScreenState extends State<AdminLearningScreen> {
  final AdminLearningService _service = AdminLearningService();

  final _categoryController = TextEditingController();
  final _sourceTitleController = TextEditingController();
  final _sourceAuthorController = TextEditingController();
  final _sourceReferenceController = TextEditingController();
  final _sourceUrlController = TextEditingController();
  final _estimatedMinutesController =
      TextEditingController(text: '5');

  String _contentKind = 'knowledge';
  String _difficulty = 'easy';
  bool _isSaving = false;
  bool _isLoadingContents = true;

  List<AdminLearningContentItem> _contents = [];

  static const _contentKinds = [
    'knowledge',
    'quote',
    'story',
    'song',
    'reflection',
    'civic_thought',
    'seva_idea',
    'quiz',
  ];

  static const _difficulties = [
    'easy',
    'medium',
    'advanced',
  ];

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _sourceTitleController.dispose();
    _sourceAuthorController.dispose();
    _sourceReferenceController.dispose();
    _sourceUrlController.dispose();
    _estimatedMinutesController.dispose();
    super.dispose();
  }

  Future<void> _loadContents() async {
    if (mounted) {
      setState(() {
        _isLoadingContents = true;
      });
    }

    try {
      final contents = await _service.listContents();

      if (!mounted) return;

      setState(() {
        _contents = contents;
        _isLoadingContents = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoadingContents = false;
      });

      _showMessage('Failed to load content: $error');
    }
  }

  Future<void> _createContent() async {
    if (_categoryController.text.trim().isEmpty) {
      _showMessage('Category is required.');
      return;
    }

    final estimatedMinutes =
        int.tryParse(_estimatedMinutesController.text.trim());

    if (estimatedMinutes == null || estimatedMinutes <= 0) {
      _showMessage('Enter a valid estimated time.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final contentId = await _service.createContent(
        contentKind: _contentKind,
        category: _categoryController.text.trim(),
        sourceTitle: _sourceTitleController.text.trim().isEmpty
            ? null
            : _sourceTitleController.text.trim(),
        sourceAuthor: _sourceAuthorController.text.trim().isEmpty
            ? null
            : _sourceAuthorController.text.trim(),
        sourceReference:
            _sourceReferenceController.text.trim().isEmpty
                ? null
                : _sourceReferenceController.text.trim(),
        sourceUrl: _sourceUrlController.text.trim().isEmpty
            ? null
            : _sourceUrlController.text.trim(),
        estimatedMinutes: estimatedMinutes,
        difficulty: _difficulty,
      );

      if (!mounted) return;

      _clearForm();

      await _loadContents();

      if (!mounted) return;

      _showMessage(
        'Learning content created as draft.\nID: $contentId',
      );
    } catch (error) {
      if (!mounted) return;

      _showMessage('Failed to create content: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _clearForm() {
    _categoryController.clear();
    _sourceTitleController.clear();
    _sourceAuthorController.clear();
    _sourceReferenceController.clear();
    _sourceUrlController.clear();
    _estimatedMinutesController.text = '5';

    setState(() {
      _contentKind = 'knowledge';
      _difficulty = 'easy';
    });
  }

  Future<void> _publishContent(AdminLearningContentItem item) async {
    final shouldPublish = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Publish content?'),
          content: const Text(
            'এই Learning content প্রকাশ করলে এটি user-এর Learning section-এ দেখা যাবে।',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Publish'),
            ),
          ],
        );
      },
    );

    if (shouldPublish != true) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _service.setContentStatus(
        contentId: item.id,
        status: 'published',
      );

      if (!mounted) return;

      await _loadContents();

      if (!mounted) return;

      _showMessage('Learning content published successfully.');
    } catch (error) {
      if (!mounted) return;

      _showMessage('Failed to publish content: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildContentCard(AdminLearningContentItem item) {
    final title = item.sourceTitle?.trim().isNotEmpty == true
        ? item.sourceTitle!
        : item.category;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Category: ${item.category}'),
            const SizedBox(height: 4),
            Text('Type: ${item.contentKind}'),
            const SizedBox(height: 4),
            Text('Difficulty: ${item.difficulty}'),
            const SizedBox(height: 4),
            Text('Estimated time: ${item.estimatedMinutes} min'),
            const SizedBox(height: 8),
            Chip(
              label: Text('Status: ${item.status}'),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            AdminLearningTranslationScreen(
                          content: item,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.translate),
                  label: const Text('Translations'),
                ),
                if (item.status == 'draft' || item.status == 'submitted')
                  FilledButton.icon(
                    onPressed: _isSaving
                        ? null
                        : () => _publishContent(item),
                    icon: const Icon(Icons.publish_outlined),
                    label: const Text('Publish'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExistingContent() {
    if (_isLoadingContents) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_contents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text('No learning content yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in _contents) ...[
          _buildContentCard(item),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Content'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create Learning Content',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'New content will be created as draft.',
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _contentKind,
                decoration: const InputDecoration(
                  labelText: 'Content type',
                  border: OutlineInputBorder(),
                ),
                items: _contentKinds
                    .map(
                      (kind) => DropdownMenuItem(
                        value: kind,
                        child: Text(kind),
                      ),
                    )
                    .toList(),
                onChanged: _isSaving
                    ? null
                    : (value) {
                        if (value == null) return;
                        setState(() {
                          _contentKind = value;
                        });
                      },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _categoryController,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Category *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _sourceTitleController,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Source title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _sourceAuthorController,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Source author',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _sourceReferenceController,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Source reference',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _sourceUrlController,
                enabled: !_isSaving,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Source URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _estimatedMinutesController,
                enabled: !_isSaving,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Estimated minutes',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _difficulty,
                decoration: const InputDecoration(
                  labelText: 'Difficulty',
                  border: OutlineInputBorder(),
                ),
                items: _difficulties
                    .map(
                      (difficulty) => DropdownMenuItem(
                        value: difficulty,
                        child: Text(difficulty),
                      ),
                    )
                    .toList(),
                onChanged: _isSaving
                    ? null
                    : (value) {
                        if (value == null) return;
                        setState(() {
                          _difficulty = value;
                        });
                      },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isSaving ? null : _createContent,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(
                  _isSaving ? 'Creating...' : 'Create Draft',
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Existing Content',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Refresh',
                    onPressed:
                        _isLoadingContents ? null : _loadContents,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildExistingContent(),
            ],
          ),
        ),
      ),
    );
  }
}

