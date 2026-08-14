import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/circle_service.dart';
import '../widgets/circle_guide_dialog.dart';

class CreateCircleScreen extends StatefulWidget {
  const CreateCircleScreen({super.key});

  @override
  State<CreateCircleScreen> createState() => _CreateCircleScreenState();
}

class _CreateCircleScreenState extends State<CreateCircleScreen> {
  final AuthService _auth = AuthService();
  final CircleService _circleService = CircleService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedType = 'family';
  bool _isLoading = false;
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  void _checkUser() {
    final userId = _auth.userId;
    setState(() {
      _isGuest = userId == 'guest_123';
      if (_isGuest) _selectedType = 'family';
    });
  }

  Future<void> _createCircle() async {
    if (_isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ গেস্ট মোডে সার্কেল তৈরি করা যায় না!'), backgroundColor: Colors.orange),
      );
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ দয়া করে একটি নাম দিন'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _circleService.createCircle(
        _nameController.text.trim(),
        _descController.text.trim(),
        _auth.userId,
        centerType: _selectedType,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ সার্কেল তৈরি হয়েছে!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏗️ নতুন সার্কেল তৈরি'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isGuest) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'অতিথি মোডে সার্কেল তৈরি করা যায় না। লগইন করুন।',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '🏷️ সার্কেলের নাম *',
                border: OutlineInputBorder(),
              ),
              enabled: !_isGuest,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: '📝 বিবরণ (ঐচ্ছিক)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              enabled: !_isGuest,
            ),
            const SizedBox(height: 16),

            // সার্কেল টাইপ সিলেক্ট
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedType,
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(
                            value: 'family',
                            child: Text('🏠 পারিবারিক'),
                          ),
                          if (!_isGuest)
                            const DropdownMenuItem(
                              value: 'social',
                              child: Text('🤝 সামাজিক'),
                            ),
                          if (!_isGuest)
                            const DropdownMenuItem(
                              value: 'universal',
                              child: Text('🌍 সার্বিক'),
                            ),
                        ],
                        onChanged: (val) => setState(() {
                          if (val != null) _selectedType = val;
                        }),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline, color: Color(0xFFFF6B00)),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CircleGuideDialog(type: _selectedType),
                    );
                  },
                  tooltip: 'সার্কেল গাইড',
                ),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getTypeHint(_selectedType),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isGuest ? null : _createCircle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isGuest ? Colors.grey : const Color(0xFFFF6B00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
                    : Text(
                        _isGuest ? '🔒 লগইন করুন' : '✅ সার্কেল তৈরি করুন',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeHint(String type) {
    switch (type) {
      case 'family':
        return '🏠 পরিবার ও আত্মীয়দের জন্য। শুধু ইনভাইটের মাধ্যমে যোগ দিন। (সর্বোচ্চ ১টি)';
      case 'social':
        return '🤝 বন্ধু ও প্রতিবেশীদের জন্য। জিপিএস ভেরিফাই + ৩ সদস্য প্রয়োজন।';
      case 'universal':
        return '🌍 সবার জন্য উন্মুক্ত। ২টি সামাজিক সার্কেলের অনুমোদন + ৬টি ভোট প্রয়োজন।';
      default:
        return '';
    }
  }
}
