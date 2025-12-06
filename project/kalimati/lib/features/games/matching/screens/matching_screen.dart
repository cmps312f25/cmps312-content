import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalimati/core/entities/sentence.dart';
import 'package:kalimati/core/entities/word.dart';
import 'package:kalimati/core/entities/definition.dart';
import 'package:kalimati/features/games/game_providers.dart';
import 'package:kalimati/features/games/matching/providers/matching_providers.dart';
import 'package:kalimati/features/games/matching/widgets/matching_widgets.dart';
import 'package:kalimati/core/providers/package_provider.dart';

class MatchingScreen extends ConsumerStatefulWidget {
  const MatchingScreen({super.key});

  @override
  ConsumerState<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends ConsumerState<MatchingScreen>
    with WidgetsBindingObserver {
  static const Color _green = Color(0xFF2E7D32);
  static const Color _bg = Color(0xFFF6F2F7);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      ref.read(gameProvider.notifier).startTimer();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ref.read(gameProvider.notifier).pauseTimer();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = ref.read(gameProvider.notifier);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      controller.pauseTimer();
    } else if (state == AppLifecycleState.resumed) {
      controller.resumeTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pkg = ref.watch(packageNotifierProvider).value?.selectedPackage;
    final myPackageKey = (pkg?.packageId.toString() ?? pkg?.title ?? 'unknown')
        .trim();

    ref.listen<Map<String, int>>(packageResetTicksProvider, (prev, next) {
      final prevTick = prev?[myPackageKey] ?? 0;
      final nextTick = next[myPackageKey] ?? 0;
      if (nextTick != prevTick) {
        final controller = ref.read(gameProvider.notifier);
        controller.pauseTimer();
        controller.restartGame();
        controller.resumeTimer();
      }
    });

    final game = ref.watch(gameProvider);
    final controller = ref.read(gameProvider.notifier);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          controller.pauseTimer();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _bg,
          elevation: 0,
          title: const Text('Match the Pairs'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Restart',
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                await _stopSpeaking();
                controller.restartGame();
                controller.resumeTimer();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (game.feedback.isNotEmpty) FeedbackBanner(text: game.feedback),
              const SizedBox(height: 10),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _ListSectionWords(
                        items: game.words,
                        selectedIndex: game.selectedWordIndex,
                        matched: game.matched.keys.toSet(),
                        onTap: controller.selectWord,
                        onLongPress: (i) =>
                            _showActionsSheet(word: game.words[i]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ListSectionDefs(
                        items: game.definitions,
                        selectedIndex: game.selectedDefIndex,
                        matched: game.matched.values.toSet(),
                        onTap: controller.selectDefinition,
                        onLongPress: (i) =>
                            _showActionsSheet(definition: game.definitions[i]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ScoreBar(
                score: game.score,
                attempts: game.attempts,
                seconds: game.seconds,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Finish'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () async {
                    if (!controller.isFinished()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Complete all matches to finish'),
                        ),
                      );
                      return;
                    }
                    await _stopSpeaking();
                    controller.pauseTimer();
                    if (!context.mounted) return;
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Great job!'),
                        content: const Text('You finished the matching game.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    if (ok == true && context.mounted) {
                      ref.read(progressByPackageProvider.notifier).update((
                        map,
                      ) {
                        final next = Map<String, Set<String>>.from(map);
                        final current = {...(next[myPackageKey] ?? <String>{})};
                        current.remove('matching');
                        if (current.isEmpty) {
                          next.remove(myPackageKey);
                        } else {
                          next[myPackageKey] = current;
                        }
                        return next;
                      });

                      final controller = ref.read(gameProvider.notifier);
                      controller.pauseTimer();
                      controller.restartGame();

                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showActionsSheet({Word? word, Definition? definition}) async {
    final String label = word?.text ?? definition?.text ?? '';
    final List<Sentence> sentences = word?.sentences ?? const <Sentence>[];
    final String example = sentences.isNotEmpty
        ? sentences.first.text
        : 'No example available.';

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.volume_up_outlined),
              title: const Text('Hear pronunciation'),
              onTap: () async {
                Navigator.pop(ctx);
                await _speak(label);
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: const Text('Show example sentence'),
              onTap: () {
                Navigator.pop(ctx);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Example'),
                    content: Text(example),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_all_outlined),
              title: const Text('Copy text'),
              onTap: () async {
                final messenger = ScaffoldMessenger.of(context);
                await Clipboard.setData(ClipboardData(text: label));
                if (context.mounted) {
                  Navigator.pop(ctx);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Copied')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _speak(String text) async {
    if (text.trim().isEmpty) return;
    final tts = ref.read(ttsProvider);
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    final langCode = isArabic ? 'ar-SA' : 'en-US';
    await tts.setLanguage(langCode);
    await tts.setVolume(1.0);
    await tts.setPitch(1.0);
    await tts.setSpeechRate(0.45);
    try {
      await tts.stop();
      await tts.speak(text);
    } catch (_) {}
  }

  Future<void> _stopSpeaking() async {
    final tts = ref.read(ttsProvider);
    try {
      await tts.stop();
    } catch (_) {}
  }
}

class _ListSectionWords extends StatelessWidget {
  const _ListSectionWords({
    required this.items,
    required this.selectedIndex,
    required this.matched,
    required this.onTap,
    required this.onLongPress,
  });

  final List<Word> items;
  final int? selectedIndex;
  final Set<Word> matched;
  final void Function(int) onTap;
  final void Function(int) onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListSection<Word>(
      title: 'Words',
      items: items,
      isSelected: (i) => i == selectedIndex,
      isMatched: (w) => matched.contains(w),
      labelOf: (w) => w.text,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

class _ListSectionDefs extends StatelessWidget {
  const _ListSectionDefs({
    required this.items,
    required this.selectedIndex,
    required this.matched,
    required this.onTap,
    required this.onLongPress,
  });

  final List<Definition> items;
  final int? selectedIndex;
  final Set<Definition> matched;
  final void Function(int) onTap;
  final void Function(int) onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListSection<Definition>(
      title: 'Definitions',
      items: items,
      isSelected: (i) => i == selectedIndex,
      isMatched: (d) => matched.contains(d),
      labelOf: (d) => d.text,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
