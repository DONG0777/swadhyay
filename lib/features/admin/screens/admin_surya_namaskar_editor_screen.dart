import 'package:flutter/material.dart';

import '../../surya_namaskar/models/surya_namaskar_content.dart';
import '../services/admin_surya_namaskar_service.dart';

class AdminSuryaNamaskarEditorScreen extends StatefulWidget {
  final SuryaNamaskarContent step;

  const AdminSuryaNamaskarEditorScreen({
    super.key,
    required this.step,
  });

  @override
  State<AdminSuryaNamaskarEditorScreen> createState() =>
      _AdminSuryaNamaskarEditorScreenState();
}

class _AdminSuryaNamaskarEditorScreenState
    extends State<AdminSuryaNamaskarEditorScreen> {
  final AdminSuryaNamaskarService _service =
      AdminSuryaNamaskarService();

  late final TextEditingController _titleController;
  late final TextEditingController _mantraController;
  late final TextEditingController _meaningController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _instructionsController;
  late final TextEditingController _benefitsController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.step.title);
    _mantraController = TextEditingController(text: widget.step.mantra ?? '');
    _meaningController =
        TextEditingController(text: widget.step.mantraMeaning ?? '');
    _descriptionController =
        TextEditingController(text: widget.step.description ?? '');
    _instructionsController =
        TextEditingController(text: widget.step.instructions ?? '');
    _benefitsController =
        TextEditingController(text: widget.step.benefits ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _mantraController.dispose();
    _meaningController.dispose();
    _descriptionController.dispose();
    _instructionsController.dispose();
    _benefitsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      _showMessage('Title is required.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _service.updateBengaliContent(
        suryaNamaskarId: widget.step.id,
        title: title,
        mantra: _nullable(_mantraController.text),
        mantraMeaning: _nullable(_meaningController.text),
        description: _nullable(_descriptionController.text),
        instructions: _nullable(_instructionsController.text),
        benefits: _nullable(_benefitsController.text),
      );

      if (!mounted) return;

      _showMessage('Content saved successfully.');
      Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        _showMessage('Could not save content.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String? _nullable(String value) {
    final text = value.trim();
    return text.isEmpty ? null : text;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        enabled: !_isSaving,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${widget.step.stepNumber} Editor'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _field(
                label: 'Title',
                controller: _titleController,
              ),
              _field(
                label: 'Mantra',
                controller: _mantraController,
              ),
              _field(
                label: 'Meaning',
                controller: _meaningController,
                maxLines: 3,
              ),
              _field(
                label: 'Description',
                controller: _descriptionController,
                maxLines: 4,
              ),
              _field(
                label: 'Instructions',
                controller: _instructionsController,
                maxLines: 5,
              ),
              _field(
                label: 'Benefits',
                controller: _benefitsController,
                maxLines: 4,
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
