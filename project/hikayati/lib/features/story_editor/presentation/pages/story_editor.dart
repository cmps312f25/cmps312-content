import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hikayati/core/widgets/responsive_helper.dart';
import 'package:hikayati/core/widgets/loading_widget.dart';
import 'package:hikayati/core/widgets/error_display_widget.dart';
import 'package:hikayati/core/widgets/empty_state_widget.dart';
import 'package:hikayati/features/story_editor/presentation/widgets/language_selector.dart';
import 'package:hikayati/features/story_editor/presentation/widgets/reading_level_selector.dart';
import 'package:hikayati/features/story_editor/presentation/widgets/category_selector.dart';
import 'package:hikayati/features/story_editor/presentation/providers/story_provider.dart';
import 'package:hikayati/features/story_editor/presentation/providers/sections_provider.dart';
import 'package:hikayati/features/story_list/presentation/providers/stories_provider.dart';

class StoryEditor extends ConsumerStatefulWidget {
  final int? storyId;
  const StoryEditor({super.key, this.storyId});

  @override
  ConsumerState<StoryEditor> createState() => _StoryEditorState();
}

class _StoryEditorState extends ConsumerState<StoryEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _coverImageUrlController;

  // State for new fields
  String? _selectedLanguageCode;
  String? _selectedReadingLevel;
  int? _selectedCategoryId;

  // Track initial load to avoid showing success message on first load
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _coverImageUrlController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.storyId != null) {
        ref.read(storyNotifierProvider.notifier).loadStory(widget.storyId!);
        ref
            .read(sectionsNotifierProvider.notifier)
            .loadSections(widget.storyId!);
      } else {
        // Reset story and sections when creating a new story
        ref.read(storyNotifierProvider.notifier).resetStory();
        ref.read(sectionsNotifierProvider.notifier).clearSections();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _coverImageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyAsync = ref.watch(storyNotifierProvider);
    final sectionsAsync = ref.watch(sectionsNotifierProvider);
    final theme = Theme.of(context);

    ref.listen(storyNotifierProvider, (previous, next) {
      next.whenData((story) {
        if (story != null) {
          _titleController.text = story.title;

          if (_selectedLanguageCode == null) {
            setState(() {
              _selectedLanguageCode = story.language;
              _selectedReadingLevel = story.readingLevel.value;
              _selectedCategoryId = story.categoryId;
              _coverImageUrlController.text = story.coverImageUrl ?? '';
            });
          }

          if (previous?.isLoading == true && !_isInitialLoad) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Story saved successfully')),
            );
          }
          _isInitialLoad = false;
        }
      });

      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        },
      );
    });

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // Invalidate the stories provider when leaving the editor
        if (didPop && mounted) {
          // This will trigger a refresh when returning to the story list
          Future.microtask(() {
            if (mounted) {
              ref.invalidate(storiesNotifierProvider);
            }
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.storyId == null ? 'New Story' : 'Edit Story'),
          actions: [
            storyAsync.when(
              data: (story) {
                if (story != null) {
                  return TextButton(
                    onPressed: () => _saveStoryAndReturn(story.id!),
                    child: const Text('Save'),
                  );
                }
                return const SizedBox.shrink();
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
        body: storyAsync.when(
          data: (story) {
            if (story == null) {
              return _buildInitialView(context);
            }

            return sectionsAsync.when(
              data: (sections) => ResponsivePadding.page(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Text(
                        'Story Details',
                        style: theme.textTheme.headlineSmall,
                      ),
                      ResponsiveGap.md(),
                      _buildStoryForm(theme),
                      ResponsiveGap.lg(),
                      _buildSectionsList(theme, story, sections),
                    ],
                  ),
                ),
              ),
              loading: () =>
                  const LoadingWidget(message: 'Loading sections...'),
              error: (error, _) => ErrorDisplayWidget(
                message: 'Failed to load sections: $error',
                onRetry: () => ref
                    .read(sectionsNotifierProvider.notifier)
                    .loadSections(story.id!),
              ),
            );
          },
          loading: () => const LoadingWidget(message: 'Loading story...'),
          error: (error, _) => ErrorDisplayWidget(
            message: 'Failed to load story: $error',
            onRetry: () {
              if (widget.storyId != null) {
                ref
                    .read(storyNotifierProvider.notifier)
                    .loadStory(widget.storyId!);
                ref
                    .read(sectionsNotifierProvider.notifier)
                    .loadSections(widget.storyId!);
              }
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    int sectionId,
    int storyId,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Section'),
          content: const Text(
            'Are you sure you want to delete this section? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                ref
                    .read(sectionsNotifierProvider.notifier)
                    .deleteSection(sectionId, storyId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildInitialView(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsivePadding.page(
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text('Create New Story', style: theme.textTheme.headlineSmall),
            ResponsiveGap.xs(),
            _buildStoryForm(theme),
            ResponsiveGap.xs(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _createStory,
                icon: const Icon(Icons.auto_stories, size: 24),
                label: const Text('Create Story'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Title'),
          validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
        ),
        ResponsiveGap.xs(),
        Text('Language', style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        LanguageSelector(
          selectedLanguage: _selectedLanguageCode,
          onLanguageSelected: (code) =>
              setState(() => _selectedLanguageCode = code),
        ),
        ResponsiveGap.xs(),
        Text('Reading Level', style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        ReadingLevelSelector(
          selectedLevel: _selectedReadingLevel,
          onLevelSelected: (level) =>
              setState(() => _selectedReadingLevel = level),
        ),
        ResponsiveGap.xs(),
        Text('Category', style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        CategorySelector(
          selectedCategoryId: _selectedCategoryId,
          onCategorySelected: (id) => setState(() => _selectedCategoryId = id),
        ),
        ResponsiveGap.xs(),
        Text('Cover Image URL (Optional)', style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        TextField(
          controller: _coverImageUrlController,
          decoration: const InputDecoration(
            hintText: 'Enter image URL',
            prefixIcon: Icon(Icons.image),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionsList(
    ThemeData theme,
    dynamic story,
    List<dynamic> sections,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sections', style: theme.textTheme.headlineSmall),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _addSection(story.id!, sections.length),
            ),
          ],
        ),
        ResponsiveGap.sm(),
        if (sections.isEmpty)
          const EmptyStateWidget(
            icon: Icons.note_add_outlined,
            title: 'No Sections Yet',
            message: 'Add the first section to your story!',
          )
        else
          ...sections.map(
            (section) => _buildSectionCard(theme, story.id!, section),
          ),
      ],
    );
  }

  Widget _buildSectionCard(ThemeData theme, int storyId, dynamic section) {
    return Card(
      child: ListTile(
        title: Text(section.sectionText ?? 'No text'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editSection(storyId, section.id!),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: theme.colorScheme.error),
              onPressed: () =>
                  _showDeleteConfirmation(context, section.id!, storyId),
            ),
          ],
        ),
        onTap: () => _editSection(storyId, section.id!),
      ),
    );
  }

  void _createStory() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedLanguageCode == null || _selectedReadingLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select language and reading level'),
        ),
      );
      return;
    }
    ref
        .read(storyNotifierProvider.notifier)
        .createStory(
          title: _titleController.text,
          language: _selectedLanguageCode!,
          readingLevel: _selectedReadingLevel!,
          categoryId: _selectedCategoryId,
          coverImageUrl: _coverImageUrlController.text.isEmpty
              ? null
              : _coverImageUrlController.text,
        );
  }

  Future<void> _saveStoryAndReturn(int storyId) async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(storyNotifierProvider.notifier)
        .updateStory(
          storyId: storyId,
          title: _titleController.text,
          language: _selectedLanguageCode,
          readingLevel: _selectedReadingLevel,
          categoryId: _selectedCategoryId,
          coverImageUrl: _coverImageUrlController.text.isEmpty
              ? null
              : _coverImageUrlController.text,
        );

    if (mounted) {
      context.pop();
    }
  }

  Future<void> _addSection(int storyId, int sectionCount) async {
    if (mounted) {
      await context.push('/section-editor/$storyId');
      if (mounted) {
        ref.read(sectionsNotifierProvider.notifier).loadSections(storyId);
      }
    }
  }

  Future<void> _editSection(int storyId, int sectionId) async {
    await context.push('/section-editor/$storyId/$sectionId');
    if (mounted) {
      ref.read(sectionsNotifierProvider.notifier).loadSections(storyId);
    }
  }
}
