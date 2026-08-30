import 'package:flutter/material.dart';

import '../models/community_place.dart';
import '../models/community_routine.dart';
import '../services/community_practice_service.dart';
import '../services/community_service.dart';

const _weekdayNames = [
  'সোমবার',
  'মঙ্গলবার',
  'বুধবার',
  'বৃহস্পতিবার',
  'শুক্রবার',
  'শনিবার',
  'রবিবার',
];
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
          content: Text(
            'Weekly routine লোড করা যায়নি: $error',
          ),
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

  Future<void> _createFirstSession(
    CommunityRoutine routine,
  ) async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => CommunityRoutineFirstSessionScreen(
          place: widget.place,
          routine: routine,
        ),
      ),
    );

    if (created == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'প্রথম Community Session তৈরি হয়েছে।',
          ),
        ),
      );
    }
  }

  String _weekdayName(int weekday) {
    if (weekday < 1 || weekday > 7) {
      return '';
    }

    return _weekdayNames[weekday - 1];
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
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          routine.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${_weekdayName(routine.weekday)}'
                                          ' • ${_displayTime(routine.startTime)}'
                                          ' • ${routine.durationMinutes} মিনিট',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    routine.isActive
                                        ? Icons
                                            .check_circle_outline
                                        : Icons
                                            .pause_circle_outline,
                                  ),
                                ],
                              ),
                              if (routine.isActive) ...[
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: () =>
                                        _createFirstSession(
                                      routine,
                                    ),
                                    icon: const Icon(
                                      Icons.event_available_outlined,
                                    ),
                                    label: const Text(
                                      'প্রথম Session তৈরি করুন',
                                    ),
                                  ),
                                ),
                              ],
                            ],
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
  TimeOfDay _time =
      const TimeOfDay(hour: 6, minute: 30);

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
          content: Text(
            'Weekly routine তৈরি হয়েছে।',
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
            'Routine তৈরি করা যায়নি: $error',
          ),
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
                    _weekdayNames[index],
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
                leading:
                    const Icon(Icons.schedule_outlined),
                title: const Text('শুরু সময়'),
                subtitle:
                    Text(_time.format(context)),
                trailing:
                    const Icon(Icons.edit_outlined),
                onTap:
                    _isSaving ? null : _selectTime,
              ),
            ),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                leading: Icon(
                  Icons.timer_outlined,
                ),
                title: Text('সময়কাল'),
                subtitle: Text(
                  '৬০ মিনিট — standard community practice',
                ),
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
                        child:
                            CircularProgressIndicator(
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

class CommunityRoutineFirstSessionScreen
    extends StatefulWidget {
  final CommunityPlace place;
  final CommunityRoutine routine;

  const CommunityRoutineFirstSessionScreen({
    required this.place,
    required this.routine,
    super.key,
  });

  @override
  State<CommunityRoutineFirstSessionScreen>
      createState() =>
          _CommunityRoutineFirstSessionScreenState();
}

class _CommunityRoutineFirstSessionScreenState
    extends State<CommunityRoutineFirstSessionScreen> {
  final CommunityService _communityService =
      CommunityService();

  final CommunityPracticeService _practiceService =
      CommunityPracticeService();

  final TextEditingController _descriptionController =
      TextEditingController();

  bool _isSaving = false;

  late DateTime _startsAt;
  late DateTime _endsAt;

  @override
  void initState() {
    super.initState();

    _startsAt = _nextRoutineOccurrence(widget.routine);
    _endsAt = _startsAt.add(
      Duration(
        minutes: widget.routine.durationMinutes,
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  DateTime _nextRoutineOccurrence(
    CommunityRoutine routine,
  ) {
    final now = DateTime.now();

    final timeParts = routine.startTime.split(':');

    final hour = timeParts.isNotEmpty
        ? int.tryParse(timeParts[0]) ?? 6
        : 6;

    final minute = timeParts.length > 1
        ? int.tryParse(timeParts[1]) ?? 0
        : 0;

    var candidate = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    var daysUntil =
        (routine.weekday - candidate.weekday + 7) % 7;

    if (daysUntil == 0 &&
        !candidate.isAfter(now)) {
      daysUntil = 7;
    }

    candidate =
        candidate.add(Duration(days: daysUntil));

    return candidate;
  }

  String _formatDateTime(DateTime value) {
    final day =
        value.day.toString().padLeft(2, '0');
    final month =
        value.month.toString().padLeft(2, '0');
    final hour =
        value.hour.toString().padLeft(2, '0');
    final minute =
        value.minute.toString().padLeft(2, '0');

    return '$day/$month/${value.year} '
        '$hour:$minute';
  }

  Future<void> _selectStart() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startsAt,
      firstDate: DateTime.now(),
      lastDate:
          DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (date == null || !mounted) {
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(_startsAt),
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
      _startsAt = selected;

      _endsAt = _startsAt.add(
        Duration(
          minutes: widget.routine.durationMinutes,
        ),
      );
    });
  }

  Future<void> _saveSession() async {
    if (!_endsAt.isAfter(_startsAt)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Session-এর শেষ সময় অবশ্যই শুরুর পরে হতে হবে।',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final session =
          await _communityService.createSession(
        placeId: widget.place.id,
        routineId: widget.routine.id,
        title: widget.routine.title,
        description:
            _descriptionController.text.trim(),
        locationName: widget.place.name,
        locationDetails: widget.place.address,
        startsAt: _startsAt,
        endsAt: _endsAt,
        capacity: null,
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
            'প্রথম Session এবং ১ ঘণ্টার কার্যক্রম তৈরি হয়েছে।',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('প্রথম Community Session'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.location_city_outlined,
                ),
                title: Text(widget.place.name),
                subtitle:
                    Text(widget.place.address),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.routine.title,
              style:
                  Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Routine: ${widget.routine.weekday}'
              ' • ${widget.routine.startTime.substring(0, 5)}'
              ' • ${widget.routine.durationMinutes} মিনিট',
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading:
                    const Icon(Icons.event_outlined),
                title: const Text(
                  'প্রথম Session',
                ),
                subtitle:
                    Text(_formatDateTime(_startsAt)),
                trailing: const Icon(
                  Icons.edit_calendar_outlined,
                ),
                onTap:
                    _isSaving ? null : _selectStart,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller:
                  _descriptionController,
              maxLines: 4,
              maxLength: 2000,
              decoration: const InputDecoration(
                labelText: 'বিবরণ',
                hintText:
                    'এই প্রথম session সম্পর্কে সংক্ষেপে লিখুন...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Session-এর সঙ্গে standard 60-minute community practice agenda স্বয়ংক্রিয়ভাবে যুক্ত হবে।',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed:
                    _isSaving ? null : _saveSession,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.event_available_outlined,
                      ),
                label: const Text(
                  'প্রথম Session তৈরি করুন',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


