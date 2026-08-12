import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../generated/l10n/app_localizations.dart';

class AdminNotificationScreen extends StatefulWidget {
  final String adminId;
  final String circleId;
  const AdminNotificationScreen({
    super.key,
    required this.adminId,
    required this.circleId,
  });

  @override
  State<AdminNotificationScreen> createState() => _AdminNotificationScreenState();
}

class _AdminNotificationScreenState extends State<AdminNotificationScreen> {
  final NotificationService _service = NotificationService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  bool _isSending = false;
  String _selectedType = 'announcement';

  Future<void> _sendNotification() async {
    if (_titleController.text.trim().isEmpty || _bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ টাইটেল ও বার্তা দিন'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isSending = true);
    try {
      await _service.sendToCircle(
        circleId: widget.circleId,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        type: _selectedType,
        senderId: widget.adminId,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ নোটিফিকেশন পাঠানো হয়েছে!'), backgroundColor: Colors.green),
      );
      _titleController.clear();
      _bodyController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📨 নোটিফিকেশন পাঠান'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'টাইপ', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'announcement', child: Text('📢 ঘোষণা')),
                DropdownMenuItem(value: 'reminder', child: Text('⏰ রিমাইন্ডার')),
                DropdownMenuItem(value: 'personal', child: Text('🎯 ব্যক্তিগত')),
              ],
              onChanged: (val) => setState(() => _selectedType = val!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'টাইটেল *', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'বার্তা *', border: OutlineInputBorder()),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendNotification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSending
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('📤 পাঠান', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
