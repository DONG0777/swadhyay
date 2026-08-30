import 'package:flutter/material.dart';

import '../models/community_session.dart';
import '../models/session_participant.dart';
import '../services/community_service.dart';
import 'community_session_create_screen.dart';
import 'community_session_agenda_screen.dart';
import 'community_session_qr_screen.dart';
import 'community_session_scanner_screen.dart';

class CommunitySessionsScreen extends StatefulWidget {
  const CommunitySessionsScreen({super.key});

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
      final sessions = await _service.getUpcomingSessions();

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
          content: Text('Community sessions লোড করা যায়নি: $error'),
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
        title: const Text('সম্মিলিত সূর্য নমস্কার'),
        actions: [
          IconButton(
            onPressed: _createSession,
            tooltip: 'নতুন session',
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createSession,
        icon: const Icon(Icons.add),
        label: const Text('নতুন session'),
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
                      children: const [
                        SizedBox(height: 80),
                        Icon(
                          Icons.groups_outlined,
                          size: 56,
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: Text(
                            'এখনও কোনো আসন্ন session নেই।',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 8),
                        Center(
                          child: Text(
                            'তুমি নিজেই প্রথম session তৈরি করতে পারো।',
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
                                          ' — '
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

      if (!mounted) {
        return;
      }

      setState(() {
        _myParticipation = myParticipation;
        _participantCount = participants.length;
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
            'Session information লোড করা যায়নি: $error',
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
        const SnackBar(
          content: Text('Session-এ যোগ দেওয়া হয়েছে।'),
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
          content: Text('Session-এ যোগ দেওয়া যায়নি: $error'),
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
        const SnackBar(
          content: Text('Session থেকে বেরিয়ে এসেছেন।'),
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
          content: Text('Session থেকে বের হওয়া যায়নি: $error'),
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
        title: const Text('Session'),
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
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.location_on_outlined,
                    ),
                    title: const Text('স্থান'),
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
                    title: const Text('সময়'),
                    subtitle: Text(
                      '${_formatDateTime(widget.session.startsAt)}'
                      ' — '
                      '${_formatDateTime(widget.session.endsAt)}',
                    ),
                  ),
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
                      title: const Text('অংশগ্রহণকারী'),
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
                      label: const Text(
                        '১ ঘণ্টার কার্যক্রম দেখুন',
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
                        label: const Text(
                          'Check-in QR দেখান',
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
                      label: const Text(
                        'QR scan করে উপস্থিতি দিন',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),                  if (isJoined)
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
                        label: const Text(
                          'Session থেকে বের হোন',
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
                        label: const Text(
                          'Session-এ যোগ দিন',
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}



