import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati/core/entities/learning_package.dart';
import 'package:kalimati/core/entities/word.dart';
import 'package:kalimati/core/providers/package_provider.dart';
import 'package:kalimati/features/package_editor/screens/word_editor_form_page.dart';

class ManageWordsPage extends ConsumerWidget {
  const ManageWordsPage({super.key});

  static const Color pageBg = Color(0xFFF7F9F7);
  static const Color brandGreen = Color(0xFF2E7D32);
  static const Color headerTint = Color(0xFFE8F5E9);
  static const Color cardTint = Color(0xFFDFF6E2);
  static const Color accentYellow = Color(0xFFFFF7D6);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageAsyncValue = ref.watch(packageNotifierProvider);

    return packageAsyncValue.when(
      data: (data) {
        final selectedPackage = data.selectedPackage;
        if (selectedPackage == null) {
          return _buildNoSelectionScaffold(context);
        }

        final title = selectedPackage.title.isEmpty
            ? 'Untitled Package'
            : selectedPackage.title;

        return Scaffold(
          backgroundColor: pageBg,
          appBar: _buildAppBar(context, title: title),
          body: _ManageWordsView(package: selectedPackage),
        );
      },
      error: (error, _) => Scaffold(
        backgroundColor: pageBg,
        appBar: _buildAppBar(context, title: 'Manage Words'),
        body: Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      loading: () => const Scaffold(
        backgroundColor: pageBg,
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context, {
    required String title,
  }) {
    return AppBar(
      backgroundColor: headerTint,
      title: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildNoSelectionScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: _buildAppBar(context, title: 'Select a Package'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(Icons.auto_stories_outlined, size: 52, color: Colors.black54),
            SizedBox(height: 20),
            Text(
              'No package selected',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            Text(
              'Choose a learning package from the dashboard to manage its words.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManageWordsView extends ConsumerWidget {
  const _ManageWordsView({required this.package});

  final LearningPackage package;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = package.words;
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: _PackageSummary(
            title: package.title.isEmpty ? 'Untitled Package' : package.title,
            wordsCount: words.length,
            level: package.level,
            language: package.language,
            lastUpdated: package.lastUpdateDate,
            version: package.version,
          ),
        ),
        Expanded(
          child: words.isEmpty
              ? _buildEmptyWordsState(theme)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  itemCount: words.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final word = words[index];
                    return _WordCard(
                      index: index + 1,
                      word: word,
                      onEdit: () => _handleEditWord(context, word),
                      onDelete: () => _handleDeleteWord(context, ref, word),
                    );
                  },
                ),
        ),
        _buildBottomActions(context),
      ],
    );
  }

  Widget _buildEmptyWordsState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 48,
              color: theme.colorScheme.outline.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 12),
            const Text(
              'No words yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Start building your package by editing the package\'s details, then start adding vocabulary items.',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  context.push('/package-editor');
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text(
                  'Edit Package Details',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              flex: 0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 140),
                child: ElevatedButton.icon(
                  onPressed: () => _openWordEditor(context),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text(
                    'Add Word',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ManageWordsPage.brandGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDeleteWord(
    BuildContext context,
    WidgetRef ref,
    Word word,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        const brandBg = Color.fromARGB(255, 243, 255, 243);
        return AlertDialog(
          backgroundColor: brandBg,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Word',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ManageWordsPage.brandGreen,
            ),
          ),
          content: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              children: [
                const TextSpan(text: 'Remove the word '),
                TextSpan(
                  text: '"${word.text}"',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: ' from this package? This action cannot be undone.',
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: ManageWordsPage.brandGreen,
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await ref.read(packageNotifierProvider.notifier).removeWord(word);
        messenger.showSnackBar(
          SnackBar(content: Text('"${word.text}" removed successfully.')),
        );
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error removing word: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleEditWord(BuildContext context, Word word) {
    _openWordEditor(context, word: word);
  }

  Future<void> _openWordEditor(BuildContext context, {Word? word}) async {
    await Navigator.of(context).push<Word>(
      MaterialPageRoute(
        builder: (_) => WordEditorFormPage(args: WordEditorArgs(word: word)),
      ),
    );
  }
}

class _PackageSummary extends StatelessWidget {
  final String title;
  final int wordsCount;
  final String level;
  final String language;
  final DateTime lastUpdated;
  final int version;

  const _PackageSummary({
    required this.title,
    required this.wordsCount,
    required this.level,
    required this.language,
    required this.lastUpdated,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Colors.black.withValues(alpha: 0.6);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ManageWordsPage.brandGreen,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: ManageWordsPage.brandGreen.withValues(alpha: .2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _SummaryChip(
                label: 'Words',
                value: '$wordsCount',
                icon: Icons.menu_book_outlined,
              ),
              _SummaryChip(
                label: 'Level',
                value: level.isEmpty ? '—' : level,
                icon: Icons.school_outlined,
              ),
              _SummaryChip(
                label: 'Language',
                value: language.isEmpty ? '—' : language,
                icon: Icons.translate_outlined,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Last updated: ${_formatDate(lastUpdated)} [ver. $version]',
            style: TextStyle(color: muted, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  letterSpacing: .4,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WordCard extends StatelessWidget {
  const _WordCard({
    required this.index,
    required this.word,
    required this.onEdit,
    required this.onDelete,
  });

  final int index;
  final Word word;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final definitionCount = word.definitions.length;
    final sentenceCount = word.sentences.length;

    final resourceCount = word.resources.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: ManageWordsPage.accentYellow,
                  child: Text(
                    index.toString(),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.text,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 10,
                        runSpacing: 6,
                        children: [
                          _InfoPill(
                            icon: Icons.description_outlined,
                            label:
                                '$definitionCount definition${definitionCount == 1 ? '' : 's'}',
                          ),
                          _InfoPill(
                            icon: Icons.chat_outlined,
                            label:
                                '$sentenceCount sentence${sentenceCount == 1 ? '' : 's'}',
                          ),
                          if (resourceCount > 0)
                            _InfoPill(
                              icon: Icons.link_outlined,
                              label:
                                  '$resourceCount resource${resourceCount == 1 ? '' : 's'}',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    _CircleActionButton(
                      icon: Icons.edit_outlined,
                      color: Colors.blue[700]!,
                      onTap: onEdit,
                      tooltip: 'Edit word',
                    ),
                    const SizedBox(height: 10),
                    _CircleActionButton(
                      icon: Icons.delete_outline,
                      color: Colors.red[600]!,
                      onTap: onDelete,
                      tooltip: 'Delete word',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.1),
          ),
          child: Icon(icon, color: color),
        ),
      ),
    );
  }
}
