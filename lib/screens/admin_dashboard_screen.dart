import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../models/question_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminService _service = AdminService();
  List<Question> _questions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await _service.getAllQuestions();
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'প্রশ্ন লোড করতে সমস্যা: $e';
        _isLoading = false;
      });
    }
  }

  // নতুন প্রশ্ন যোগ করার ডায়ালগ
  Future<void> _showAddEditDialog({Question? question}) async {
    final isEdit = question != null;
    final formKey = GlobalKey<FormState>();
    final textController = TextEditingController(text: question?.questionText ?? '');
    final aController = TextEditingController(text: question?.optionA ?? '');
    final bController = TextEditingController(text: question?.optionB ?? '');
    final cController = TextEditingController(text: question?.optionC ?? '');
    final dController = TextEditingController(text: question?.optionD ?? '');
    final correctController = TextEditingController(text: question?.correctOption ?? '');
    final explainController = TextEditingController(text: question?.explanation ?? '');
    final categoryController = TextEditingController(text: question?.category ?? '');
    bool isActive = question?.isActive ?? true;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(isEdit ? 'প্রশ্ন সম্পাদনা করুন' : 'নতুন প্রশ্ন যোগ করুন'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: textController,
                      decoration: const InputDecoration(labelText: 'প্রশ্ন', border: OutlineInputBorder()),
                      validator: (v) => v?.isEmpty ?? true ? 'প্রশ্ন দিন' : null,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: aController,
                      decoration: const InputDecoration(labelText: 'A বিকল্প', border: OutlineInputBorder()),
                      validator: (v) => v?.isEmpty ?? true ? 'A বিকল্প দিন' : null,
                    ),
                    TextFormField(
                      controller: bController,
                      decoration: const InputDecoration(labelText: 'B বিকল্প', border: OutlineInputBorder()),
                      validator: (v) => v?.isEmpty ?? true ? 'B বিকল্প দিন' : null,
                    ),
                    TextFormField(
                      controller: cController,
                      decoration: const InputDecoration(labelText: 'C বিকল্প', border: OutlineInputBorder()),
                      validator: (v) => v?.isEmpty ?? true ? 'C বিকল্প দিন' : null,
                    ),
                    TextFormField(
                      controller: dController,
                      decoration: const InputDecoration(labelText: 'D বিকল্প', border: OutlineInputBorder()),
                      validator: (v) => v?.isEmpty ?? true ? 'D বিকল্প দিন' : null,
                    ),
                    TextFormField(
                      controller: correctController,
                      decoration: const InputDecoration(labelText: 'সঠিক উত্তর (A/B/C/D)', border: OutlineInputBorder()),
                      validator: (v) {
                        if (v?.isEmpty ?? true) return 'সঠিক উত্তর দিন';
                        if (!['A', 'B', 'C', 'D'].contains(v?.toUpperCase())) {
                          return 'শুধু A, B, C, D লিখুন';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: explainController,
                      decoration: const InputDecoration(labelText: 'ব্যাখ্যা (ঐচ্ছিক)', border: OutlineInputBorder()),
                      maxLines: 3,
                    ),
                    TextFormField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'ক্যাটাগরি (ঐচ্ছিক)', border: OutlineInputBorder()),
                    ),
                    SwitchListTile(
                      title: const Text('সক্রিয়'),
                      value: isActive,
                      onChanged: (val) => setStateDialog(() => isActive = val),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('বাতিল'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final questionData = Question(
                      id: question?.id,
                      questionText: textController.text.trim(),
                      optionA: aController.text.trim(),
                      optionB: bController.text.trim(),
                      optionC: cController.text.trim(),
                      optionD: dController.text.trim(),
                      correctOption: correctController.text.trim().toUpperCase(),
                      explanation: explainController.text.trim(),
                      category: categoryController.text.trim(),
                      isActive: isActive,
                    );

                    try {
                      if (isEdit) {
                        await _service.updateQuestion(question!.id!, questionData);
                      } else {
                        await _service.addQuestion(questionData);
                      }
                      Navigator.pop(context);
                      _loadQuestions();
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
          );
        },
      ),
    );
  }

  // JSON আপলোড ডায়ালগ
  Future<void> _showBulkUploadDialog() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('JSON থেকে প্রশ্ন আপলোড করুন'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('একটি JSON অ্যারে পেস্ট করুন:'),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              maxLines: 10,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: '''[
  {
    "question_text": "প্রশ্ন",
    "option_a": "A",
    "option_b": "B",
    "option_c": "C",
    "option_d": "D",
    "correct_option": "A",
    "explanation": "ব্যাখ্যা",
    "category": "ক্যাটাগরি"
  }
]''',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final List<dynamic> jsonData = jsonDecode(controller.text);
                final count = await _service.bulkUpload(
                  jsonData.map((e) => e as Map<String, dynamic>).toList(),
                );
                Navigator.pop(context);
                _loadQuestions();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ $count টি প্রশ্ন আপলোড হয়েছে!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('❌ JSON পার্স করতে সমস্যা: $e'), backgroundColor: Colors.red),
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
        title: const Text('⚙️ অ্যাডমিন প্যানেল'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadQuestions,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : Column(
                  children: [
                    // অ্যাকশন বাটন
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _showAddEditDialog(),
                              icon: const Icon(Icons.add),
                              label: const Text('নতুন প্রশ্ন'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _showBulkUploadDialog,
                              icon: const Icon(Icons.upload_file),
                              label: const Text('JSON আপলোড'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // প্রশ্ন তালিকা
                    Expanded(
                      child: _questions.isEmpty
                          ? const Center(child: Text('কোনো প্রশ্ন নেই'))
                          : ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: _questions.length,
                              itemBuilder: (context, index) {
                                final q = _questions[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: q.isActive ? Colors.green : Colors.red,
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    title: Text(
                                      q.questionText,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      '${q.category ?? 'ক্যাটাগরি নেই'} • ${q.correctOption}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () => _showAddEditDialog(question: q),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('ডিলিট করুন?'),
                                                content: Text('"${q.questionText}" ডিলিট করবেন?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, false),
                                                    child: const Text('না'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, true),
                                                    child: const Text('হ্যাঁ', style: TextStyle(color: Colors.red)),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (confirm ?? false) {
                                              await _service.deleteQuestion(q.id!);
                                              _loadQuestions();
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
