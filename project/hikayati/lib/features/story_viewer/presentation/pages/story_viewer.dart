import 'package:hikayati/features/story_viewer/presentation/providers/story_sections_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/widgets/loading_widget.dart';
import 'package:hikayati/core/widgets/error_display_widget.dart';

class StoryViewer extends ConsumerStatefulWidget {
  final int storyId;
  const StoryViewer({super.key, required this.storyId});

  @override
  ConsumerState<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends ConsumerState<StoryViewer> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });

    // Invalidate the sections provider to fetch fresh data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(storySectionsProvider(widget.storyId));
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sectionsAsync = ref.watch(storySectionsProvider(widget.storyId));
    final storyAsync = ref.watch(storyProvider(widget.storyId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: storyAsync.when(
          data: (story) => Text(story.title),
          loading: () => const Text('Story Viewer'),
          error: (_, __) => const Text('Story Viewer'),
        ),
        centerTitle: true,
      ),
      body: sectionsAsync.when(
        loading: () => const LoadingWidget(message: 'Loading story...'),
        error: (error, stack) => ErrorDisplayWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(storySectionsProvider(widget.storyId)),
        ),
        data: (sections) {
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Image section - constrained height
                          if (section.imageUrl != null)
                            AspectRatio(
                              aspectRatio: 5 / 1,
                              child: Image.network(
                                section.imageUrl!,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Container(
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  child: const Center(
                                    child: Icon(Icons.broken_image, size: 64),
                                  ),
                                ),
                              ),
                            ),
                          // Text section
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              section.sectionText ?? 'Once upon a time...',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 18,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Navigation bar at bottom
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilledButton.icon(
                      onPressed: _currentPage > 0
                          ? () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    ),
                    Text(
                      '${_currentPage + 1} / ${sections.length}',
                      style: theme.textTheme.titleMedium,
                    ),
                    FilledButton.icon(
                      onPressed: _currentPage < sections.length - 1
                          ? () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
