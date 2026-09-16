import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';

import '../models/my_community_place.dart';
import '../services/community_practice_service.dart';
import 'community_sessions_screen.dart';

class MyCommunityScreen extends StatefulWidget {
  const MyCommunityScreen({super.key});

  @override
  State<MyCommunityScreen> createState() =>
      _MyCommunityScreenState();
}

class _MyCommunityScreenState
    extends State<MyCommunityScreen> {
  final CommunityPracticeService _service =
      CommunityPracticeService();

  List<MyCommunityPlace> _communities = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  Future<void> _loadCommunities() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final communities =
          await _service.getMyCommunities();

      if (!mounted) {
        return;
      }

      setState(() {
        _communities = communities;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _openCommunity(
    MyCommunityPlace community,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CommunitySessionsScreen(
          placeId: community.place.id,
        ),
      ),
    );
  }

  Future<void> _leaveCommunity(
    MyCommunityPlace community,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppStrings.of(context).communityLeaveConfirmTitle,
          ),
          content: Text(
            AppStrings.of(context).communityLeaveConfirmMessage(
              community.place.name,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false),
              child: Text(AppStrings.of(context).cancel),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(true),
              child: Text(AppStrings.of(context).communityLeave),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _service.leaveCommunity(
        community.place.id,
      );

      await _loadCommunities();
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.of(context).communityLeaveFailed(error),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.of(context).myCommunity,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? _buildErrorState()
              : _communities.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadCommunities,
                      child: ListView.separated(
                        physics:
                            const AlwaysScrollableScrollPhysics(),
                        padding:
                            const EdgeInsets.fromLTRB(
                          16,
                          16,
                          16,
                          24,
                        ),
                        itemCount: _communities.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final community =
                              _communities[index];

                          return Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_city_outlined,
                                        size: 34,
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          community.place.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    community.place.address,
                                  ),
                                  if (community
                                          .place.description !=
                                      null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      community
                                          .place.description!,
                                      maxLines: 2,
                                      overflow:
                                          TextOverflow.ellipsis,
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child:
                                            FilledButton.icon(
                                          onPressed: () =>
                                              _openCommunity(
                                            community,
                                          ),
                                          icon: const Icon(
                                            Icons.open_in_new_outlined,
                                          ),
                                          label: Text(
                                             AppStrings.of(context).communityOpenCenter,
                                           ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        tooltip: AppStrings.of(context).communityLeave,
                                        onPressed: () =>
                                            _leaveCommunity(
                                          community,
                                        ),
                                        icon: const Icon(
                                          Icons
                                              .logout_outlined,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        SizedBox(height: 80),
        Icon(
          Icons.groups_outlined,
          size: 56,
        ),
        SizedBox(height: 16),
        Text(
           AppStrings.of(context).myCommunityEmpty,
           textAlign: TextAlign.center,
         ),
        SizedBox(height: 8),
        Text(
           AppStrings.of(context).myCommunityEmptySubtitle,
           textAlign: TextAlign.center,
         ),
      ],
    );
  }

  Widget _buildErrorState() {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 80),
        const Icon(
          Icons.error_outline,
          size: 56,
        ),
        const SizedBox(height: 16),
        Text(
          _errorMessage ??
              AppStrings.of(context).myCommunityLoadFailed,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _loadCommunities,
          icon: const Icon(
            Icons.refresh_outlined,
          ),
          label: Text(
             AppStrings.of(context).retry,
           ),
        ),
      ],
    );
  }
}
