import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../models/question_model.dart';
import '../generated/l10n/app_localizations.dart';
import 'admin_content_manager_screen.dart';

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
        _error = '${AppLocalizations.of(context).welcome}: $e';
        _isLoading = false;
      });
    }
  }

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
            title: Text(isEdit ? 'Edit Question' : 'Add Question'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: textController,
                      decoration: const InputDecoration(labelText: 'Question', border: OutlineInputBorder()),
                      validator: (v) => v?.isEmpty ?? true ? 'Please enter question' : null,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: aController,
                      decoration: const InputDecoration(labelText: 'Option A', border: OutlineInputBorder()),
                      validator: (v) => v?.isEmpty ?? true ? 'Enter option A' : null,
                    ),
                    TextFormField(
                      controller: bController,
                      decoration: const InputDecoration(labelText: 'Option B', border: OutlineInputBorder()),
                      validator: (v) => v?.isEmpty ?? true ? 'Enter option B' : null,
                    ),
                    TextFormField(
                      controller: cController,
                      decoration: const InputDecoration(labelText: 'Option C', border: OutlineInputBorder()),
                      validator: (v) => v?.isEmpty ?? true ? 'Enter option C' : null,
                    ),
                    TextFormField(
                      controller: dController,
                      decoration: const InputDecoration(labelText: 'Option D', border: OutlineInputBorder()),
                      validator: (v) => v?.isEmpty ?? true ? 'Enter option D' : null,
                    ),
                    TextFormField(
                      controller: correctController,
                      decoration: const InputDecoration(labelText: 'Correct (A/B/C/D)', border: OutlineInputBorder()),
                      validator: (v) {
                        if (v?.isEmpty ?? true) return 'Enter correct option';
                        if (!['A', 'B', 'C', 'D'].contains(v?.toUpperCase())) {
                          return 'Only A, B, C, D allowed';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: explainController,
                      decoration: const InputDecoration(labelText: 'Explanation (optional)', border: OutlineInputBorder()),
                      maxLines: 3,
                    ),
                    TextFormField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Category (optional)', border: OutlineInputBorder()),
                    ),
                    SwitchListTile(
                      title: const Text('Active'),
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
                child: const Text('Cancel'),
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
                child: Text(isEdit ? 'Update' : 'Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showBulkUploadDialog() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Questions from JSON'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Paste a JSON array:'),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              maxLines: 10,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '''[
  {
    "question_text": "Question",
    "option_a": "A",
    "option_b": "B",
    "option_c": "C",
    "option_d": "D",
    "correct_option": "A",
    "explanation": "Explanation",
    "category": "Category"
  }
]''',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
                    content: Text('✅ $count questions uploaded!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('❌ JSON parse error: $e'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('⚙️ ${local.admin}'),
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
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _showAddEditDialog(),
                              icon: const Icon(Icons.add),
                              label: Text(local.startQuiz),
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
                              label: const Text('JSON Upload'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // 🔥 নতুন কন্টেন্ট ম্যানেজার বাটন
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AdminContentManagerScreen()),
                                );
                              },
                              icon: const Icon(Icons.library_books),
                              label: const Text('কন্টেন্ট ম্যানেজার'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _questions.isEmpty
                          ? const Center(child: Text('No questions'))
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
                                      '${q.category ?? 'No category'} • ${q.correctOption}',
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
                                                title: const Text('Delete?'),
                                                content: Text('Delete "${q.questionText}"?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, false),
                                                    child: const Text('No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, true),
                                                    child: const Text('Yes', style: TextStyle(color: Colors.red)),
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
