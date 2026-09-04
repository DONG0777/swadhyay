import 'package:flutter/material.dart';

import '../../../core/localization/app_strings.dart';

import '../models/daily_commitment.dart';
import '../services/daily_commitment_service.dart';
import 'daily_reflection_screen.dart';

class DailyCommitmentScreen extends StatefulWidget {
  const DailyCommitmentScreen({super.key});

  @override
  State<DailyCommitmentScreen> createState() => _DailyCommitmentScreenState();
}

class _DailyCommitmentScreenState extends State<DailyCommitmentScreen> {
  final DailyCommitmentService _service = DailyCommitmentService();
  final TextEditingController _controller = TextEditingController();

  DailyCommitment? _commitment;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isUpdatingStatus = false;

  @override
  void initState() {
    super.initState();
    _loadTodayCommitment();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadTodayCommitment() async {
    try {
      final commitment = await _service.getTodayCommitment();

      if (!mounted) {
        return;
      }

      setState(() {
        _commitment = commitment;
        _controller.text = commitment?.commitmentText ?? '';
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
          content: Text('আজকের সংকল্প লোড করা যায়নি: $error'),
        ),
      );
    }
  }

  Future<void> _saveCommitment() async {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('একটি ছোট ও নির্দিষ্ট সংকল্প লিখুন।'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final commitment = await _service.createTodayCommitment(
        commitmentText: text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _commitment = commitment;
        _isSaving = false;
        _controller.text = commitment.commitmentText;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('আজকের সংকল্প সংরক্ষিত হয়েছে।'),
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
          content: Text('সংকল্প সংরক্ষণ করা যায়নি: $error'),
        ),
      );
    }
  }

  Future<void> _completeCommitment() async {
    if (_commitment == null || _commitment!.status != 'pending') {
      return;
    }

    await _updateStatus(
      action: _service.completeTodayCommitment,
      successMessage: 'আজকের সংকল্প সম্পন্ন হয়েছে।',
    );
  }

  Future<void> _markCommitmentMissed() async {
    if (_commitment == null || _commitment!.status != 'pending') {
      return;
    }

    await _updateStatus(
      action: _service.markTodayCommitmentMissed,
      successMessage:
          'আজকের সংকল্প সম্পন্ন হয়নি। কারণটি বুঝে নেওয়ার সময় এসেছে।',
    );
  }

  void _openReflection() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const DailyReflectionScreen(),
      ),
    );
  }

  Future<void> _updateStatus({
    required Future<DailyCommitment> Function() action,
    required String successMessage,
  }) async {
    setState(() {
      _isUpdatingStatus = true;
    });

    try {
      final updatedCommitment = await action();

      if (!mounted) {
        return;
      }

      setState(() {
        _commitment = updatedCommitment;
        _isUpdatingStatus = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isUpdatingStatus = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('সংকল্পের status পরিবর্তন করা যায়নি: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.of(context).dailySwadhyay),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.of(context).dailyCommitmentPrompt,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.of(context).dailyCommitmentPromptDescription,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _controller,
                      maxLines: 4,
                      maxLength: 500,
                      enabled: _commitment == null &&
                          !_isSaving &&
                          !_isUpdatingStatus,
                      decoration: InputDecoration(
                        labelText: AppStrings.of(context).myTodaysCommitment,
                        hintText:
                            'যেমন: রাগের মুহূর্তে উত্তর দেওয়ার আগে ১০ সেকেন্ড থামব।',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_commitment == null)
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isSaving ? null : _saveCommitment,
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(AppStrings.of(context).saveTodaysCommitment),
                        ),
                      )
                    else
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.of(context).myTodaysCommitment,
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _commitment!.commitmentText,
                                style:
                                    Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 20),
                              if (_commitment!.status == 'completed') ...[
                                const Row(
                                  children: [
                                    Icon(Icons.check_circle_outline),
                                    SizedBox(width: 8),
                                    Text('আজকের সংকল্প সম্পন্ন হয়েছে'),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _openReflection,
                                    icon: const Icon(
                                      Icons.self_improvement_outlined,
                                    ),
                                    label: const Text(
                                      'আজকের আত্ম-বিশ্লেষণে যান',
                                    ),
                                  ),
                                ),
                              ]
                              else if (_commitment!.status == 'missed') ...[
                                const Row(
                                  children: [
                                    Icon(Icons.info_outline),
                                    SizedBox(width: 8),
                                    Text('আজকের সংকল্প সম্পন্ন হয়নি'),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _openReflection,
                                    icon: const Icon(
                                      Icons.self_improvement_outlined,
                                    ),
                                    label: const Text(
                                      'আজকের অভিজ্ঞতা বুঝে নিই',
                                    ),
                                  ),
                                ),
                              ]
                              else ...[
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: _isUpdatingStatus
                                        ? null
                                        : _completeCommitment,
                                    icon: _isUpdatingStatus
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.check_circle_outline,
                                          ),
                                    label: const Text(
                                      'আমি পালন করেছি',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _isUpdatingStatus
                                        ? null
                                        : _markCommitmentMissed,
                                    icon: const Icon(
                                      Icons.event_busy_outlined,
                                    ),
                                    label: const Text(
                                      'আমি পালন করতে পারিনি',
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

