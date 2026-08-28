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

  late Future<List<SuryaNamaskarContent>> _contentFuture;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  void _loadContent() {
    _contentFuture = _service.getContent('bn');
  }

  Future<void> _openEditor(
    BuildContext context,
    SuryaNamaskarContent step,
  ) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) =>
            AdminSuryaNamaskarEditorScreen(step: step),
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
      body: FutureBuilder<List<SuryaNamaskarContent>>(
        future: _contentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load Surya Namaskar content.\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final steps = snapshot.data ?? [];

          if (steps.isEmpty) {
            return const Center(
              child: Text('No Surya Namaskar content found.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: steps.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
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
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          child: Text('${step.stepNumber}'),
        ),
        title: Text(
          step.title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            step.mantra ?? '',
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
