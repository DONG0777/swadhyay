import 'package:flutter/material.dart';

import '../models/daily_commitment.dart';
import '../services/daily_commitment_service.dart';

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
  bool _isCompleting = false;

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
    if (_commitment == null || _commitment!.isCompleted) {
      return;
    }

    setState(() {
      _isCompleting = true;
    });

    try {
      final completed = await _service.completeTodayCommitment();

      if (!mounted) {
        return;
      }

      setState(() {
        _commitment = completed;
        _isCompleting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('আজকের সংকল্প সম্পন্ন হয়েছে।'),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isCompleting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('সংকল্প সম্পন্ন করা যায়নি: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('আজকের স্বাধ্যায়'),
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
                      'আজকের একটি ছোট সংকল্প',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'এমন একটি কাজ বেছে নিন, যা আজ বাস্তবে করা সম্ভব।',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _controller,
                      maxLines: 4,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        labelText: 'আমার আজকের সংকল্প',
                        hintText:
                            'যেমন: রাগের মুহূর্তে উত্তর দেওয়ার আগে ১০ সেকেন্ড থামব।',
                        border: OutlineInputBorder(),
                      ),
                      enabled: _commitment == null &&
                          !_isSaving &&
                          !_isCompleting,
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
                              : const Text('আজকের সংকল্প সংরক্ষণ করুন'),
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
                                'আজকের সংকল্প',
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
                              if (_commitment!.isCompleted)
                                const Row(
                                  children: [
                                    Icon(Icons.check_circle_outline),
                                    SizedBox(width: 8),
                                    Text('আজকের সংকল্প সম্পন্ন হয়েছে'),
                                  ],
                                )
                              else
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: _isCompleting
                                        ? null
                                        : _completeCommitment,
                                    icon: _isCompleting
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
