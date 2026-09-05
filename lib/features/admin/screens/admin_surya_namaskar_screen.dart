import 'package:flutter/material.dart';

import '../../surya_namaskar/models/surya_namaskar_content.dart';
import '../../surya_namaskar/services/surya_namaskar_service.dart';
import 'admin_surya_namaskar_editor_screen.dart';

class AdminSuryaNamaskarScreen extends StatefulWidget {
  const AdminSuryaNamaskarScreen({super.key});

  @override
  State<AdminSuryaNamaskarScreen> createState() =>
      _AdminSuryaNamaskarScreenState();
}

class _AdminSuryaNamaskarScreenState
    extends State<AdminSuryaNamaskarScreen> {
  final SuryaNamaskarService _service = SuryaNamaskarService();

  static const List<String> _languageCodes = ['bn', 'hi', 'en'];

  static const Map<String, String> _languageNames = {
    'bn': 'বাংলা',
    'hi': 'हिन्दी',
    'en': 'English',
  };

  late Future<List<SuryaNamaskarContent>> _contentFuture;

  String _selectedLanguageCode = 'bn';

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  void _loadContent() {
    _contentFuture = _service.getContent(_selectedLanguageCode);
  }

  Future<void> _selectLanguage(String languageCode) async {
    if (_selectedLanguageCode == languageCode) {
      return;
    }

    setState(() {
      _selectedLanguageCode = languageCode;
      _loadContent();
    });
  }

  Future<void> _openEditor(
    BuildContext context,
    SuryaNamaskarContent step,
  ) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) =>
            AdminSuryaNamaskarEditorScreen(
              step: step,
              languageCode: _selectedLanguageCode,
            ),
      ),
    );

    if (!mounted || saved != true) {
      return;
    }

    setState(() {
      _loadContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surya Namaskar Manager'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SegmentedButton<String>(
              segments: [
                for (final code in _languageCodes)
                  ButtonSegment<String>(
                    value: code,
                    label: Text(_languageNames[code]!),
                  ),
              ],
              selected: {_selectedLanguageCode},
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  _selectLanguage(selection.first);
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SuryaNamaskarContent>>(
              future: _contentFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Could not load Surya Namaskar content.\n\n'
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final steps = snapshot.data ?? [];

                if (steps.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Surya Namaskar content found.',
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: steps.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final step = steps[index];

                    return _StepCard(
                      step: step,
                      onTap: () => _openEditor(context, step),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final SuryaNamaskarContent step;
  final VoidCallback onTap;

  const _StepCard({
    required this.step,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = step.imageUrl?.trim();
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: SizedBox(
          width: 72,
          height: 72,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: hasImage
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return _placeholder(context);
                    },
                  )
                : _placeholder(context),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 14,
              child: Text(
                '${step.stepNumber}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                step.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            hasImage
                ? (step.mantra ?? '')
                : 'Image not assigned',
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        size: 30,
      ),
    );
  }
}
