import 'package:flutter/material.dart';
import '../services/circle_service.dart';

class CircleCreateScreen extends StatefulWidget {
  const CircleCreateScreen({super.key});

  @override
  State<CircleCreateScreen> createState() => _CircleCreateScreenState();
}

class _CircleCreateScreenState extends State<CircleCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _createCircle() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: বাস্তব ইউজার আইডি ব্যবহার করুন (এখনো অথেনটিকেশন নেই)
      final userId = 'user_123';
      final service = CircleService();
      final circle = await service.createCircle(
        _nameController.text.trim(),
        _descController.text.trim(),
        userId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ "${circle.name}" সার্কেল তৈরি হয়েছে!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, circle);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ সার্কেল তৈরি করতে সমস্যা: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('✨ নতুন সার্কেল'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.group, size: 60, color: Color(0xFFFF6B00)),
              const SizedBox(height: 16),
              const Text(
                'একটি নতুন সার্কেল তৈরি করুন',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'সার্কেলের নাম',
                  hintText: 'যেমন: মুক্তিযোদ্ধারা',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.group),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'দয়া করে সার্কেলের নাম দিন';
                  }
                  if (value.trim().length < 3) {
                    return 'নাম কমপক্ষে ৩ অক্ষরের হতে হবে';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'বিবরণ (ঐচ্ছিক)',
                  hintText: 'এই সার্কেলের উদ্দেশ্য কী?',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _createCircle,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFFFF6B00),
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'সার্কেল তৈরি করুন',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
