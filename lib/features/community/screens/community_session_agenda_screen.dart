import 'package:flutter/material.dart';

import '../models/community_agenda_item.dart';
import '../models/community_session.dart';
import '../services/community_practice_service.dart';

class CommunitySessionAgendaScreen extends StatefulWidget {
  final CommunitySession session;

  const CommunitySessionAgendaScreen({
    required this.session,
    super.key,
  });

  @override
  State<CommunitySessionAgendaScreen> createState() =>
      _CommunitySessionAgendaScreenState();
}

class _CommunitySessionAgendaScreenState
    extends State<CommunitySessionAgendaScreen> {
  final CommunityPracticeService _service =
      CommunityPracticeService();

  List<CommunityAgendaItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAgenda();
  }

  Future<void> _loadAgenda() async {
    try {
      var items = await _service.getSessionAgenda(
        widget.session.id,
      );

      if (items.isEmpty) {
        items = await _service.createDefaultAgenda(
          widget.session.id,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _items = items;
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
            '১ ঘণ্টার কার্যক্রম লোড করা যায়নি: $error',
          ),
        ),
      );
    }
  }

  IconData _iconFor(String activityType) {
    switch (activityType) {
      case 'gathering':
        return Icons.groups_outlined;
      case 'prayer':
        return Icons.self_improvement_outlined;
      case 'surya_namaskar':
        return Icons.wb_sunny_outlined;
      case 'mindfulness':
        return Icons.spa_outlined;
      case 'self_study':
        return Icons.menu_book_outlined;
      case 'social_dialogue':
        return Icons.forum_outlined;
      case 'seva':
        return Icons.volunteer_activism_outlined;
      case 'sankalpa':
        return Icons.flag_outlined;
      case 'closing':
        return Icons.done_all_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('১ ঘণ্টার কার্যক্রম'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadAgenda,
              child: _items.isEmpty
                  ? ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 100),
                        Center(
                          child: Text(
                            'এই session-এর কোনো কার্যক্রম নেই।',
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];

                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: 12),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    child: Text(
                                      item.sequenceNumber.toString(),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Icon(
                                    _iconFor(item.activityType),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${item.durationMinutes} মিনিট',
                                        ),
                                        if (item.description != null) ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            item.description!,
                                          ),
                                        ],
                                      ],
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
