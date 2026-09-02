import 'package:flutter/material.dart';

import '../../../core/localization/app_strings.dart';
import '../models/user_context.dart';
import '../services/user_context_service.dart';

class UserContextScreen extends StatefulWidget {
  const UserContextScreen({super.key});

  @override
  State<UserContextScreen> createState() => _UserContextScreenState();
}

class _UserContextScreenState extends State<UserContextScreen> {
  final UserContextService _service = UserContextService();

  final TextEditingController _situationController =
      TextEditingController();
  final TextEditingController _needController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  UserContext? _context;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadContext();
  }

  @override
  void dispose() {
    _situationController.dispose();
    _needController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _loadContext() async {
    try {
      final contextData = await _service.getCurrentContext();

      if (!mounted) {
        return;
      }

      setState(() {
        _context = contextData;
        _situationController.text = contextData?.currentSituation ?? '';
        _needController.text = contextData?.biggestNeed ?? '';
        _timeController.text =
            contextData?.availableTimeMinutes?.toString() ?? '';
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      final strings = AppStrings.of(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.contextLoadFailed(error)),
        ),
      );
    }
  }

  Future<void> _saveContext() async {
    final strings = AppStrings.of(context);
    final availableTimeText = _timeController.text.trim();

    int? availableTimeMinutes;

    if (availableTimeText.isNotEmpty) {
      availableTimeMinutes = int.tryParse(availableTimeText);

      if (availableTimeMinutes == null ||
          availableTimeMinutes < 0 ||
          availableTimeMinutes > 1440) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(strings.timeValidationError),
          ),
        );
        return;
      }
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final savedContext = await _service.saveContext(
        currentSituation: _situationController.text.trim().isEmpty
            ? null
            : _situationController.text.trim(),
        biggestNeed: _needController.text.trim().isEmpty
            ? null
            : _needController.text.trim(),
        availableTimeMinutes: availableTimeMinutes,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _context = savedContext;
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.contextSavedSuccessfully),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.contextSaveFailed(error)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.myContext),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.whereAreYouNow,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.describeCurrentLife,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: _situationController,
                      maxLines: 5,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        labelText: strings.currentSituation,
                        hintText: strings.writeInYourOwnWords,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _needController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: strings.biggestNeed,
                        hintText: strings.biggestNeedHint,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _timeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: strings.availableTimePerDay,
                        hintText: strings.minutesExample,
                        suffixText: strings.minutes,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isSaving ? null : _saveContext,
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _context == null
                                    ? strings.save
                                    : strings.saveChanges,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
