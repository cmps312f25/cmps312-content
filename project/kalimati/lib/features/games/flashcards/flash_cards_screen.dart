import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:video_player/video_player.dart';
import 'package:kalimati/core/entities/resource.dart';
import 'package:kalimati/core/entities/learning_package.dart';
import 'package:kalimati/core/entities/enum/resource_type.dart';
import 'package:kalimati/core/providers/package_provider.dart';

final _ttsProvider = Provider((ref) => FlutterTts());

class FlashCardsScreen extends ConsumerStatefulWidget {
  const FlashCardsScreen({super.key});

  @override
  ConsumerState<FlashCardsScreen> createState() => _FlashCardsScreenState();
}

class _FlashCardsScreenState extends ConsumerState<FlashCardsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late FlutterTts _tts;
  List<_CardVM> _cards = [];
  int _index = 0;
  bool _front = true;
  String? _lastPackageId;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _tts = ref.read(_ttsProvider);
  }

  @override
  void dispose() {
    _controller.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pkg = ref.watch(packageNotifierProvider).value?.selectedPackage;

    if (pkg == null) {
      return const Scaffold(body: Center(child: Text('No package selected')));
    }

    // only rebuild cards when the package changes or is first loaded
    if (_cards.isEmpty || pkg.packageId != _lastPackageId) {
      _lastPackageId = pkg.packageId;
      _cards = _buildCards(pkg);
      debugPrint(
        "✅ Built ${_cards.length} flashcards for package '${pkg.title}'",
      );
    }

    if (_cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Flash Cards')),
        body: const Center(
          child: Text('No words available or package not hydrated'),
        ),
      );
    }

    final card = _cards[_index];

    return Scaffold(
      appBar: AppBar(title: Text(pkg.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_index + 1} / ${_cards.length}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () async {
                    await _tts.setSpeechRate(0.45);
                    await _tts.speak(card.word);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GestureDetector(
                onTap: _flip,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final angle = lerpDouble(0, pi, _controller.value)!;
                    final isFront = angle < pi / 2;
                    return Transform(
                      transform: Matrix4.rotationY(angle),
                      alignment: Alignment.center,
                      child: isFront
                          ? _FrontCard(vm: card)
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(pi),
                              child: _BackCard(vm: card),
                            ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filledTonal(
                  onPressed: _prev,
                  icon: const Icon(Icons.chevron_left),
                ),
                FilledButton(
                  onPressed: _flip,
                  child: Text(_front ? 'Show Answer' : 'Show Word'),
                ),
                IconButton.filledTonal(
                  onPressed: _next,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= BUILD CARDS =================

  List<_CardVM> _buildCards(LearningPackage pkg) {
    final cards = <_CardVM>[];

    for (final w in pkg.words) {
      // Debug: Word with resources count
      final media = <Resource>[];

      if (w.resources.isNotEmpty) {
        media.addAll(w.resources.where((r) => r.url.trim().isNotEmpty));
      }

      for (final s in w.sentences) {
        if (s.resources.isNotEmpty) {
          media.addAll(s.resources.where((r) => r.url.trim().isNotEmpty));
        }
      }

      debugPrint(
        "🧩 Word: '${w.text}' | Resources: ${media.length} | Example: ${w.sentences.isNotEmpty ? w.sentences.first.text : '—'}",
      );

      cards.add(
        _CardVM(
          word: w.text,
          definition: w.definitions.isNotEmpty ? w.definitions.first.text : '',
          example: w.sentences.isNotEmpty ? w.sentences.first.text : null,
          mediaList: media,
        ),
      );
    }

    return cards;
  }

  // ================= CARD NAVIGATION =================

  void _flip() {
    if (_front) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() => _front = !_front);
  }

  void _next() {
    setState(() {
      _front = true;
      _controller.reverse();
      _index = (_index + 1) % _cards.length;
    });
  }

  void _prev() {
    setState(() {
      _front = true;
      _controller.reverse();
      _index = (_index - 1) < 0 ? _cards.length - 1 : _index - 1;
    });
  }
}

class _CardVM {
  final String word;
  final String definition;
  final String? example;
  final List<Resource> mediaList;
  const _CardVM({
    required this.word,
    required this.definition,
    this.example,
    required this.mediaList,
  });
}

// ================= FRONT CARD =================

class _FrontCard extends StatelessWidget {
  final _CardVM vm;
  const _FrontCard({required this.vm});
  @override
  Widget build(BuildContext context) {
    return _CardFrame(
      child: Center(
        child: Text(
          vm.word,
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ================= BACK CARD =================

class _BackCard extends StatelessWidget {
  final _CardVM vm;
  const _BackCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    return _CardFrame(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Definition',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              vm.definition.isEmpty ? '(no definition)' : vm.definition,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (vm.example != null && vm.example!.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Example',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(vm.example!, style: Theme.of(context).textTheme.bodyLarge),
            ],
            if (vm.mediaList.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Resources',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...vm.mediaList.asMap().entries.map((entry) {
                final r = entry.value;
                debugPrint('🧠 Rendering resource: ${r.url}');
                return Padding(
                  key: ValueKey('resource_${entry.key}_${r.url}'),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ResourceWidget(resource: r),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

// ================= RESOURCE DISPLAY =================

class _CardFrame extends StatelessWidget {
  final Widget child;
  const _CardFrame({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ResourceWidget extends StatefulWidget {
  final Resource resource;
  const _ResourceWidget({required this.resource});
  @override
  State<_ResourceWidget> createState() => _ResourceWidgetState();
}

class _ResourceWidgetState extends State<_ResourceWidget>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _videoController;
  bool _videoError = false;
  bool _videoInitialized = false;

  @override
  bool get wantKeepAlive => widget.resource.type == ResourceType.video;

  @override
  void initState() {
    super.initState();
    debugPrint('🔗 Resource URL: ${widget.resource.url}');
    if (widget.resource.type == ResourceType.video) _initializeVideo();
  }

  void _initializeVideo() {
    final url = widget.resource.url.trim();
    if (url.isEmpty) {
      if (mounted) setState(() => _videoError = true);
      return;
    }
    try {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
        ..addListener(_onVideoUpdate)
        ..initialize()
            .then((_) {
              if (mounted) {
                setState(() {
                  _videoInitialized = true;
                  _videoError = false;
                });
              }
            })
            .catchError((error) {
              debugPrint('❌ Failed to load video: $url - Error: $error');
              if (mounted) {
                setState(() {
                  _videoError = true;
                  _videoInitialized = false;
                });
              }
            });
    } catch (error) {
      debugPrint('❌ Exception initializing video: $url - Error: $error');
      if (mounted) {
        setState(() {
          _videoError = true;
          _videoInitialized = false;
        });
      }
    }
  }

  void _onVideoUpdate() {
    if (mounted && _videoController != null) {
      if (_videoController!.value.isInitialized && !_videoInitialized) {
        setState(() {
          _videoInitialized = true;
          _videoError = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController?.removeListener(_onVideoUpdate);
    _videoController?.dispose();
    super.dispose();
  }

  bool _isValidUrl(String url) {
    if (url.trim().isEmpty) return false;
    try {
      final uri = Uri.parse(url.trim());
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final url = widget.resource.url.trim();
    final hasValidUrl = _isValidUrl(url);

    switch (widget.resource.type) {
      case ResourceType.photo:
        if (!hasValidUrl) return const SizedBox.shrink();
        return _NetworkImageWidget(url: url);
      case ResourceType.video:
        if (!hasValidUrl) return const SizedBox.shrink();
        if (_videoError) {
          return Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam_off, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'Video not available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }
        if (!_videoInitialized || _videoController == null) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_videoController!),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      _videoController!.value.isPlaying
                          ? Icons.pause_circle
                          : Icons.play_circle,
                      color: Colors.white,
                      size: 64,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_videoController!.value.isPlaying) {
                          _videoController!.pause();
                        } else {
                          _videoController!.play();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      case ResourceType.audio:
        return Text(widget.resource.title);
      case ResourceType.website:
        if (!hasValidUrl) return const SizedBox.shrink();
        return InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: url));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('URL copied to clipboard')),
            );
          },
          child: Text(
            url,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _NetworkImageWidget extends StatelessWidget {
  final String url;
  const _NetworkImageWidget({required this.url});
  @override
  Widget build(BuildContext context) {
    debugPrint('🖼️ Loading image: $url');
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ Failed to load image: $url - Error: $error');
          return Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'Image not available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
