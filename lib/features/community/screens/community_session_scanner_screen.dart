import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../services/community_service.dart';

class CommunitySessionScannerScreen extends StatefulWidget {
  const CommunitySessionScannerScreen({super.key});

  @override
  State<CommunitySessionScannerScreen> createState() =>
      _CommunitySessionScannerScreenState();
}

class _CommunitySessionScannerScreenState
    extends State<CommunitySessionScannerScreen> {
  final MobileScannerController _controller =
      MobileScannerController();

  final CommunityService _service = CommunityService();

  bool _isCheckingIn = false;
  bool _checkInComplete = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkIn(String token) async {
    if (_isCheckingIn || _checkInComplete) {
      return;
    }

    setState(() {
      _isCheckingIn = true;
    });

    try {
      await _service.checkInWithToken(token);

      if (!mounted) {
        return;
      }

      setState(() {
        _isCheckingIn = false;
        _checkInComplete = true;
      });

      await _controller.stop();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('উপস্থিতি সফলভাবে নথিভুক্ত হয়েছে।'),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isCheckingIn = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Check-in করা যায়নি: $error',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scan করে উপস্থিতি'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (capture.barcodes.isEmpty) {
                return;
              }

              final value = capture.barcodes.first.rawValue;

              if (value == null || value.isEmpty) {
                return;
              }

              _checkIn(value);
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          if (_isCheckingIn)
            const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          if (_checkInComplete)
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'উপস্থিতি সফলভাবে নথিভুক্ত হয়েছে।',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
