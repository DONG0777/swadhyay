import 'package:flutter/material.dart';

import '../../../core/localization/app_strings.dart';

import '../models/daily_commitment.dart';
import '../models/daily_reflection.dart';
import '../services/daily_commitment_service.dart';
import '../services/daily_reflection_service.dart';
import 'tomorrow_commitment_screen.dart';

class DailyReflectionScreen extends StatefulWidget {
  const DailyReflectionScreen({super.key});

  @override
  State<DailyReflectionScreen> createState() => _DailyReflectionScreenState();
}

class _DailyReflectionScreenState extends State<DailyReflectionScreen> {
  final DailyCommitmentService _commitmentService =
      DailyCommitmentService();
  final DailyReflectionService _reflectionService =
      DailyReflectionService();

  final TextEditingController _egoController = TextEditingController();
  final TextEditingController _idealGapController = TextEditingController();
  final TextEditingController _learningController = TextEditingController();
  final TextEditingController _obstacleController =
      TextEditingController();

  DailyCommitment? _commitment;
  DailyReflection? _reflection;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadReflectionData();
  }

  @override
  void dispose() {
    _egoController.dispose();
    _idealGapController.dispose();
    _learningController.dispose();
    _obstacleController.dispose();
    super.dispose();
  }

  Future<void> _loadReflectionData() async {
    try {
      final commitment = await _commitmentService.getTodayCommitment();
      final reflection = await _reflectionService.getTodayReflection();

      if (!mounted) {
        return;
      }

      setState(() {
        _commitment = commitment;
        _reflection = reflection;
        _egoController.text = reflection?.egoReflection ?? '';
        _idealGapController.text =
            reflection?.idealGapReflection ?? '';
        _learningController.text =
            reflection?.learningReflection ?? '';
        _obstacleController.text =
            reflection?.obstacleReason ?? '';
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.of(context).reflectionLoadFailed(error)),
        ),
      );
    }
  }

  Future<void> _saveReflection() async {
    final commitment = _commitment;

    if (commitment == null) {
      return;
    }

    if (!commitment.isCompleted &&
        commitment.status != 'missed' &&
        _obstacleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.of(context).incompleteCommitmentObstacleRequired,
          ),
        ),
      );
      return;
    }

    if (commitment.status == 'missed' &&
        _obstacleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.of(context).missedCommitmentObstacleRequired,
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final savedReflection =
          await _reflectionService.saveTodayReflection(
        commitmentId: commitment.id,
        commitmentCompleted: commitment.isCompleted,
        egoReflection: _egoController.text,
        idealGapReflection: _idealGapController.text,
        learningReflection: _learningController.text,
        obstacleReason:
            commitment.isCompleted ? null : _obstacleController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _reflection = savedReflection;
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.of(context).reflectionSavedSuccessfully),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.of(context).reflectionSaveFailed(error)),
        ),
      );
    }
  }

  Widget _reflectionField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required int maxLength,
    required int maxLines,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _openTomorrowCommitment() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const TomorrowCommitmentScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canMoveToTomorrow =
        _reflection != null && !_isSaving;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.of(context).dailyReflectionAppBar),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _commitment == null
                    ? Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.of(context).createTodaysCommitmentFirst,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.of(context).commitmentNeededBeforeReflection,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.of(context).todaysCommitmentLabel,
                            style:
                                Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                _commitment!.commitmentText,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _commitment!.status == 'missed'
                                ? AppStrings.of(context).understandTodaysExperienceTitle
                                : AppStrings.of(context).pauseForTodayTitle,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.of(context).reflectionPurposeDescription,
                          ),
                          const SizedBox(height: 24),
                          _reflectionField(
                            controller: _egoController,
                            label:
                                AppStrings.of(context).egoReflectionQuestion,
                            hint: AppStrings.of(context).reflectionWriteHint,
                            maxLength: 2000,
                            maxLines: 5,
                          ),
                          const SizedBox(height: 20),
                          _reflectionField(
                            controller: _idealGapController,
                            label:
                                AppStrings.of(context).idealGapReflectionQuestion,
                            hint: AppStrings.of(context).reflectionWriteHint,
                            maxLength: 2000,
                            maxLines: 5,
                          ),
                          const SizedBox(height: 20),
                          _reflectionField(
                            controller: _learningController,
                            label:
                                AppStrings.of(context).learningReflectionQuestion,
                            hint: AppStrings.of(context).reflectionWriteHint,
                            maxLength: 2000,
                            maxLines: 5,
                          ),
                          if (!_commitment!.isCompleted) ...[
                            const SizedBox(height: 20),
                            Text(
                              AppStrings.of(context).commitmentNotCompletedDescription,
                            ),
                            const SizedBox(height: 12),
                            _reflectionField(
                              controller: _obstacleController,
                              label:
                                  AppStrings.of(context).obstacleReflectionQuestion,
                              hint:
                                  AppStrings.of(context).obstacleReflectionHint,
                              maxLength: 1000,
                              maxLines: 4,
                            ),
                          ],
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed:
                                  _isSaving ? null : _saveReflection,
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      _reflection == null
                                          ? AppStrings.of(context).saveReflection
                                          : AppStrings.of(context).saveChanges,
                                    ),
                            ),
                          ),
                          if (_reflection != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              AppStrings.of(context).reflectionSavedSuccessfully,
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: canMoveToTomorrow
                                    ? _openTomorrowCommitment
                                    : null,
                                icon: const Icon(
                                  Icons.arrow_forward_outlined,
                                ),
                                label: Text(
                                  AppStrings.of(context).goToTomorrowCommitment,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
              ),
            ),
    );
  }
}





