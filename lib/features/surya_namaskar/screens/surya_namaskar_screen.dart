import 'package:flutter/material.dart';

import '../models/surya_namaskar_content.dart';
import '../services/surya_namaskar_service.dart';

class SuryaNamaskarScreen extends StatefulWidget {
  const SuryaNamaskarScreen({super.key});

  @override
  State<SuryaNamaskarScreen> createState() => _SuryaNamaskarScreenState();
}

class _SuryaNamaskarScreenState extends State<SuryaNamaskarScreen> {
  final SuryaNamaskarService _service = SuryaNamaskarService();
  final PageController _pageController = PageController();

  late Future<List<SuryaNamaskarContent>> _contentFuture;

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _contentFuture = _service.getContent('bn');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToPrevious() async {
    if (_currentStep > 0) {
      await _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _goToNext(int totalSteps) async {
    if (_currentStep < totalSteps - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  children: [
                    Text(
                      'ধাপ ${_currentStep + 1} / ${content.length}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: (_currentStep + 1) / content.length,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  itemCount: content.length,
                  itemBuilder: (context, index) {
                    final step = content[index];

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall,
                              ),
                              if (step.mantra != null &&
                                  step.mantra!.trim().isNotEmpty) ...[
                                const SizedBox(height: 24),
                                _ContentSection(
                                  title: 'মন্ত্র',
                                  content: step.mantra!,
                                ),
                              ],
                              if (step.mantraMeaning != null &&
                                  step.mantraMeaning!.trim().isNotEmpty) ...[
                                const SizedBox(height: 20),
                                _ContentSection(
                                  title: 'অর্থ',
                                  content: step.mantraMeaning!,
                                ),
                              ],
                              if (step.description != null &&
                                  step.description!.trim().isNotEmpty) ...[
                                const SizedBox(height: 20),
                                _ContentSection(
                                  title: 'বিবরণ',
                                  content: step.description!,
                                ),
                              ],
                              if (step.instructions != null &&
                                  step.instructions!.trim().isNotEmpty) ...[
                                const SizedBox(height: 20),
                                _ContentSection(
                                  title: 'কীভাবে করবেন',
                                  content: step.instructions!,
                                ),
                              ],
                              if (step.benefits != null &&
                                  step.benefits!.trim().isNotEmpty) ...[
                                const SizedBox(height: 20),
                                _ContentSection(
                                  title: 'উপকারিতা',
                                  content: step.benefits!,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              _currentStep == 0 ? null : _goToPrevious,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('পূর্ববর্তী'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _currentStep == content.length - 1
                              ? null
                              : () => _goToNext(content.length),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('পরবর্তী'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final String title;
  final String content;

  const _ContentSection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
