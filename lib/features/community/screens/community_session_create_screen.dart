import 'package:flutter/material.dart';

import '../../../core/localization/app_strings.dart';

import '../models/community_place.dart';
import '../services/community_practice_service.dart';
import '../services/community_service.dart';

class CommunitySessionCreateScreen extends StatefulWidget {
  final String? placeId;

  const CommunitySessionCreateScreen({
    super.key,
    this.placeId,
  });

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

  List<CommunityPlace> _places = [];
  CommunityPlace? _selectedPlace;

  DateTime _startsAt =
      DateTime.now().add(const Duration(days: 1));

  DateTime _endsAt =
      DateTime.now().add(
    const Duration(days: 1, hours: 1),
  );

  bool _isLoadingPlaces = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {

    try {
      final places =
          await _practiceService.getCommunityPlaces();

      if (!mounted) {
        return;
      }

      setState(() {
        _places = places;
        if (widget.placeId != null) {
          for (final place in places) {
            if (place.id == widget.placeId) {
              _selectedPlace = place;
              break;
            }
          }
        } else {
          _selectedPlace = places.isNotEmpty ? places.first : null;
        }
        _isLoadingPlaces = false;
      });
    } catch (error) {
      final strings = AppStrings.of(context);
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingPlaces = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.communityPlaceLoadFailed(error)),
        ),
      );
    }
  }

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

  void _copyPlaceToLocation() {
    final place = _selectedPlace;

    if (place == null) {
      return;
    }

    if (_locationController.text.trim().isEmpty) {
      _locationController.text = place.name;
    }

    if (_locationDetailsController.text.trim().isEmpty) {
      _locationDetailsController.text = place.address;
    }
  }

  Future<void> _saveSession() async {
    final strings = AppStrings.of(context);
    final place = _selectedPlace;

    if (place == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.communityPlaceRequired),
        ),
      );
      return;
    }

    final title = _titleController.text.trim();
    final location = _locationController.text.trim();

    if (title.isEmpty || location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.communitySessionNameLocationRequired),
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
        SnackBar(
          content: Text(strings.communityCapacityInvalid),
        ),
      );
      return;
    }

    if (!_endsAt.isAfter(_startsAt)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.communitySessionEndAfterStart),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final session = await _service.createSession(
        placeId: place.id,
        routineId: null,
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
        SnackBar(
          content: Text(strings.communitySessionAndAgendaCreated),
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
            strings.communitySessionCreateFailed(error),
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
    final strings = AppStrings.of(context);

    if (_isLoadingPlaces) {
      return Scaffold(
        appBar: AppBar(
          title: Text(strings.communityNewSession),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_places.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(strings.communityNewSession),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_city_outlined,
                  size: 56,
                ),
                const SizedBox(height: 16),
                Text(
                  strings.communityPlaceSetupRequired,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  strings.communitySpecificPlaceRequired,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  icon: const Icon(
                    Icons.location_city_outlined,
                  ),
                  label: Text(strings.communityBack),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.communityNewSession),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<CommunityPlace>(
              value: _selectedPlace,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: strings.communityPlace,
                border: OutlineInputBorder(),
              ),
              items: _places
                  .map(
                    (place) =>
                        DropdownMenuItem<CommunityPlace>(
                      value: place,
                      child: Text(
                        place.name,
                        overflow:
                            TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: _isSaving
                  ? null
                  : (value) {
                      setState(() {
                        _selectedPlace = value;
                      });

                      _copyPlaceToLocation();
                    },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              maxLength: 200,
              decoration: InputDecoration(
                labelText: strings.communitySessionName,
                hintText: strings.communitySessionNameHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              maxLength: 2000,
              decoration: InputDecoration(
                labelText: strings.communitySessionDescription,
                hintText: strings.communitySessionDescriptionHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              maxLength: 300,
              decoration: InputDecoration(
                labelText: strings.communitySessionLocation,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationDetailsController,
              maxLines: 3,
              maxLength: 1000,
              decoration: InputDecoration(
                labelText: strings.communityLocationDetails,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading:
                    const Icon(Icons.schedule_outlined),
                title: Text(strings.communityStartTime),
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
                leading:
                    const Icon(Icons.schedule_outlined),
                title: Text(strings.communityEndTime),
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
              keyboardType:
                  TextInputType.number,
              decoration: InputDecoration(
                labelText: strings.communityCapacityOptional,
                hintText: strings.communityCapacityHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.timer_outlined),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        strings.communitySessionAgendaAutoCreated,
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
                        Icons.add_circle_outline,
                      ),
                label: Text(strings.communityCreateSession),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

