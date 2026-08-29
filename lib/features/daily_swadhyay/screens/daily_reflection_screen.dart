import 'package:flutter/material.dart';

import '../models/daily_commitment.dart';
import '../models/daily_reflection.dart';
import '../services/daily_commitment_service.dart';
import '../services/daily_reflection_service.dart';

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
  final TextEditingController _obstacleController = TextEditingController();

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
        _idealGapController.text = reflection?.idealGapReflection ?? '';
        _learningController.text = reflection?.learningReflection ?? '';
        _obstacleController.text = reflection?.obstacleReason ?? '';
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
          content: Text('আজকের স্বাধ্যায় লোড করা যায়নি: $error'),
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
        _obstacleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'নতুন সংকল্প নেওয়ার আগে আজ কী বাধা দিয়েছিল, সেটি লিখুন।',
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
        const SnackBar(
          content: Text('আজকের আত্ম-বিশ্লেষণ সংরক্ষিত হয়েছে।'),
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
          content: Text('আত্ম-বিশ্লেষণ সংরক্ষণ করা যায়নি: $error'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('রাতের আত্ম-বিশ্লেষণ'),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'আজকের সংকল্প আগে তৈরি করুন',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'আজকের আত্ম-বিশ্লেষণ শুরু করার আগে আজকের একটি সংকল্প থাকা প্রয়োজন।',
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'আজকের সংকল্প',
                            style: Theme.of(context).textTheme.titleMedium,
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
                            _commitment!.isCompleted
                                ? 'আজ একটু থামি'
                                : 'আজকের অভিজ্ঞতাটা বুঝে নিই',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'এখানে নিজেকে দোষ দেওয়ার জন্য নয়, নিজের প্যাটার্নকে বোঝার জন্য লিখুন।',
                          ),
                          const SizedBox(height: 24),
                          _reflectionField(
                            controller: _egoController,
                            label:
                                'আজ কোথায় স্বার্থ বা অহংকার আমাকে পরিচালিত করেছে?',
                            hint: 'নিজের ভাষায় লিখুন...',
                            maxLength: 2000,
                            maxLines: 5,
                          ),
                          const SizedBox(height: 20),
                          _reflectionField(
                            controller: _idealGapController,
                            label:
                                'আজ কোন কাজ বা কথা আমার আদর্শের সঙ্গে মেলেনি?',
                            hint: 'নিজের ভাষায় লিখুন...',
                            maxLength: 2000,
                            maxLines: 5,
                          ),
                          const SizedBox(height: 20),
                          _reflectionField(
                            controller: _learningController,
                            label:
                                'আজ আমি কী শিখলাম এবং আগামীকাল কোন ভুলটি আর করব না?',
                            hint: 'নিজের ভাষায় লিখুন...',
                            maxLength: 2000,
                            maxLines: 5,
                          ),
                          if (!_commitment!.isCompleted) ...[
                            const SizedBox(height: 20),
                            const Text(
                              'সংকল্পটি আজ পূরণ হয়নি। নতুন সংকল্প নেওয়ার আগে কারণটি বুঝে নেওয়া দরকার।',
                            ),
                            const SizedBox(height: 12),
                            _reflectionField(
                              controller: _obstacleController,
                              label: 'কোন বাধাটা তোমাকে আজ আটকে দিয়েছিল?',
                              hint:
                                  'সময়, পরিবেশ, অভ্যাস বা অন্য কোনো বাস্তব কারণ...',
                              maxLength: 1000,
                              maxLines: 4,
                            ),
                          ],
                          if (_reflection != null) ...[
                            const SizedBox(height: 12),
                            const Text(
                              'আজকের আত্ম-বিশ্লেষণ সংরক্ষিত হয়েছে।',
                            ),
                          ],
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _isSaving ? null : _saveReflection,
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      _reflection == null
                                          ? 'আত্ম-বিশ্লেষণ সংরক্ষণ করুন'
                                          : 'পরিবর্তন সংরক্ষণ করুন',
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

