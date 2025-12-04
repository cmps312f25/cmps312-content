import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hikayati/core/widgets/empty_state_widget.dart';
import 'package:hikayati/core/widgets/loading_widget.dart';
import 'package:hikayati/core/widgets/error_display_widget.dart';
import 'package:hikayati/features/story_list/presentation/providers/stories_provider.dart';
import 'package:hikayati/features/story_list/presentation/widgets/story_card.dart';
import 'package:hikayati/features/story_list/presentation/widgets/search_bar.dart'
    as custom;
import 'package:hikayati/features/story_list/presentation/widgets/filter_sheet.dart';
import 'package:hikayati/core/entities/reading_level.dart';
import 'package:hikayati/core/entities/story.dart';
import 'package:hikayati/features/auth/presentation/providers/auth_provider.dart';

class StoryListPage extends ConsumerStatefulWidget {
  const StoryListPage({super.key});

  @override
  ConsumerState<StoryListPage> createState() => _StoryListPageState();
}

class _StoryListPageState extends ConsumerState<StoryListPage> {
  final Set<ReadingLevel> _selectedLevels = {};
  final Set<int> _selectedCategoryIds = {};

  @override
  void initState() {
    super.initState();
    // Refresh stories whenever this page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(storiesNotifierProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final storiesAsync = ref.watch(storiesNotifierProvider);
    final currentUser = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // First row: App title and sign-in/user info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hikayati',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    if (currentUser != null) ...[
                      Row(
                        children: [
                          Text(
                            '${currentUser.firstName} ${currentUser.lastName}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.logout),
                            tooltip: 'Sign Out',
                            color: theme.colorScheme.onSurface,
                            onPressed: () {
                              ref.read(authNotifierProvider.notifier).signOut();
                            },
                          ),
                        ],
                      ),
                    ] else ...[
                      TextButton.icon(
                        onPressed: () => context.push('/signin'),
                        icon: const Icon(Icons.login),
                        label: const Text('Sign In'),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                // Second row: Search bar and filter button
                Row(
                  children: [
                    Expanded(
                      child: custom.SearchBar(
                        hintText: 'Search stories...',
                        onSearchChanged: (query) {
                          if (query.isEmpty) {
                            ref
                                .read(storiesNotifierProvider.notifier)
                                .refresh();
                          } else {
                            ref
                                .read(storiesNotifierProvider.notifier)
                                .search(query);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      tooltip: 'Filter',
                      color: theme.colorScheme.primary,
                      onPressed: _showFilterSheet,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: storiesAsync.when(
        data: (stories) => stories.isEmpty
            ? const EmptyStateWidget(
                icon: Icons.search_off,
                title: 'No Stories Found',
                message: 'No stories matching your criteria.',
              )
            : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  return StoryCard(
                    story: story,
                    onTap: () => context.push('/story/${story.id}'),
                    onQuizTap: () => context.push('/story/${story.id}/quiz'),
                    onEdit: () => context.push('/story-editor/${story.id}'),
                    onDelete: () => _showDeleteConfirmation(context, story),
                    onEditQuiz: () => context.push('/quiz-editor/${story.id}'),
                  );
                },
              ),
        loading: () => const LoadingWidget(message: 'Loading stories...'),
        error: (error, stack) => ErrorDisplayWidget(
          message: error.toString(),
          onRetry: () => ref.read(storiesNotifierProvider.notifier).refresh(),
        ),
      ),
      floatingActionButton: currentUser != null
          ? FloatingActionButton(
              heroTag: 'story_list_fab',
              onPressed: () => context.push('/story-editor/new'),
              child: const Icon(Icons.auto_stories),
            )
          : null,
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => FilterSheet(
        initialLevels: _selectedLevels,
        initialCategoryIds: _selectedCategoryIds,
        onApply: (levels, categoryIds) {
          ref
              .read(storiesNotifierProvider.notifier)
              .filter(
                readingLevels: levels.map((e) => e.value).toList(),
                categoryIds: categoryIds.toList(),
              );
          setState(() {
            _selectedLevels
              ..clear()
              ..addAll(levels);
            _selectedCategoryIds
              ..clear()
              ..addAll(categoryIds);
          });
        },
        onReset: () {
          ref.read(storiesNotifierProvider.notifier).refresh();
          setState(() {
            _selectedLevels.clear();
            _selectedCategoryIds.clear();
          });
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Story story) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
        title: const Text('Delete Story?'),
        content: Text(
          'Are you sure you want to delete "${story.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteStory(story.id!);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteStory(int storyId) async {
    try {
      // TODO: Implement delete functionality
      // Refresh the stories list
      ref.read(storiesNotifierProvider.notifier).refresh();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Delete functionality to be implemented'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete story: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
