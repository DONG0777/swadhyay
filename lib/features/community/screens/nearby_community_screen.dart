import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/community_place.dart';
import '../models/nearby_community_place.dart';
import '../services/community_practice_service.dart';
import 'community_routine_screen.dart';

class NearbyCommunityScreen extends StatefulWidget {
  const NearbyCommunityScreen({super.key});

  @override
  State<NearbyCommunityScreen> createState() =>
      _NearbyCommunityScreenState();
}

class _NearbyCommunityScreenState
    extends State<NearbyCommunityScreen> {
  final CommunityPracticeService _service =
      CommunityPracticeService();

  List<NearbyCommunityPlace> _places = [];

  bool _isLoading = true;
  String? _errorMessage;

  static const double _radiusMeters = 5000;

  @override
  void initState() {
    super.initState();
    _loadNearbyPlaces();
  }

  Future<void> _loadNearbyPlaces() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw StateError(
          'ডিভাইসের Location Service চালু নেই।',
        );
      }

      var permission =
          await Geolocator.checkPermission();

      if (permission ==
          LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission ==
          LocationPermission.denied) {
        throw StateError(
          'Location permission দেওয়া হয়নি।',
        );
      }

      if (permission ==
          LocationPermission.deniedForever) {
        throw StateError(
          'Location permission Settings থেকে চালু করতে হবে।',
        );
      }

      final position =
          await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final places =
          await _service.getNearbyCommunityPlaces(
        latitude: position.latitude,
        longitude: position.longitude,
        radiusMeters: _radiusMeters,
        limit: 30,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _places = places;
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
    NearbyCommunityPlace place,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NearbyCommunityDetailScreen(
          place: place,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'কাছাকাছি Community',
        ),
        actions: [
          IconButton(
            onPressed: _loadNearbyPlaces,
            tooltip: 'আবার খুঁজুন',
            icon: const Icon(
              Icons.refresh_outlined,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? _buildErrorState()
              : _places.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadNearbyPlaces,
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
                        itemCount: _places.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final place = _places[index];

                          return Card(
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(12),
                              onTap: () =>
                                  _openCommunity(place),
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(18),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.location_city_outlined,
                                      size: 34,
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            place.name,
                                            style:
                                                Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            place.distanceLabel,
                                            style:
                                                Theme.of(context)
                                                    .textTheme
                                                    .labelLarge,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            place.address,
                                          ),
                                          if (place.description !=
                                              null &&
                                              place.description!
                                                  .trim()
                                                  .isNotEmpty) ...[
                                            const SizedBox(height: 6),
                                            Text(
                                              place.description!,
                                              maxLines: 2,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
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

  Widget _buildErrorState() {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 80),
        const Icon(
          Icons.location_off_outlined,
          size: 56,
        ),
        const SizedBox(height: 16),
        const Text(
          'কাছাকাছি Community খুঁজে পাওয়া যাচ্ছে না।',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _errorMessage!
              .replaceFirst('Bad state: ', ''),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _loadNearbyPlaces,
          icon: const Icon(
            Icons.my_location_outlined,
          ),
          label: const Text(
            'আবার চেষ্টা করুন',
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: const [
        SizedBox(height: 80),
        Icon(
          Icons.explore_outlined,
          size: 56,
        ),
        SizedBox(height: 16),
        Text(
          '৫ কিমির মধ্যে কোনো Community পাওয়া যায়নি।',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'আপনি চাইলে এই এলাকায় একটি নতুন Community কেন্দ্র শুরু করতে পারেন।',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class NearbyCommunityDetailScreen
    extends StatelessWidget {
  final NearbyCommunityPlace place;

  const NearbyCommunityDetailScreen({
    required this.place,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Community',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              place.name,
              style:
                  Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(place.distanceLabel),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.address,
                    ),
                    if (place.description != null) ...[
                      const SizedBox(height: 12),
                      Text(place.description!),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Community-এর routine ও upcoming session দেখতে Community কেন্দ্র খুলুন।',
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                final communityPlace =
                    _toCommunityPlace();

                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        CommunityRoutineScreen(
                      place: communityPlace,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.open_in_new_outlined,
              ),
              label: const Text(
                'Community কেন্দ্র খুলুন',
              ),
            ),
          ],
        ),
      ),
    );
  }

  dynamic _toCommunityPlace() {
    return CommunityPlaceAdapter.fromNearby(place);
  }
}

class CommunityPlaceAdapter {
  static CommunityPlace fromNearby(
    NearbyCommunityPlace place,
  ) {
    return CommunityPlace(
      id: place.id,
      createdBy: '',
      name: place.name,
      description: place.description,
      address: place.address,
      timezone: place.timezone,
    );
  }
}




