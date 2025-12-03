import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/utils/responsive_helper.dart';
import 'package:hikayati/core/widgets/language_selector.dart';
import 'package:hikayati/core/widgets/reading_level_selector.dart';
import 'package:hikayati/core/widgets/category_selector.dart';
import 'package:hikayati/features/story_editor/repositories/story_repository_impl.dart';

/// Full-screen bottom sheet for creating a new story
class CreateStorySheet extends ConsumerStatefulWidget {
  const CreateStorySheet({super.key});

  @override
  ConsumerState<CreateStorySheet> createState() => _CreateStorySheetState();
}

class _CreateStorySheetState extends ConsumerState<CreateStorySheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _coverImageUrlController;

  String? _selectedLanguageCode;
  String? _selectedReadingLevel;
  String? _selectedCategoryName;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _coverImageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _coverImageUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedLanguageCode == null || _selectedReadingLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select language and reading level'),
        ),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      final story = await ref
          .read(storyEditorRepositoryProvider)
          .createStory(
            title: _titleController.text,
            language: _selectedLanguageCode!,
            readingLevel: _selectedReadingLevel!,
            categoryId: _getCategoryIdByName(_selectedCategoryName),
            coverImageUrl: _coverImageUrlController.text.isEmpty
                ? null
                : _coverImageUrlController.text,
          );

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(story);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCreating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create story: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create New Story')),
      body: ResponsivePadding.page(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                enabled: !_isCreating,
              ),
              ResponsiveGap.md(),

              // Language Selector
              Text('Language', style: theme.textTheme.titleMedium),
              ResponsiveGap.sm(),
              AbsorbPointer(
                absorbing: _isCreating,
                child: LanguageSelector(
                  selectedLanguage: _selectedLanguageCode,
                  onLanguageSelected: (code) =>
                      setState(() => _selectedLanguageCode = code),
                ),
              ),
              ResponsiveGap.md(),

              // Reading Level Selector
              Text('Reading Level', style: theme.textTheme.titleMedium),
              ResponsiveGap.sm(),
              AbsorbPointer(
                absorbing: _isCreating,
                child: ReadingLevelSelector(
                  selectedLevel: _selectedReadingLevel,
                  onLevelSelected: (level) =>
                      setState(() => _selectedReadingLevel = level),
                ),
              ),
              ResponsiveGap.md(),

              // Category Selector
              Text('Category', style: theme.textTheme.titleMedium),
              ResponsiveGap.sm(),
              AbsorbPointer(
                absorbing: _isCreating,
                child: CategorySelector(
                  selectedCategory: _selectedCategoryName,
                  onCategorySelected: (name) =>
                      setState(() => _selectedCategoryName = name),
                ),
              ),
              ResponsiveGap.md(),

              // Cover Image URL
              Text(
                'Cover Image URL (Optional)',
                style: theme.textTheme.titleMedium,
              ),
              ResponsiveGap.sm(),
              TextField(
                controller: _coverImageUrlController,
                enabled: !_isCreating,
                decoration: const InputDecoration(
                  hintText: 'Enter image URL',
                  prefixIcon: Icon(Icons.image),
                ),
              ),

              ResponsiveGap.lg(),

              // Create Story Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isCreating ? null : _handleCreate,
                  icon: _isCreating
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_stories),
                  label: Text(_isCreating ? 'Creating...' : 'Create Story'),
                ),
              ),
              ResponsiveGap.lg(),
            ],
          ),
        ),
      ),
    );
  }

  int? _getCategoryIdByName(String? categoryName) {
    if (categoryName == null) return null;
    return switch (categoryName) {
      'Adventure' => 1,
      'Fantasy' => 2,
      'Science' => 3,
      _ => null,
    };
  }
}
