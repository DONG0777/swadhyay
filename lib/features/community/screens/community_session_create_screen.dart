import 'package:flutter/material.dart';

import '../services/community_practice_service.dart';
import '../services/community_service.dart';

class CommunitySessionCreateScreen extends StatefulWidget {
  const CommunitySessionCreateScreen({super.key});

  @override
  State<CommunitySessionCreateScreen> createState() =>
      _CommunitySessionCreateScreenState();
}

class _CommunitySessionCreateScreenState
    extends State<CommunitySessionCreateScreen> {
  final CommunityService _service = CommunityService();
  final CommunityPracticeService _practiceService =
      CommunityPracticeService();

  final TextEditingController _titleController =
      TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();
  final TextEditingController _locationController =
      TextEditingController();
  final TextEditingController _locationDetailsController =
      TextEditingController();
  final TextEditingController _capacityController =
      TextEditingController();

  DateTime _startsAt =
      DateTime.now().add(const Duration(days: 1));

  DateTime _endsAt =
      DateTime.now().add(
    const Duration(days: 1, hours: 1),
  );

  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _locationDetailsController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime({
    required bool isStart,
  }) async {
    final current = isStart ? _startsAt : _endsAt;

    final date = await showDatePicker(
      context: context,
      initialDate: current.isBefore(DateTime.now())
          ? DateTime.now()
          : current,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (date == null || !mounted) {
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );

    if (time == null || !mounted) {
      return;
    }

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      if (isStart) {
        _startsAt = selected;

        if (!_endsAt.isAfter(_startsAt)) {
          _endsAt = _startsAt.add(
            const Duration(hours: 1),
          );
        }
      } else {
        _endsAt = selected;
      }
    });
  }

  Future<void> _saveSession() async {
    final title = _titleController.text.trim();
    final location = _locationController.text.trim();

    if (title.isEmpty || location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('নাম এবং স্থান দিন।'),
        ),
      );
      return;
    }

    final capacityText = _capacityController.text.trim();
    final capacity = capacityText.isEmpty
        ? null
        : int.tryParse(capacityText);

    if (capacityText.isNotEmpty && capacity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Capacity-এর জন্য একটি সংখ্যা দিন।'),
        ),
      );
      return;
    }

    if (!_endsAt.isAfter(_startsAt)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('শেষ সময় অবশ্যই শুরুর পর হতে হবে।'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final session = await _service.createSession(
        title: title,
        description: _descriptionController.text,
        locationName: location,
        locationDetails: _locationDetailsController.text,
        startsAt: _startsAt,
        endsAt: _endsAt,
        capacity: capacity,
      );

      await _practiceService.createDefaultAgenda(
        session.id,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Community session এবং ১ ঘণ্টার কার্যক্রম তৈরি হয়েছে।',
          ),
        ),
      );

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Session তৈরি করা যায়নি: $error',
          ),
        ),
      );
    }
  }

  String _formatDateTime(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '$day/$month/${value.year}  $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('নতুন Community Session'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              maxLength: 200,
              decoration: const InputDecoration(
                labelText: 'Session-এর নাম',
                hintText: 'যেমন: সম্মিলিত সূর্য নমস্কার',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              maxLength: 2000,
              decoration: const InputDecoration(
                labelText: 'বিবরণ',
                hintText: 'Session সম্পর্কে সংক্ষেপে লিখুন...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              maxLength: 300,
              decoration: const InputDecoration(
                labelText: 'স্থান',
                hintText: 'যেমন: নির্দিষ্ট মাঠ / পার্ক',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationDetailsController,
              maxLines: 3,
              maxLength: 1000,
              decoration: const InputDecoration(
                labelText: 'স্থানের বিস্তারিত',
                hintText: 'Gate, landmark ইত্যাদি...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.schedule_outlined),
                title: const Text('শুরু'),
                subtitle: Text(
                  _formatDateTime(_startsAt),
                ),
                trailing: const Icon(
                  Icons.edit_calendar_outlined,
                ),
                onTap: () => _selectDateTime(
                  isStart: true,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.schedule_outlined),
                title: const Text('শেষ'),
                subtitle: Text(
                  _formatDateTime(_endsAt),
                ),
                trailing: const Icon(
                  Icons.edit_calendar_outlined,
                ),
                onTap: () => _selectDateTime(
                  isStart: false,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _capacityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText:
                    'সর্বোচ্চ অংশগ্রহণকারী (ঐচ্ছিক)',
                hintText: 'যেমন: 50',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.timer_outlined),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'এই session তৈরি হলে standard 60-minute community practice agenda স্বয়ংক্রিয়ভাবে যুক্ত হবে।',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _saveSession,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.add_circle_outline,
                      ),
                label: const Text(
                  'Community Session তৈরি করুন',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
