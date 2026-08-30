import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/community_place.dart';
import '../services/community_practice_service.dart';
import 'community_routine_screen.dart';
import 'nearby_community_screen.dart';

class CommunityPlacesScreen extends StatefulWidget {
  const CommunityPlacesScreen({super.key});

  @override
  State<CommunityPlacesScreen> createState() =>
      _CommunityPlacesScreenState();
}

class _CommunityPlacesScreenState
    extends State<CommunityPlacesScreen> {
  final CommunityPracticeService _service =
      CommunityPracticeService();

  List<CommunityPlace> _places = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    try {
      final places = await _service.getCommunityPlaces();

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
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Community place লোড করা যায়নি: $error',
          ),
        ),
      );
    }
  }

  Future<void> _createPlace() async {
    final createdPlace =
        await Navigator.of(context).push<CommunityPlace>(
      MaterialPageRoute<CommunityPlace>(
        builder: (_) => const CommunityPlaceCreateScreen(),
      ),
    );

    if (createdPlace == null || !mounted) {
      return;
    }

    await _loadPlaces();

    if (!mounted) {
      return;
    }

    final setupRoutine = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'কেন্দ্র তৈরি হয়েছে',
          ),
          content: const Text(
            'এখন কি এই কেন্দ্রে নিয়মিত অনুশীলনের দিন ও সময় সেট করবেন?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('পরে'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('এখনই সেট করি'),
            ),
          ],
        );
      },
    );

    if (setupRoutine == true && mounted) {
      await _openPlace(createdPlace);
    }
  }

  Future<void> _openPlace(CommunityPlace place) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CommunityRoutineScreen(
          place: place,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('কমিউনিটি কেন্দ্র'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      const NearbyCommunityScreen(),
                ),
              );
            },
            tooltip: 'কাছাকাছি Community',
            icon: const Icon(
              Icons.near_me_outlined,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createPlace,
        icon: const Icon(
          Icons.add_location_alt_outlined,
        ),
        label: const Text('নতুন কেন্দ্র'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadPlaces,
              child: _places.isEmpty
                  ? ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(24),
                      children: [
                        const SizedBox(height: 70),
                        const Icon(
                          Icons.location_city_outlined,
                          size: 56,
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'এখনও কোনো কমিউনিটি কেন্দ্র তৈরি হয়নি।',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'একটি নির্দিষ্ট স্থানকে নিয়মিত স্বাধ্যায় কেন্দ্র হিসেবে শুরু করুন।',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _createPlace,
                          icon: const Icon(
                            Icons.add_location_alt_outlined,
                          ),
                          label: const Text(
                            'প্রথম কেন্দ্র তৈরি করুন',
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        100,
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
                            onTap: () => _openPlace(place),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(18),
                              child: Row(
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
                                        const SizedBox(height: 5),
                                        Text(place.address),
                                        if (place.description !=
                                            null) ...[
                                          const SizedBox(height: 5),
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
}

class CommunityPlaceCreateScreen extends StatefulWidget {
  const CommunityPlaceCreateScreen({super.key});

  @override
  State<CommunityPlaceCreateScreen> createState() =>
      _CommunityPlaceCreateScreenState();
}

class _CommunityPlaceCreateScreenState
    extends State<CommunityPlaceCreateScreen> {
  final CommunityPracticeService _service =
      CommunityPracticeService();

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _descriptionController =
      TextEditingController();

  final TextEditingController _addressController =
      TextEditingController();

  bool _isSaving = false;
  bool _isLocating = false;
  double? _latitude;
  double? _longitude;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    if (_isSaving || _isLocating) {
      return;
    }

    setState(() {
      _isLocating = true;
    });

    try {
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'ডিভাইসের Location Service চালু করুন।',
            ),
          ),
        );
        return;
      }

      var permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permission দেওয়া হয়নি।',
            ),
          ),
        );
        return;
      }

      if (permission ==
              LocationPermission.deniedForever) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permission Settings থেকে চালু করতে হবে।',
            ),
          ),
        );
        return;
      }

      final position =
          await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'এই স্থানের অবস্থান নেওয়া হয়েছে।',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Location নেওয়া যায়নি: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLocating = false;
        });
      }
    }
  }
  Future<void> _savePlace() async {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'কেন্দ্রের নাম এবং ঠিকানা দিন।',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final place =
          await _service.createCommunityPlace(
        name: name,
        description: _descriptionController.text,
        address: address,
        latitude: _latitude,
        longitude: _longitude,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(place);
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
            'কেন্দ্র তৈরি করা যায়নি: $error',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'নতুন কমিউনিটি কেন্দ্র',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              maxLength: 200,
              decoration: const InputDecoration(
                labelText: 'কেন্দ্রের নাম',
                hintText:
                    'যেমন: জলপাইগুড়ি স্বাধ্যায় কেন্দ্র',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              maxLength: 2000,
              decoration: const InputDecoration(
                labelText: 'কেন্দ্র সম্পর্কে',
                hintText:
                    'এই কেন্দ্রের উদ্দেশ্য সম্পর্কে সংক্ষেপে লিখুন...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              maxLines: 3,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: 'ঠিকানা',
                hintText:
                    'মাঠ / পার্ক / নির্দিষ্ট স্থান',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.my_location_outlined,
                ),
                title: const Text(
                  'এই স্থানের অবস্থান ব্যবহার করুন',
                ),
                subtitle: Text(
                  _latitude != null && _longitude != null
                      ? 'Location নেওয়া হয়েছে'
                      : 'Nearby Community খুঁজতে সাহায্য করবে',
                ),
                trailing: _isLocating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        _latitude != null &&
                                _longitude != null
                            ? Icons.check_circle_outline
                            : Icons.location_searching_outlined,
                      ),
                onTap: _isSaving || _isLocating
                    ? null
                    : _useCurrentLocation,
              ),
            ),            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed:
                    _isSaving ? null : _savePlace,
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
                        Icons.add_location_alt_outlined,
                      ),
                label: const Text(
                  'কেন্দ্র তৈরি করুন',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}







