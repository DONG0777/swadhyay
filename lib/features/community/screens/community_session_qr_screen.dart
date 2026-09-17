import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/localization/app_strings.dart';
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
    _createToken();
  }

  Future<void> _createToken() async {
    try {
      final token = await _service.createCheckinToken(widget.session.id);

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
            AppStrings.of(context).communitySessionCheckinQrCreateFailed(
              error,
            ),
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
          AppStrings.of(context).communitySessionCheckinQrTitle,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _token == null
              ? Center(
                  child: Text(
                    AppStrings.of(context)
                        .communitySessionCheckinQrUnavailable,
                  ),
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
                      Text(
                        AppStrings.of(context)
                            .communitySessionCheckinQrInstruction,
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
                      Text(
                        AppStrings.of(context)
                            .communitySessionCheckinQrTimeWindow,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
    );
  }
}