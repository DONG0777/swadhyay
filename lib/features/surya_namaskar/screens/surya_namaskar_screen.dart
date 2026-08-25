import 'package:flutter/material.dart';

import '../models/surya_namaskar_content.dart';
import '../services/surya_namaskar_service.dart';

class SuryaNamaskarScreen extends StatefulWidget {
  const SuryaNamaskarScreen({super.key});

  @override
  State<SuryaNamaskarScreen> createState() =>
      _SuryaNamaskarScreenState();
}

class _SuryaNamaskarScreenState extends State<SuryaNamaskarScreen> {
  final SuryaNamaskarService _service = SuryaNamaskarService();

  late Future<List<SuryaNamaskarContent>> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = _service.getContent('bn');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('সূর্য নমস্কার'),
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
                  'সূর্য নমস্কারের তথ্য লোড করা যায়নি।\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final content = snapshot.data ?? [];

          if (content.isEmpty) {
            return const Center(
              child: Text(
                'কোনো সূর্য নমস্কারের তথ্য পাওয়া যায়নি।',
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: content.length,
            itemBuilder: (context, index) {
              final step = content[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ধাপ ${step.stepNumber}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        step.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (step.mantra != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'মন্ত্র',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(step.mantra!),
                      ],
                      if (step.mantraTransliteration != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'উচ্চারণ',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(step.mantraTransliteration!),
                      ],
                      if (step.mantraMeaning != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'অর্থ',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(step.mantraMeaning!),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
