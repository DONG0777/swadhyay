import 'package:flutter/material.dart';

import '../../../core/localization/app_strings.dart';

import '../models/community_place.dart';
import '../models/community_routine.dart';
import '../services/community_practice_service.dart';
import '../services/community_service.dart';

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
            AppStrings.of(context).communityRoutineLoadFailed(error),
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
        SnackBar(
          content: Text(
            AppStrings.of(context).communityFirstSessionCreated,
          ),
        ),
      );
    }
  }

  String _weekdayName(int weekday) {
    if (weekday < 1 || weekday > 7) {
      return '';
    }

    return AppStrings.of(context).weekdays[weekday - 1];
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
        label: Text(AppStrings.of(context).communityAddRoutine),
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
                            AppStrings.of(context).communityRegularPractice,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(widget.place.address),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.of(context).communityWeeklyRoutineHint,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_routines.isEmpty)
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          AppStrings.of(context).communityNoRoutines,
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
                                          '${routine.weekdays.map(_weekdayName).join(', ')}'
                                          ' • ${_displayTime(routine.startTime)}'
                                          ' • ${routine.durationMinutes} ${AppStrings.of(context).minutes}',
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
                                    label: Text(
                                      AppStrings.of(context).communityCreateFirstSessionButton,
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

  final Set<int> _selectedWeekdays = <int>{DateTime.sunday};
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
        SnackBar(
          content: Text(AppStrings.of(context).communityRoutineNameRequired),
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
        weekdays: _selectedWeekdays.toList()..sort(),
        startTime: startTime,
        title: title,
        durationMinutes: 60,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.of(context).communityRoutineCreated,
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
            AppStrings.of(context).communityRoutineCreateFailed(error),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.of(context).communityRoutine),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            InputDecorator(
              decoration: InputDecoration(
                labelText: AppStrings.of(context).communityDayLabel,
                border: const OutlineInputBorder(),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  7,
                  (index) {
                    final weekday = index + 1;
                    final selected = _selectedWeekdays.contains(weekday);

                    return FilterChip(
                      label: Text(AppStrings.of(context).weekdays[index]),
                      selected: selected,
                      onSelected: _isSaving
                          ? null
                          : (value) {
                              if (!value &&
                                  _selectedWeekdays.length == 1) {
                                return;
                              }

                              setState(() {
                                if (value) {
                                  _selectedWeekdays.add(weekday);
                                } else {
                                  _selectedWeekdays.remove(weekday);
                                }
                              });
                            },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              maxLength: 200,
              decoration: InputDecoration(
                labelText:
                    AppStrings.of(context).communityRoutineName,
                hintText:
                    AppStrings.of(context).communityRoutineNameHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading:
                    const Icon(Icons.schedule_outlined),
                title: Text(AppStrings.of(context).communityStartTime),
                subtitle:
                    Text(_time.format(context)),
                trailing:
                    const Icon(Icons.edit_outlined),
                onTap:
                    _isSaving ? null : _selectTime,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.timer_outlined,
                ),
                title: Text(AppStrings.of(context).communityDuration),
                subtitle: Text(
                  AppStrings.of(context).communityStandardPracticeDuration,
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
                label: Text(
                  AppStrings.of(context).communitySaveRoutine,
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

    final daysUntil = routine.weekdays
        .map((weekday) => (weekday - candidate.weekday + 7) % 7)
        .map((days) => days == 0 && !candidate.isAfter(now) ? 7 : days)
        .reduce((a, b) => a < b ? a : b);

    candidate = candidate.add(Duration(days: daysUntil));

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
        SnackBar(
          content: Text(
            AppStrings.of(context).communitySessionEndAfterStart,
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
        SnackBar(
          content: Text(
            AppStrings.of(context).communityFirstSessionAndAgendaCreated,
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
            AppStrings.of(context).communitySessionCreateFailed(error),
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
            Text(
              AppStrings.of(context).communityFirstSessionTitle,
            ),
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
              '${AppStrings.of(context).communityRoutineLabel}: ${widget.routine.weekdays.map((day) => AppStrings.of(context).weekdays[day - 1]).join(', ')}'
              ' • ${widget.routine.startTime.substring(0, 5)}'
              ' • ${widget.routine.durationMinutes} ${AppStrings.of(context).minutes}',
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading:
                    const Icon(Icons.event_outlined),
                title: Text(
                  AppStrings.of(context).communityFirstSession,
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
              decoration: InputDecoration(
                labelText:
                    AppStrings.of(context).communitySessionDescription,
                hintText:
                    AppStrings.of(context).communityFirstSessionDescriptionHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppStrings.of(context).communitySessionAgendaAutoCreated,
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
                label: Text(
                  AppStrings.of(context).communityCreateFirstSessionButton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
