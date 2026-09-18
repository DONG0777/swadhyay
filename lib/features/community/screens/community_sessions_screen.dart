import 'package:flutter/material.dart';

import '../models/community_session.dart';
import '../models/community_routine.dart';
import '../models/session_participant.dart';
import '../services/community_service.dart';
import '../services/community_practice_service.dart';
import 'community_session_create_screen.dart';
import 'community_session_agenda_screen.dart';
import 'community_session_qr_screen.dart';
import 'community_session_scanner_screen.dart';
import '../../../core/localization/app_strings.dart';

class CommunitySessionsScreen extends StatefulWidget {
  final String? placeId;

  const CommunitySessionsScreen({
    super.key,
    this.placeId,
  });

  @override
  State<CommunitySessionsScreen> createState() =>
      _CommunitySessionsScreenState();
}

class _CommunitySessionsScreenState
    extends State<CommunitySessionsScreen> {
  final CommunityService _service = CommunityService();

  List<CommunitySession> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    try {
      final sessions = await _service.getUpcomingSessions(placeId: widget.placeId);

      if (!mounted) {
        return;
      }

      setState(() {
        _sessions = sessions;
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
          content: Text(AppStrings.of(context).communitySessionsLoadFailed(error)),
        ),
      );
    }
  }

  Future<void> _createSession() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => const CommunitySessionCreateScreen(),
      ),
    );

    if (created == true) {
      await _loadSessions();
    }
  }

  Future<void> _openSession(CommunitySession session) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CommunitySessionDetailScreen(
          session: session,
        ),
      ),
    );

    await _loadSessions();
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');

    return '$day/$month/${local.year}  $hour:$minute';
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.of(context).communitySessions),
        actions: [
          IconButton(
            onPressed: _createSession,
            tooltip: AppStrings.of(context).communityNewSession,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createSession,
        icon: const Icon(Icons.add),
          label: Text(AppStrings.of(context).communityNewSession),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadSessions,
              child: _sessions.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(24),
                      children: [
                        const SizedBox(height: 80),
                        Icon(
                          Icons.groups_outlined,
                          size: 56,
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: Text(AppStrings.of(context).communityNoUpcomingSessions,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 8),
                        Center(
                          child: Text(AppStrings.of(context).communityCreateFirstSession,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        100,
                      ),
                      itemCount: _sessions.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final session = _sessions[index];

                        return Card(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _openSession(session),
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge,
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outlineVariant,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      session.routineId != null
                                          ? AppStrings.of(context)
                                              .communitySessionTypeRoutine
                                          : AppStrings.of(context)
                                              .communitySessionTypeSpecial,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          session.locationName,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.schedule_outlined,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${_formatDateTime(session.startsAt)}'
                                          ' - '
                                          '${_formatDateTime(session.endsAt)}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (session.description != null) ...[
                                    const SizedBox(height: 10),
                                    Text(
                                      session.description!,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  const Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.chevron_right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}

class CommunitySessionDetailScreen extends StatefulWidget {
  final CommunitySession session;

  const CommunitySessionDetailScreen({
    required this.session,
    super.key,
  });

  @override
  State<CommunitySessionDetailScreen> createState() =>
      _CommunitySessionDetailScreenState();
}

class _CommunitySessionDetailScreenState
    extends State<CommunitySessionDetailScreen> {
  final CommunityService _service = CommunityService();
  final CommunityPracticeService _practiceService =
      CommunityPracticeService();

  CommunityRoutine? _routine;

  SessionParticipant? _myParticipation;
  int _participantCount = 0;

  bool _isLoading = true;
  bool _isJoining = false;
  bool _isLeaving = false;

  @override
  void initState() {
    super.initState();
    _loadParticipation();
  }

  Future<void> _loadParticipation() async {
    try {
      final myParticipation = await _service.getMyParticipation(
        widget.session.id,
      );
      final participants = await _service.getSessionParticipants(
        widget.session.id,
      );

      CommunityRoutine? routine;
      if (widget.session.routineId != null) {
        routine = await _practiceService.getRoutine(
          widget.session.routineId!,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _myParticipation = myParticipation;
        _participantCount = participants.length;
        _routine = routine;
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
            AppStrings.of(context).communitySessionInfoLoadFailed(error),
          ),
        ),
      );
    }
  }

  Future<void> _joinSession() async {
    setState(() {
      _isJoining = true;
    });

    try {
      await _service.joinSession(widget.session.id);

      if (!mounted) {
        return;
      }

      await _loadParticipation();

      if (!mounted) {
        return;
      }

      setState(() {
        _isJoining = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.of(context).communitySessionJoined),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isJoining = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.of(context).communitySessionJoinFailed(error)),
        ),
      );
    }
  }

  Future<void> _leaveSession() async {
    setState(() {
      _isLeaving = true;
    });

    try {
      await _service.leaveSession(widget.session.id);

      if (!mounted) {
        return;
      }

      await _loadParticipation();

      if (!mounted) {
        return;
      }

      setState(() {
        _isLeaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.of(context).communitySessionLeft),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLeaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.of(context).communitySessionLeaveFailed(error)),
        ),
      );
    }
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');

    return '$day/$month/${local.year}  $hour:$minute';
  }

  String _formatRoutineSchedule(
    BuildContext context,
    CommunityRoutine routine,
  ) {
    final strings = AppStrings.of(context);
    final weekdays = routine.weekdays.toSet().toList()..sort();

    final dayText = weekdays.length == 7
        ? strings.communityEveryDay
        : weekdays
            .where(
              (day) => day >= 1 && day <= strings.weekdays.length,
            )
            .map((day) => strings.weekdays[day - 1])
            .join(' · ');

    final timeParts = routine.startTime.split(':');
    final hour =
        timeParts.isNotEmpty ? timeParts[0].padLeft(2, '0') : '00';
    final minute =
        timeParts.length > 1 ? timeParts[1].padLeft(2, '0') : '00';

    return '$dayText · $hour:$minute · ${routine.durationMinutes} min';
  }


  Future<void> _openAgenda() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CommunitySessionAgendaScreen(
          session: widget.session,
        ),
      ),
    );
  }
  Future<void> _openQrScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CommunitySessionQrScreen(
          session: widget.session,
        ),
      ),
    );
  }

  Future<void> _openScanner() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CommunitySessionScannerScreen(),
      ),
    );

    await _loadParticipation();
  }

  @override
  Widget build(BuildContext context) {
    final isJoined = _myParticipation != null;
    final isCreator = _service.isCurrentUserCreator(widget.session);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.of(context).communitySession),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.session.title,
                    style:
                        Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outlineVariant,
                      ),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.session.routineId != null
                          ? AppStrings.of(context)
                              .communitySessionTypeRoutine
                          : AppStrings.of(context)
                              .communitySessionTypeSpecial,
                      style:
                          Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.location_on_outlined,
                    ),
                    title: Text(AppStrings.of(context).communityLocation),
                    subtitle: Text(
                      widget.session.locationName,
                    ),
                  ),
                  if (widget.session.locationDetails != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 56),
                      child: Text(
                        widget.session.locationDetails!,
                      ),
                    ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.schedule_outlined,
                    ),
                    title: Text(AppStrings.of(context).communityTime),
                    subtitle: Text(
                      '${_formatDateTime(widget.session.startsAt)}'
                        ' - '
                      '${_formatDateTime(widget.session.endsAt)}',
                    ),
                  ),
                  if (_routine != null) ...[
                    const SizedBox(height: 8),
                    Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        leading: const Icon(
                          Icons.repeat_outlined,
                        ),
                        title: Text(
                          AppStrings.of(context).communityRecurringSchedule,
                        ),
                        subtitle: Text(
                          _formatRoutineSchedule(
                            context,
                            _routine!,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (widget.session.description != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      widget.session.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                  const SizedBox(height: 20),
                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.groups_outlined,
                      ),
                      title: Text(AppStrings.of(context).communityParticipants),
                      trailing: Text(
                        _participantCount.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                                    SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _openAgenda,
                      icon: const Icon(
                        Icons.schedule_outlined,
                      ),
                      label: Text(
                        AppStrings.of(context).communityViewAgenda,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isCreator) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _openQrScreen,
                        icon: const Icon(
                          Icons.qr_code_2_outlined,
                        ),
                        label: Text(
                          AppStrings.of(context).communityShowCheckinQr,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _openScanner,
                      icon: const Icon(
                        Icons.qr_code_scanner_outlined,
                      ),
                      label: Text(
                        AppStrings.of(context).communityScanQrForAttendance,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isJoined)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed:
                            _isLeaving ? null : _leaveSession,
                        icon: _isLeaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.exit_to_app_outlined,
                              ),
                        label: Text(
                          AppStrings.of(context).communityLeaveSession,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed:
                            _isJoining ? null : _joinSession,
                        icon: _isJoining
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.group_add_outlined,
                              ),
                        label: Text(
                          AppStrings.of(context).communityJoinSession,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}



