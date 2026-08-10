import 'package:flutter/material.dart';
import 'dart:html' as html;
import '../generated/l10n/app_localizations.dart';

class NetworkStatusWidget extends StatefulWidget {
  const NetworkStatusWidget({super.key});

  @override
  State<NetworkStatusWidget> createState() => _NetworkStatusWidgetState();
}

class _NetworkStatusWidgetState extends State<NetworkStatusWidget> {
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkStatus();
    html.window.onOnline.listen((e) => setState(() => _isOnline = true));
    html.window.onOffline.listen((e) => setState(() => _isOnline = false));
  }

  void _checkStatus() {
    setState(() {
      _isOnline = html.window.navigator.onLine ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      color: _isOnline ? Colors.green[700] : Colors.red[700],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isOnline ? Icons.wifi : Icons.wifi_off,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            _isOnline
                ? '🟢 ${local.online} - ${local.startQuiz}'
                : '🔴 ${local.offline} - ${local.startQuiz}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
