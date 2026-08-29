import 'package:flutter/material.dart';

import '../models/daily_commitment.dart';
import '../services/daily_commitment_service.dart';

class TomorrowCommitmentScreen extends StatefulWidget {
  const TomorrowCommitmentScreen({super.key});

  @override
  State<TomorrowCommitmentScreen> createState() =>
      _TomorrowCommitmentScreenState();
}

class _TomorrowCommitmentScreenState
    extends State<TomorrowCommitmentScreen> {
  final DailyCommitmentService _service = DailyCommitmentService();
  final TextEditingController _controller = TextEditingController();

  late final DateTime _tomorrow;

  DailyCommitment? _commitment;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tomorrow = _dateOnly(
      DateTime.now().add(const Duration(days: 1)),
    );
    _loadTomorrowCommitment();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadTomorrowCommitment() async {
    try {
      final commitment =
          await _service.getCommitmentForDate(_tomorrow);

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
          content: Text('আগামীকালের সংকল্প লোড করা যায়নি: $error'),
        ),
      );
    }
  }

  Future<void> _saveCommitment() async {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('আগামীকালের জন্য একটি ছোট ও নির্দিষ্ট সংকল্প লিখুন।'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final commitment = _commitment == null
          ? await _service.createCommitmentForDate(
              date: _tomorrow,
              commitmentText: text,
            )
          : await _service.updateCommitmentForDate(
              date: _tomorrow,
              commitmentText: text,
            );

      if (!mounted) {
        return;
      }

      setState(() {
        _commitment = commitment;
        _controller.text = commitment.commitmentText;
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('আগামীকালের সংকল্প সংরক্ষিত হয়েছে।'),
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
          content: Text('আগামীকালের সংকল্প সংরক্ষণ করা যায়নি: $error'),
        ),
      );
    }
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    final tomorrowLabel =
        '${_tomorrow.day.toString().padLeft(2, '0')}/'
        '${_tomorrow.month.toString().padLeft(2, '0')}/'
        '${_tomorrow.year}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('আগামীকালের সংকল্প'),
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
                      'আগামীকাল একটু ভালো কীভাবে করব?',
                      style:
                          Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'তারিখ: $tomorrowLabel',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'আজ যা শিখলে, তার ভিত্তিতে আগামীকালের জন্য একটি ছোট, '
                      'নির্দিষ্ট এবং বাস্তবে করা সম্ভব এমন কাজ বেছে নিন।',
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _controller,
                      maxLines: 5,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        labelText: 'আমার আগামীকালের সংকল্প',
                        hintText:
                            'যেমন: সকালে ১০ মিনিট মনোযোগ দিয়ে স্বাধ্যায় করব।',
                        border: OutlineInputBorder(),
                      ),
                      enabled: !_isSaving,
                    ),
                    const SizedBox(height: 20),
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
                            : Text(
                                _commitment == null
                                    ? 'আগামীকালের সংকল্প সংরক্ষণ করুন'
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
