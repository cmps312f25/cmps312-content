import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalimati/core/entities/learning_package.dart';
import 'package:kalimati/core/entities/enum/level_filter.dart';
import 'package:kalimati/core/providers/package_provider.dart';
import 'package:uuid/uuid.dart';

class PackageEditor extends ConsumerStatefulWidget {
  const PackageEditor({super.key});

  @override
  ConsumerState<PackageEditor> createState() => _PackageEditorState();
}

class _PackageEditorState extends ConsumerState<PackageEditor> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _iconUrlController = TextEditingController();

  LevelFilter _selectedLevel = LevelFilter.all;
  bool _didSeedFields = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _iconUrlController.dispose();
    super.dispose();
  }

  void _seedFields(LearningPackage pkg) {
    if (_didSeedFields) return;
    _titleController.text = pkg.title;
    _descriptionController.text = pkg.description;
    _categoryController.text = pkg.category;
    _iconUrlController.text = pkg.iconUrl;
    _selectedLevel = LevelFilter.values.firstWhere(
      (l) =>
          l != LevelFilter.all &&
          l.label.toLowerCase() == pkg.level.trim().toLowerCase(),
      orElse: () => LevelFilter.all,
    );
    _didSeedFields = true;
  }

  Future<void> _handleSave(LearningPackage pkg) async {
    if (_isSaving || !_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final now = DateTime.now();
    final resolvedId =
        pkg.packageId.isEmpty || pkg.packageId.startsWith('temp-')
        ? Uuid().v4()
        : pkg.packageId;
    final updated = LearningPackage(
      packageId: resolvedId,
      author: pkg.author,
      category: _categoryController.text.trim(),
      description: _descriptionController.text.trim(),
      iconUrl: _iconUrlController.text.trim(),
      keyWords: pkg.keyWords == null ? null : List<String>.from(pkg.keyWords!),
      language: pkg.language,
      lastUpdateDate: now,
      level: _selectedLevel == LevelFilter.all ? '' : _selectedLevel.label,
      title: _titleController.text.trim(),
      version: pkg.version + 1,
      words: pkg.words,
    );
    try {
      await ref
          .read(packageNotifierProvider.notifier)
          .updateSelectedPackage(updated);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Package details updated')));
      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save package: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _field(String label, Widget child, {String? helper}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      if (helper != null) ...[
        const SizedBox(height: 4),
        Text(
          helper,
          style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.6)),
        ),
      ],
      const SizedBox(height: 8),
      child,
    ],
  );

  @override
  Widget build(BuildContext context) {
    final packageAsync = ref.watch(packageNotifierProvider);
    return packageAsync.when(
      data: (data) {
        final pkg = data.selectedPackage;
        if (pkg == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Edit Package')),
            body: const Center(
              child: Text('Select or create a package before editing details.'),
            ),
          );
        }
        _seedFields(pkg);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Package'),
            actions: [
              TextButton(
                onPressed: _isSaving ? null : () => _handleSave(pkg),
                child: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _field(
                    'Title',
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a descriptive package title',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Title is required'
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _field(
                    'Description',
                    TextFormField(
                      controller: _descriptionController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Summarize what this package covers',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _field(
                    'Category',
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        hintText: 'Category name',
                      ),
                    ),
                    helper:
                        'Use a single category to help organize packages (e.g. "Food" or "Travel").',
                  ),
                  const SizedBox(height: 20),
                  _field(
                    'Level',
                    DropdownButtonFormField<LevelFilter>(
                      value: _selectedLevel,
                      items: LevelFilter.values
                          .map(
                            (level) => DropdownMenuItem(
                              value: level,
                              child: Text(
                                level == LevelFilter.all
                                    ? 'Not set'
                                    : level.label,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(
                        () => _selectedLevel = val ?? LevelFilter.all,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _field(
                    'Icon URL',
                    TextFormField(
                      controller: _iconUrlController,
                      decoration: const InputDecoration(
                        hintText: 'https://example.com/icon.png',
                      ),
                    ),
                    helper: 'Provide an image URL to represent this package.',
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _iconUrlController,
                    builder: (_, value, __) {
                      final trimmed = value.text.trim();
                      if (trimmed.isEmpty) return const SizedBox.shrink();
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                trimmed,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 64,
                                  height: 64,
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.broken_image_outlined,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                trimmed,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Metadata summary',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Current version: v${pkg.version}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        Text(
                          'Words in package: ${pkg.words.length}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        Text(
                          'Package ID: ${pkg.packageId.isEmpty ? 'Not assigned yet' : pkg.packageId}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Edit Package')),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}
