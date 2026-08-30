import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/community_session.dart';
import '../services/community_service.dart';

class CommunitySessionQrScreen extends StatefulWidget {
  final CommunitySession session;

  const CommunitySessionQrScreen({
    required this.session,
    super.key,
  });

  @override
  State<CommunitySessionQrScreen> createState() =>
      _CommunitySessionQrScreenState();
}

class _CommunitySessionQrScreenState
    extends State<CommunitySessionQrScreen> {
  final CommunityService _service = CommunityService();

  String? _token;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateToken();
  }

  Future<void> _generateToken() async {
    try {
      final token =
          await _service.createCheckinToken(widget.session.id);

      if (!mounted) {
        return;
      }

      setState(() {
        _token = token;
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
            'Check-in QR তৈরি করা যায়নি: $error',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in QR'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _token == null
              ? const Center(
                  child: Text('QR তৈরি করা যায়নি।'),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        widget.session.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'অংশগ্রহণকারীরা এই QR scan করে attendance check-in করবে।',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: QrImageView(
                            data: _token!,
                            size: 280,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Check-in session-এর নির্ধারিত সময়ের ১৫ মিনিট আগে থেকে ১৫ মিনিট পরে পর্যন্ত চালু থাকবে।',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
    );
  }
}
