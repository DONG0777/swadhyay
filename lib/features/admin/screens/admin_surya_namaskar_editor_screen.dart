import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../surya_namaskar/models/surya_namaskar_content.dart';
import '../services/admin_image_service.dart';
import '../services/admin_surya_namaskar_service.dart';

class AdminSuryaNamaskarEditorScreen extends StatefulWidget {
  final SuryaNamaskarContent step;
  final String languageCode;

  const AdminSuryaNamaskarEditorScreen({
    super.key,
    required this.step,
    required this.languageCode,
  });

  @override
  State<AdminSuryaNamaskarEditorScreen> createState() =>
      _AdminSuryaNamaskarEditorScreenState();
}

class _AdminSuryaNamaskarEditorScreenState
    extends State<AdminSuryaNamaskarEditorScreen> {
  final AdminSuryaNamaskarService _service =
      AdminSuryaNamaskarService();

  final AdminImageService _imageService = AdminImageService();

  late final TextEditingController _titleController;
  late final TextEditingController _mantraController;
  late final TextEditingController _meaningController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _instructionsController;
  late final TextEditingController _benefitsController;

  Uint8List? _selectedImageBytes;
  String? _selectedImageExtension;
  String? _selectedImageName;

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

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final file = result.files.single;
    final bytes = file.bytes;

    if (bytes == null || bytes.isEmpty) {
      _showMessage('Could not read the selected image.');
      return;
    }

    const maxSizeBytes = 5 * 1024 * 1024;

    if (bytes.length > maxSizeBytes) {
      _showMessage('Image must be 5 MB or smaller.');
      return;
    }

    final extension = (file.extension ?? '').toLowerCase();

    if (!['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
      _showMessage('Supported formats: JPG, PNG, WebP.');
      return;
    }

    setState(() {
      _selectedImageBytes = bytes;
      _selectedImageExtension = extension;
      _selectedImageName = file.name;
    });
  }

  Future<String?> _uploadSelectedImage() async {
    final bytes = _selectedImageBytes;
    final extension = _selectedImageExtension;

    if (bytes == null || extension == null) {
      return null;
    }

    debugPrint(
      'ADMIN IMAGE UPLOAD: step=${widget.step.stepNumber}, id=${widget.step.id}',
    );

    return _imageService.uploadSuryaNamaskarImage(
      stepId: widget.step.id,
      bytes: bytes,
      fileExtension: extension,
    );
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
      final imageUrl = await _uploadSelectedImage();

      await _service.upsertTranslation(
        suryaNamaskarId: widget.step.id,
        languageCode: widget.languageCode,
        title: title,
        mantra: _nullable(_mantraController.text),
        mantraMeaning: _nullable(_meaningController.text),
        description: _nullable(_descriptionController.text),
        instructions: _nullable(_instructionsController.text),
        benefits: _nullable(_benefitsController.text),
      );

      if (imageUrl != null) {
        await _service.updateImageUrl(
          suryaNamaskarId: widget.step.id,
          imageUrl: imageUrl,
        );
      }

      if (!mounted) return;

      _showMessage('Changes saved successfully.');
      Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        _showMessage('Could not save changes.');
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

  Widget _imageSection(BuildContext context) {
    final imageBytes = _selectedImageBytes;
    final currentImageUrl = widget.step.imageUrl;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Image',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              AspectRatio(
                aspectRatio: 4 / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageBytes != null
                      ? Image.memory(
                          imageBytes,
                          fit: BoxFit.cover,
                        )
                      : currentImageUrl != null &&
                              currentImageUrl.trim().isNotEmpty
                          ? Image.network(
                              currentImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return const Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    size: 48,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.image_outlined,
                                size: 48,
                              ),
                            ),
                ),
              ),
              const SizedBox(height: 12),
              if (_selectedImageName != null) ...[
                Text(
                  _selectedImageName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],
              OutlinedButton.icon(
                onPressed: _isSaving ? null : _pickImage,
                icon: const Icon(Icons.upload_outlined),
                label: Text(
                  imageBytes == null ? 'Choose Image' : 'Replace Image',
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'JPG, PNG or WebP • Maximum 5 MB',
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
              _imageSection(context),
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
