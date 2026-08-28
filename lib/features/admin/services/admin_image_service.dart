import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class AdminImageService {
  final SupabaseClient _client;

  AdminImageService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<String> uploadSuryaNamaskarImage({
    required String stepId,
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = fileExtension.toLowerCase();

    final path = 'steps/${stepId}_$timestamp.$extension';

    final storage = _client.storage.from('surya-namaskar');

    await storage.uploadBinary(
      path,
      bytes,
      fileOptions: FileOptions(
        upsert: false,
        contentType: _contentType(extension),
      ),
    );

    return storage.getPublicUrl(path);
  }

  String _contentType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }
}
