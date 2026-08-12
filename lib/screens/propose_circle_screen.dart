import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/location_service.dart';
import '../generated/l10n/app_localizations.dart';

class ProposeCircleScreen extends StatefulWidget {
  const ProposeCircleScreen({super.key});

  @override
  State<ProposeCircleScreen> createState() => _ProposeCircleScreenState();
}

class _ProposeCircleScreenState extends State<ProposeCircleScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  
  bool _isGpsVerified = false;
  bool _isLoading = false;
  String? _gpsError;
  double? _verifiedLat;
  double? _verifiedLng;

  Future<void> _verifyGPS() async {
    setState(() {
      _isLoading = true;
      _gpsError = null;
    });
    try {
      final lat = double.parse(_latController.text.trim());
      final lng = double.parse(_lngController.text.trim());
      await LocationService.verifyLocation(targetLat: lat, targetLon: lng);
      setState(() {
        _isGpsVerified = true;
        _verifiedLat = lat;
        _verifiedLng = lng;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ GPS ভেরিফাই সফল!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      setState(() {
        _gpsError = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _submitProposal() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ নাম দিন'), backgroundColor: Colors.orange),
      );
      return;
    }
    if (!_isGpsVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ প্রথমে GPS ভেরিফাই করুন'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      await supabase.from('community_centers').insert({
        'name': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'center_type': 'universal',
        'created_by': _auth.userId,
        'members': [_auth.userId],
        'leaderboard': {_auth.userId: 0},
        'invite_code': _generateInviteCode(),
        'status': 'pending',
        'proposed_location': _addressController.text.trim(),
        'proposed_latitude': _verifiedLat,
        'proposed_longitude': _verifiedLng,
        'proposed_radius': 100,
        'vote_count': 0,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ প্রস্তাব জমা হয়েছে! ভোটিং শুরু হবে।'), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String code = '';
    for (int i = 0; i < 6; i++) {
      code += chars[random % chars.length];
    }
    return code;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌍 সার্বিক সার্কেল প্রস্তাব'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'সার্বিক সার্কেল তৈরি করতে GPS ভেরিফিকেশন ও ভোটিং প্রয়োজন।',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '🏷️ সার্কেলের নাম *', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: '📝 বিবরণ', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: '📍 ঠিকানা *', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _latController,
                    decoration: const InputDecoration(labelText: 'ল্যাটিটিউড *', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _lngController,
                    decoration: const InputDecoration(labelText: 'লংগিটিউড *', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // GPS ভেরিফাই বাটন
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isGpsVerified ? Colors.green[50] : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _isGpsVerified ? Colors.green : Colors.grey),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _isGpsVerified ? Icons.check_circle : Icons.location_on,
                        color: _isGpsVerified ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isGpsVerified ? '✅ GPS ভেরিফাই করা হয়েছে' : '📍 এই লোকেশনে গিয়ে ভেরিফাই করুন',
                        style: TextStyle(color: _isGpsVerified ? Colors.green : Colors.grey),
                      ),
                    ],
                  ),
                  if (_gpsError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(_gpsError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _verifyGPS,
                      icon: const Icon(Icons.gps_fixed),
                      label: Text(_isGpsVerified ? 'পুনরায় ভেরিফাই করুন' : '📍 GPS ভেরিফাই করুন'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isGpsVerified ? Colors.green : const Color(0xFFFF6B00),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitProposal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('📤 প্রস্তাব জমা দিন', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
