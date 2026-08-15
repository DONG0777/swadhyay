import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/profile_service.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final ProfileService _profileService = ProfileService();
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _areaController = TextEditingController();
  String? _selectedBloodGroup;
  bool _isLoading = true;
  bool _isSaving = false;
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) { setState(() => _isLoading = false); return; }
    final profile = await _profileService.getProfile(userId);
    if (profile != null) {
      _phoneController.text = profile.phone ?? '';
      _areaController.text = profile.area ?? '';
      _selectedBloodGroup = profile.bloodGroup;
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('আপনি লগইন করেননি!'), backgroundColor: Colors.red),
      );
      setState(() => _isSaving = false);
      return;
    }
    final success = await _profileService.updateProfile(
      userId: userId,
      phone: _phoneController.text.trim(),
      area: _areaController.text.trim(),
      bloodGroup: _selectedBloodGroup,
    );
    setState(() => _isSaving = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ প্রোফাইল আপডেট হয়েছে!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ প্রোফাইল আপডেট ব্যর্থ হয়েছে!'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('প্রোফাইল আপডেট'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'আপনার প্রোফাইল তথ্য পূরণ করুন। '
                              'এগুলো আপনার সার্কেল ও কমিউনিটিতে দেখাবে।',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: '📱 ফোন নম্বর',
                        border: OutlineInputBorder(),
                        prefixText: '+88 ',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (v) => v == null || v.isEmpty ? 'ফোন নম্বর দিন' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _areaController,
                      decoration: const InputDecoration(
                        labelText: '📍 এলাকা',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'এলাকা দিন' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedBloodGroup,
                      decoration: const InputDecoration(
                        labelText: '🩸 ব্লাড গ্রুপ',
                        border: OutlineInputBorder(),
                      ),
                      items: _bloodGroups.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (v) => setState(() => _selectedBloodGroup = v),
                      validator: (v) => v == null ? 'ব্লাড গ্রুপ নির্বাচন করুন' : null,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isSaving
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('💾 সংরক্ষণ করুন', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
