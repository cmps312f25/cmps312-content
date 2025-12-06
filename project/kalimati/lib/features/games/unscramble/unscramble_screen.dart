import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalimati/core/providers/package_provider.dart';
import 'package:kalimati/features/games/game_providers.dart';
import 'unscramble_providers.dart';
import 'unscramble_state.dart';
import 'unscramble_widgets.dart';

class UnscrambleScreen extends ConsumerWidget {
  const UnscrambleScreen({super.key});

  static const primary = Color(0xFF2E7D32);
  static const mutedBg = Color(0xFFF6F2F7);
  static const answerBg = Color(0xFFF2F5F2);

  void _pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPackage = ref
        .watch(packageNotifierProvider)
        .value
        ?.selectedPackage;
    final myPackageKey =
        selectedPackage?.packageId.toString().trim() ?? 'unknown';

    ref.listen<Map<String, int>>(packageResetTicksProvider, (prev, next) {
      final prevTick = prev?[myPackageKey] ?? 0;
      final nextTick = next[myPackageKey] ?? 0;
      if (nextTick != prevTick) {
        ref.read(unscrambleGameProvider.notifier).restartGame();
      }
    });

    final game = ref.watch(unscrambleGameProvider);
    final controller = ref.read(unscrambleGameProvider.notifier);
    final borderColor = Colors.grey.shade400;

    if (selectedPackage == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('No package selected.')),
      );
    }

    final total = game.sentences.isEmpty ? 1 : game.sentences.length;
    final progress = '${game.currentIndex + 1}/$total';
    final wordsRemaining = (game.correctWords.length - game.chosenWords.length)
        .clamp(0, 999);

    final remainingWords = game.correctWords
        .skip(game.chosenWords.length)
        .toList();

    final hintDisabled = game.hintsUsed >= game.hintsLimit;
    final hintCaption = '(${game.hintsUsed}/${game.hintsLimit})';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: mutedBg,
        appBar: AppBar(
          backgroundColor: mutedBg,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _pop(context),
          ),
          centerTitle: true,
          title: Text(
            progress,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'restart_game',
                  child: Text('Restart game'),
                ),
              ],
              onSelected: (value) {
                if (value == 'restart_game') {
                  controller.restartGame();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Game restarted')),
                  );
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Arrange the words to\nform a correct sentence.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  selectedPackage.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: answerBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 1.4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 12,
                        children: [
                          ...game.chosenWords.asMap().entries.map(
                            (e) => AnswerWordChip(
                              label: e.value,
                              color: primary,
                              onRemove: () =>
                                  controller.removeFromChosen(e.key),
                            ),
                          ),
                          ...remainingWords.map(
                            (word) => BlankChip(
                              width: measureChipWidth(context, word),
                              borderColor: borderColor,
                            ),
                          ),
                        ],
                      ),
                      if (game.attemptStatus == AttemptStatus.correct ||
                          game.attemptStatus == AttemptStatus.incorrect) ...[
                        const SizedBox(height: 14),
                        AttemptBanner(
                          success: game.attemptStatus == AttemptStatus.correct,
                          primary: primary,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$wordsRemaining word${wordsRemaining == 1 ? '' : 's'} remaining',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        MiniAction(
                          icon: Icons.restart_alt,
                          label: 'Restart',
                          onTap: controller.restartSentence,
                        ),
                        MiniAction(
                          icon: Icons.lightbulb_outline,
                          label: 'Hint',
                          caption: hintCaption,
                          disabled: hintDisabled,
                          onTap: () {
                            final result = controller.useHint();
                            if (result == HintResult.overLimit &&
                                context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Hint limit reached for this sentence',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        MiniAction(
                          icon: Icons.shuffle,
                          label: 'Shuffle',
                          onTap: controller.shuffleAvailableWords,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ...game.availableWords.asMap().entries.map(
                      (e) => PoolWordChip(
                        label: e.value,
                        onTap: () => controller.pickFromAvailable(e.key),
                      ),
                    ),
                    if (game.availableWords.isEmpty && game.chosenWords.isEmpty)
                      Text(
                        'No sentence found.',
                        style: TextStyle(color: borderColor),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    (game.chosenWords.isEmpty &&
                        game.attemptStatus != AttemptStatus.correct)
                    ? Colors.grey.shade400
                    : primary,
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                foregroundColor: Colors.white,
              ),
              onPressed:
                  (game.chosenWords.isEmpty &&
                      game.attemptStatus != AttemptStatus.correct)
                  ? null
                  : () async {
                      if (game.attemptStatus == AttemptStatus.correct) {
                        final isLast =
                            game.currentIndex >= game.sentences.length - 1;
                        if (isLast) {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Great job!'),
                              content: const Text(
                                'You finished all sentences.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                          if (ok == true && context.mounted) {
                            ref.read(progressByPackageProvider.notifier).update(
                              (map) {
                                final next = Map<String, Set<String>>.from(map);
                                final key = myPackageKey;
                                final current = {...(next[key] ?? <String>{})};
                                current.remove('unscramble');
                                if (current.isEmpty) {
                                  next.remove(key);
                                } else {
                                  next[key] = current;
                                }
                                return next;
                              },
                            );

                            ref
                                .read(unscrambleGameProvider.notifier)
                                .restartGame();

                            Navigator.of(context).pop();
                          }
                        } else {
                          controller.nextSentence();
                        }
                      } else {
                        controller.validateAttempt();
                      }
                    },
              child: Text(
                game.attemptStatus == AttemptStatus.correct
                    ? 'Next'
                    : 'Validate',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
