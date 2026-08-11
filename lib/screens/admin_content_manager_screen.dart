import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/content_service.dart';
import '../models/content_model.dart';

class AdminContentManagerScreen extends StatefulWidget {
  const AdminContentManagerScreen({super.key});

  @override
  State<AdminContentManagerScreen> createState() => _AdminContentManagerScreenState();
}

class _AdminContentManagerScreenState extends State<AdminContentManagerScreen> {
  final ContentService _service = ContentService();
  List<ContentModel> _contents = [];
  String _selectedType = 'all';
  bool _isLoading = true;

  // 🔥 শুধু এই ৫টি টাইপ দেখাবে (সূর্যনমস্কার বাদ)
  final List<String> _contentTypes = ['all', 'stotra', 'shloka', 'quote', 'book', 'duty'];

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  Future<void> _loadContents() async {
    setState(() => _isLoading = true);
    try {
      final data = await _service.getContents(contentType: _selectedType);
      // 🔥 সূর্যনমস্কার ফিল্টার করে বাদ দিন
      final filtered = data.where((item) => item.contentType != 'surya').toList();
      setState(() {
        _contents = filtered;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error loading content: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _showAddEditDialog({ContentModel? existing}) async {
    final isEdit = existing != null;
    final formKey = GlobalKey<FormState>();
    
    // 🔥 ড্রপডাউনে শুধু ৫টি টাইপ থাকবে
    final typeController = TextEditingController(text: existing?.contentType ?? 'shloka');
    final titleController = TextEditingController(text: existing?.title ?? '');
    final contentController = TextEditingController(text: existing?.content ?? '');
    final explainController = TextEditingController(text: existing?.explanation ?? '');
    final langController = TextEditingController(text: existing?.languageCode ?? 'bn');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? '✏️ কন্টেন্ট সম্পাদনা করুন' : '➕ নতুন কন্টেন্ট যোগ করুন'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: typeController.text,
                  decoration: const InputDecoration(labelText: 'টাইপ *'),
                  items: ['shloka', 'quote', 'book', 'stotra', 'duty']
                      .map((e) => DropdownMenuItem(value: e, child: Text(_getTypeLabel(e))))
                      .toList(),
                  onChanged: (val) => typeController.text = val!,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'শিরোনাম'),
                ),
                TextFormField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: 'মূল কন্টেন্ট *'),
                  maxLines: 4,
                  validator: (v) => v?.isEmpty ?? true ? 'কন্টেন্ট দিন' : null,
                ),
                TextFormField(
                  controller: explainController,
                  decoration: const InputDecoration(labelText: 'ব্যাখ্যা/অর্থ (ঐচ্ছিক)'),
                  maxLines: 3,
                ),
                DropdownButtonFormField<String>(
                  value: langController.text,
                  decoration: const InputDecoration(labelText: 'ভাষা'),
                  items: ['bn', 'hi', 'en']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => langController.text = val!,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final content = ContentModel(
                  id: existing?.id,
                  contentType: typeController.text,
                  title: titleController.text,
                  content: contentController.text,
                  explanation: explainController.text,
                  languageCode: langController.text,
                );
                try {
                  if (isEdit) {
                    await _service.updateContent(existing!.id!, content);
                  } else {
                    await _service.addContent(content);
                  }
                  Navigator.pop(context);
                  _loadContents();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('❌ $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: Text(isEdit ? 'আপডেট করুন' : 'যোগ করুন'),
          ),
        ],
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'shloka': return '📜 শ্লোক';
      case 'quote': return '💬 উক্তি';
      case 'book': return '📚 বই';
      case 'stotra': return '🕉️ একাত্মতা স্তোত্র';
      case 'duty': return '🇮🇳 নাগরিক কর্তব্য';
      default: return type;
    }
  }

  Future<void> _showBulkUploadDialog() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📤 JSON বাল্ক আপলোড'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('নিচে JSON অ্যারে পেস্ট করুন:'),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '[{"content_type":"shloka", "title":"...", "content":"..."}]',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
          ElevatedButton(
            onPressed: () async {
              try {
                final List<dynamic> data = jsonDecode(controller.text);
                final count = await _service.bulkUpload(data.map((e) => e as Map<String, dynamic>).toList());
                Navigator.pop(context);
                _loadContents();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ $count টি কন্টেন্ট আপলোড হয়েছে!'), backgroundColor: Colors.green),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('❌ JSON Error: $e'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('আপলোড করুন'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 কন্টেন্ট ম্যানেজার'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _showBulkUploadDialog,
            tooltip: 'Bulk Upload',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadContents,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('ফিল্টার: '),
                DropdownButton<String>(
                  value: _selectedType,
                  items: _contentTypes
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e == 'all' ? 'সব' : _getTypeLabel(e)),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() => _selectedType = val!);
                    _loadContents();
                  },
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAddEditDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('নতুন'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _contents.isEmpty
                    ? const Center(child: Text('কোনো কন্টেন্ট নেই'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _contents.length,
                        itemBuilder: (context, index) {
                          final item = _contents[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(_getTypeLabel(item.contentType)[0]),
                              ),
                              title: Text(item.title ?? item.contentType),
                              subtitle: Text(
                                item.content != null && item.content!.length > 50
                                    ? '${item.content!.substring(0, 50)}...'
                                    : item.content ?? '',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _showAddEditDialog(existing: item),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('ডিলিট করুন?'),
                                          content: Text('"${item.title}" ডিলিট করবেন?'),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('না')),
                                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('হ্যাঁ', style: TextStyle(color: Colors.red))),
                                          ],
                                        ),
                                      );
                                      if (confirm ?? false) {
                                        await _service.deleteContent(item.id!);
                                        _loadContents();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
