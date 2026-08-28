import 'package:flutter/material.dart';

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Context load failed: $error'),
        ),
      );
    }
  }

  Future<void> _saveContext() async {
    final availableTimeText = _timeController.text.trim();

    int? availableTimeMinutes;

    if (availableTimeText.isNotEmpty) {
      availableTimeMinutes = int.tryParse(availableTimeText);

      if (availableTimeMinutes == null ||
          availableTimeMinutes < 0 ||
          availableTimeMinutes > 1440) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('সময় ০ থেকে ১৪৪০ মিনিটের মধ্যে দিন।'),
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
        const SnackBar(
          content: Text('আপনার তথ্য সংরক্ষিত হয়েছে।'),
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
          content: Text('Save failed: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('আমার অবস্থান'),
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
                      'তুমি এখন কোথায় আছ?',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'তোমার বর্তমান জীবন ও প্রয়োজনকে নিজের ভাষায় বোঝাও।',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: _situationController,
                      maxLines: 5,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        labelText: 'বর্তমানে তোমার জীবনে কী চলছে?',
                        hintText: 'নিজের ভাষায় লিখো...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _needController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'তোমার জীবনের সবচেয়ে বড় প্রয়োজন কী?',
                        hintText: 'যেমন: নিয়মিত হতে চাই, মনকে স্থির করতে চাই...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _timeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'প্রতিদিন কত মিনিট দিতে পারবে?',
                        hintText: 'যেমন: 20',
                        suffixText: 'মিনিট',
                        border: OutlineInputBorder(),
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
                                    ? 'সংরক্ষণ করুন'
                                    : 'পরিবর্তন সংরক্ষণ করুন',
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
