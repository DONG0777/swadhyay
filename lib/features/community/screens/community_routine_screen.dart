import 'package:flutter/material.dart';

import '../models/community_place.dart';
import '../models/community_routine.dart';
import '../services/community_practice_service.dart';

class CommunityRoutineScreen extends StatefulWidget {
  final CommunityPlace place;

  const CommunityRoutineScreen({
    required this.place,
    super.key,
  });

  @override
  State<CommunityRoutineScreen> createState() =>
      _CommunityRoutineScreenState();
}

class _CommunityRoutineScreenState
    extends State<CommunityRoutineScreen> {
  final CommunityPracticeService _service =
      CommunityPracticeService();

  List<CommunityRoutine> _routines = [];
  bool _isLoading = true;

  static const weekdayNames = [
    'সোমবার',
    'মঙ্গলবার',
    'বুধবার',
    'বৃহস্পতিবার',
    'শুক্রবার',
    'শনিবার',
    'রবিবার',
  ];

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    try {
      final routines =
          await _service.getRoutines(widget.place.id);

      if (!mounted) {
        return;
      }

      setState(() {
        _routines = routines;
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
          content: Text('Weekly routine লোড করা যায়নি: $error'),
        ),
      );
    }
  }

  Future<void> _createRoutine() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => CommunityRoutineCreateScreen(
          place: widget.place,
        ),
      ),
    );

    if (created == true) {
      await _loadRoutines();
    }
  }

  String _weekdayName(int weekday) {
    if (weekday < 1 || weekday > 7) {
      return '';
    }

    return weekdayNames[weekday - 1];
  }

  String _displayTime(String value) {
    if (value.length >= 5) {
      return value.substring(0, 5);
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createRoutine,
        icon: const Icon(Icons.schedule_outlined),
        label: const Text('Routine যোগ করুন'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadRoutines,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  100,
                ),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'নিয়মিত অনুশীলন',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(widget.place.address),
                          const SizedBox(height: 8),
                          const Text(
                            'এই কেন্দ্রের সাপ্তাহিক নিয়মিত সময়সূচি।',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_routines.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'এখনও কোনো weekly routine নেই।',
                        ),
                      ),
                    )
                  else
                    ..._routines.map(
                      (routine) => Card(
                        margin:
                            const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(
                            Icons.calendar_today_outlined,
                          ),
                          title: Text(routine.title),
                          subtitle: Text(
                            '${_weekdayName(routine.weekday)}'
                            ' • ${_displayTime(routine.startTime)}'
                            ' • ${routine.durationMinutes} মিনিট',
                          ),
                          trailing: routine.isActive
                              ? const Icon(
                                  Icons.check_circle_outline,
                                )
                              : const Icon(
                                  Icons.pause_circle_outline,
                                ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class CommunityRoutineCreateScreen extends StatefulWidget {
  final CommunityPlace place;

  const CommunityRoutineCreateScreen({
    required this.place,
    super.key,
  });

  @override
  State<CommunityRoutineCreateScreen> createState() =>
      _CommunityRoutineCreateScreenState();
}

class _CommunityRoutineCreateScreenState
    extends State<CommunityRoutineCreateScreen> {
  final CommunityPracticeService _service =
      CommunityPracticeService();

  final TextEditingController _titleController =
      TextEditingController();

  int _weekday = DateTime.sunday;
  TimeOfDay _time = const TimeOfDay(hour: 6, minute: 30);
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _time = result;
    });
  }

  Future<void> _saveRoutine() async {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Routine-এর নাম দিন।'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final startTime =
        '${_time.hour.toString().padLeft(2, '0')}:'
        '${_time.minute.toString().padLeft(2, '0')}:00';

    try {
      await _service.createRoutine(
        placeId: widget.place.id,
        weekday: _weekday,
        startTime: startTime,
        title: title,
        durationMinutes: 60,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Weekly routine তৈরি হয়েছে।'),
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
          content: Text('Routine তৈরি করা যায়নি: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Routine'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              value: _weekday,
              decoration: const InputDecoration(
                labelText: 'বার',
                border: OutlineInputBorder(),
              ),
              items: List.generate(
                7,
                (index) => DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text(
                    [
                      'সোমবার',
                      'মঙ্গলবার',
                      'বুধবার',
                      'বৃহস্পতিবার',
                      'শুক্রবার',
                      'শনিবার',
                      'রবিবার',
                    ][index],
                  ),
                ),
              ),
              onChanged: _isSaving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          _weekday = value;
                        });
                      }
                    },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              maxLength: 200,
              decoration: const InputDecoration(
                labelText: 'Routine-এর নাম',
                hintText:
                    'যেমন: রবিবারের সম্মিলিত স্বাধ্যায়',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.schedule_outlined,
                ),
                title: const Text('শুরু সময়'),
                subtitle: Text(_time.format(context)),
                trailing: const Icon(
                  Icons.edit_outlined,
                ),
                onTap: _isSaving ? null : _selectTime,
              ),
            ),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                leading: Icon(
                  Icons.timer_outlined,
                ),
                title: Text('সময়কাল'),
                subtitle: Text('৬০ মিনিট — standard community practice'),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed:
                    _isSaving ? null : _saveRoutine,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.schedule_outlined,
                      ),
                label: const Text(
                  'Weekly Routine সংরক্ষণ করুন',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
