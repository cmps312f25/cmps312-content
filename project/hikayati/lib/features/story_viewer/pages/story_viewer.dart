import 'package:hikayati/features/story_viewer/providers/story_sections_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/widgets/loading_widget.dart';
import 'package:hikayati/core/widgets/error_display_widget.dart';
import 'package:audioplayers/audioplayers.dart';

class StoryViewer extends ConsumerStatefulWidget {
  final int storyId;
  const StoryViewer({super.key, required this.storyId});

  @override
  ConsumerState<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends ConsumerState<StoryViewer> {
  final PageController _pageController = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentPage = 0;
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        _stopAudio();
        setState(() {
          _currentPage = newPage;
        });
      }
    });

    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          _isLoading = false;
        });
      }
    });

    // Listen to player completion
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });

    // Invalidate the sections provider to fetch fresh data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(storySectionsProvider(widget.storyId));
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String audioUrl) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(audioUrl));
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to play audio: $e')));
      }
    }
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  Future<void> _toggleAudio(String? audioUrl) async {
    if (audioUrl == null) return;

    if (_isPlaying) {
      await _pauseAudio();
    } else {
      await _playAudio(audioUrl);
    }
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
                              section.sectionText,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 18,
                                height: 1.6,
                              ),
                            ),
                          ),
                          // Audio player controls
                          if (section.audioUrl != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 16.0,
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const CircularProgressIndicator()
                                    : FilledButton.icon(
                                        onPressed: () =>
                                            _toggleAudio(section.audioUrl),
                                        icon: Icon(
                                          _isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                        ),
                                        label: Text(
                                          _isPlaying ? 'Pause' : 'Play Audio',
                                        ),
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
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
