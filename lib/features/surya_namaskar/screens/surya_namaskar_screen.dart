import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'সূর্য নমস্কার',
          style: GoogleFonts.notoSansBengali(
            fontWeight: FontWeight.w600,
          ),
        ),
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
                  style: GoogleFonts.notoSansBengali(),
                ),
              ),
            );
          }

          final content = snapshot.data ?? [];

          if (content.isEmpty) {
            return Center(
              child: Text(
                'কোনো সূর্য নমস্কারের তথ্য পাওয়া যায়নি।',
                style: GoogleFonts.notoSansBengali(),
              ),
            );
          }

          return Column(
            children: [
              _StepProgressHeader(
                currentStep: _currentStep,
                totalSteps: content.length,
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: content.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _StepContent(
                      step: content[index],
                      theme: theme,
                    );
                  },
                ),
              ),
              _NavigationBar(
                currentStep: _currentStep,
                totalSteps: content.length,
                onPrevious: _goToPrevious,
                onNext: () => _goToNext(content.length),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StepProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepProgressHeader({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (currentStep + 1) / totalSteps;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'সূর্য নমস্কার',
                style: GoogleFonts.notoSansBengali(
                  textStyle: theme.textTheme.titleMedium,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'ধাপ ${currentStep + 1} / $totalSteps',
                style: GoogleFonts.notoSansBengali(
                  textStyle: theme.textTheme.labelLarge,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepContent extends StatelessWidget {
  final SuryaNamaskarContent step;
  final ThemeData theme;

  const _StepContent({
    required this.step,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Card(
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StepTitle(
                    stepNumber: step.stepNumber,
                    title: step.title,
                  ),
                  if (_hasText(step.imageUrl)) ...[
                    const SizedBox(height: 22),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Image.network(
                          step.imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder:
                              (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return const SizedBox(
                              height: 220,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 220,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.broken_image_outlined,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'ছবিটি লোড করা যায়নি।',
                                    style: GoogleFonts.notoSansBengali(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                  if (_hasText(step.mantra)) ...[
                    const SizedBox(height: 28),
                    _MantraSection(
                      mantra: step.mantra!,
                      theme: theme,
                    ),
                  ],
                  if (_hasText(step.mantraMeaning)) ...[
                    const SizedBox(height: 24),
                    _ContentSection(
                      title: 'অর্থ',
                      content: step.mantraMeaning!,
                      icon: Icons.lightbulb_outline,
                    ),
                  ],
                  if (_hasText(step.description)) ...[
                    const SizedBox(height: 24),
                    _ContentSection(
                      title: 'বিবরণ',
                      content: step.description!,
                      icon: Icons.info_outline,
                    ),
                  ],
                  if (_hasText(step.instructions)) ...[
                    const SizedBox(height: 24),
                    _ContentSection(
                      title: 'কীভাবে করবেন',
                      content: step.instructions!,
                      icon: Icons.accessibility_new,
                    ),
                  ],
                  if (_hasText(step.benefits)) ...[
                    const SizedBox(height: 24),
                    _ContentSection(
                      title: 'উপকারিতা',
                      content: step.benefits!,
                      icon: Icons.favorite_border,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

class _StepTitle extends StatelessWidget {
  final int stepNumber;
  final String title;

  const _StepTitle({
    required this.stepNumber,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$stepNumber',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              title,
              style: GoogleFonts.notoSansBengali(
                textStyle: theme.textTheme.headlineSmall,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MantraSection extends StatelessWidget {
  final String mantra;
  final ThemeData theme;

  const _MantraSection({
    required this.mantra,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'মন্ত্র',
            style: GoogleFonts.notoSansBengali(
              textStyle: theme.textTheme.labelLarge,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mantra,
            style: GoogleFonts.notoSansBengali(
              textStyle: theme.textTheme.titleLarge,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _ContentSection({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 21,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.notoSansBengali(
                  textStyle: theme.textTheme.titleMedium,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                content,
                style: GoogleFonts.notoSansBengali(
                  textStyle: theme.textTheme.bodyLarge,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavigationBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _NavigationBar({
    required this.currentStep,
    required this.totalSteps,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: currentStep == 0 ? null : onPrevious,
                icon: const Icon(Icons.arrow_back),
                label: Text(
                  'পূর্ববর্তী',
                  style: GoogleFonts.notoSansBengali(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: currentStep == totalSteps - 1 ? null : onNext,
                icon: Icon(
                  currentStep == totalSteps - 1
                      ? Icons.check
                      : Icons.arrow_forward,
                ),
                label: Text(
                  currentStep == totalSteps - 1 ? 'সম্পন্ন' : 'পরবর্তী',
                  style: GoogleFonts.notoSansBengali(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
