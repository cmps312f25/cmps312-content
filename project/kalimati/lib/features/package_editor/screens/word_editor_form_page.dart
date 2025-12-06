import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalimati/core/entities/definition.dart';
import 'package:kalimati/core/entities/resource.dart';
import 'package:kalimati/core/entities/sentence.dart';
import 'package:kalimati/core/entities/word.dart';
import 'package:kalimati/core/providers/package_provider.dart';
import 'package:kalimati/features/package_editor/screens/attach_media_page.dart';
import 'package:kalimati/core/entities/enum/resource_type.dart';

class WordEditorArgs {
  const WordEditorArgs({this.word});
  final Word? word;
}

class WordEditorFormPage extends ConsumerStatefulWidget {
  const WordEditorFormPage({super.key, this.args});

  final WordEditorArgs? args;

  @override
  ConsumerState<WordEditorFormPage> createState() => _WordEditorFormPageState();
}

class _WordEditorFormPageState extends ConsumerState<WordEditorFormPage> {
  static const Color brandGreen = Color(0xFF2E7D32);
  static const Color brandTint = Color(0xFFE8F5E9);

  late final bool _isEditing = widget.args?.word != null;
  late final TextEditingController _wordController = TextEditingController(
    text: widget.args?.word?.text ?? '',
  );
  final List<_DefinitionFormData> _definitions = [];
  final List<_SentenceFormData> _sentences = [];

  @override
  void initState() {
    super.initState();
    final initialWord = widget.args?.word;
    final existingDefinitions = initialWord?.definitions ?? [];
    if (existingDefinitions.isEmpty) {
      _definitions.add(_DefinitionFormData());
    } else {
      for (final definition in existingDefinitions) {
        _definitions.add(
          _DefinitionFormData(
            definitionText: definition.text,
            sourceText: definition.source,
          ),
        );
      }
    }

    final existingSentences = initialWord?.sentences ?? [];
    if (existingSentences.isEmpty) {
      _sentences.add(_SentenceFormData());
    } else {
      for (final sentence in existingSentences) {
        _sentences.add(
          _SentenceFormData(
            text: sentence.text,
            resources: List<Resource>.from(sentence.resources),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _wordController.dispose();
    for (final def in _definitions) {
      def.dispose();
    }
    for (final sentence in _sentences) {
      sentence.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandTint,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Word' : 'Add Word'),
        backgroundColor: brandTint,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isEditing) _buildWordDisplay() else _buildWordField(),
              const SizedBox(height: 32),
              _buildDefinitionsSection(),
              const SizedBox(height: 32),
              _buildSentencesSection(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildWordField() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: _wordController,
          decoration: const InputDecoration(
            labelText: 'Word',
            hintText: 'Enter a new word',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildWordDisplay() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Word',
              style: TextStyle(
                fontSize: 13,
                letterSpacing: .4,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.args!.word!.text,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefinitionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Definitions',
          count: _definitions.length,
          onAdd: () {
            setState(() {
              _definitions.add(_DefinitionFormData());
            });
          },
        ),
        if (_definitions.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'No definitions yet. Add one to explain the word meaning.',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        for (int i = 0; i < _definitions.length; i++) ...[
          const SizedBox(height: 12),
          _DefinitionCard(
            index: i + 1,
            data: _definitions[i],
            onDelete: () => _handleDeleteDefinition(i),
          ),
        ],
      ],
    );
  }

  Widget _buildSentencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Sentences',
          count: _sentences.length,
          onAdd: () {
            setState(() {
              _sentences.add(_SentenceFormData());
            });
          },
        ),
        if (_sentences.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'Use example sentences to show the word in context.',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        for (int i = 0; i < _sentences.length; i++) ...[
          const SizedBox(height: 12),
          _SentenceCard(
            index: i + 1,
            data: _sentences[i],
            onDelete: () => _handleDeleteSentence(i),
            onAttachMedia: () => _handleAttachMedia(i),
            onRemoveMedia: (resourceIndex) =>
                _handleDeleteMedia(i, resourceIndex),
          ),
        ],
      ],
    );
  }

  Future<void> _handleAttachMedia(int sentenceIndex) async {
    final sentenceData = _sentences[sentenceIndex];
    final sentence = sentenceData.textController.text.trim();
    if (sentence.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the sentence before attaching media.'),
        ),
      );
      return;
    }

    final updatedResources = await Navigator.of(context).push<List<Resource>>(
      MaterialPageRoute(
        builder: (_) => AttachMediaPage(
          sentenceText: sentence,
          initialResources: List<Resource>.from(sentenceData.resources),
        ),
      ),
    );

    if (updatedResources != null) {
      setState(() {
        sentenceData.resources = updatedResources;
      });
    }
  }

  Future<void> _handleDeleteMedia(int sentenceIndex, int resourceIndex) async {
    final sentenceLabel = 'Sentence ${sentenceIndex + 1}';
    final confirmed = await _showDeleteConfirmation(
      title: 'Delete Media',
      message:
          'Remove this media attachment from $sentenceLabel? This cannot be undone.',
    );

    if (!confirmed) return;

    setState(() {
      _sentences[sentenceIndex].resources.removeAt(resourceIndex);
    });
  }

  Future<void> _handleDeleteDefinition(int index) async {
    if (_definitions.length == 1) {
      _showMinimumItemSnack('definition');
      return;
    }

    final confirmed = await _showDeleteConfirmation(
      title: 'Delete Definition',
      message:
          'Are you sure you want to delete Definition ${index + 1}? This cannot be undone.',
    );
    if (!confirmed) return;

    setState(() {
      final removed = _definitions.removeAt(index);
      removed.dispose();
    });
  }

  Future<void> _handleDeleteSentence(int index) async {
    if (_sentences.length == 1) {
      _showMinimumItemSnack('sentence');
      return;
    }

    final confirmed = await _showDeleteConfirmation(
      title: 'Delete Sentence',
      message:
          'Are you sure you want to delete Sentence ${index + 1}? This cannot be undone.',
    );
    if (!confirmed) return;

    setState(() {
      final removed = _sentences.removeAt(index);
      removed.dispose();
    });
  }

  void _showMinimumItemSnack(String item) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('At least one $item is required.')));
  }

  Future<bool> _showDeleteConfirmation({
    required String title,
    required String message,
  }) async {
    const brandBg = Color.fromARGB(255, 243, 255, 243);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: brandBg,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: brandGreen,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: brandGreen),
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
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        color: brandTint,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandGreen,
                  foregroundColor: Colors.white,
                ),
                onPressed: _handleSave,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_isEditing && _wordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a word.')));
      return;
    }

    final sanitizedDefinitions = _definitions
        .map((d) => d.toDefinition())
        .where((d) => d.text.isNotEmpty)
        .toList();
    final sanitizedSentences = _sentences
        .map((s) => s.toSentence())
        .where((s) => s.text.isNotEmpty)
        .toList();

    if (sanitizedDefinitions.isEmpty || sanitizedSentences.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least one definition and one sentence.'),
        ),
      );
      return;
    }

    final word = Word(
      text: widget.args?.word?.text ?? _wordController.text.trim(),
      definitions: sanitizedDefinitions,
      sentences: sanitizedSentences,
      resources: widget.args?.word?.resources ?? [],
    );

    try {
      await ref
          .read(packageNotifierProvider.notifier)
          .saveWord(word, originalWord: _isEditing ? widget.args?.word : null);
      if (!mounted) return;
      Navigator.of(context).pop(word);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save word: $error')));
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.count,
    required this.onAdd,
  });

  final String title;
  final int count;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$title ($count)',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        ),
      ],
    );
  }
}

class _DefinitionFormData {
  _DefinitionFormData({String definitionText = '', String sourceText = ''})
    : textController = TextEditingController(text: definitionText),
      sourceController = TextEditingController(text: sourceText);

  final TextEditingController textController;
  final TextEditingController sourceController;

  Definition toDefinition() => Definition(
    text: textController.text.trim(),
    source: sourceController.text.trim(),
  );

  void dispose() {
    textController.dispose();
    sourceController.dispose();
  }
}

class _DefinitionCard extends StatelessWidget {
  const _DefinitionCard({
    required this.index,
    required this.data,
    required this.onDelete,
  });

  final int index;
  final _DefinitionFormData data;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Definition $index',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Remove definition',
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: data.textController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Definition text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: data.sourceController,
              decoration: const InputDecoration(
                labelText: 'Source (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SentenceFormData {
  _SentenceFormData({String text = '', List<Resource>? resources})
    : textController = TextEditingController(text: text),
      resources = resources ?? [];

  final TextEditingController textController;
  List<Resource> resources;

  Sentence toSentence() => Sentence(
    text: textController.text.trim(),
    resources: List<Resource>.from(resources),
  );

  void dispose() {
    textController.dispose();
  }
}

class _SentenceCard extends StatelessWidget {
  const _SentenceCard({
    required this.index,
    required this.data,
    required this.onDelete,
    required this.onAttachMedia,
    required this.onRemoveMedia,
  });

  final int index;
  final _SentenceFormData data;
  final VoidCallback onDelete;
  final VoidCallback onAttachMedia;
  final ValueChanged<int> onRemoveMedia;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Sentence $index',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Remove sentence',
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: data.textController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Sentence text',
                border: OutlineInputBorder(),
              ),
            ),
            if (data.resources.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (int i = 0; i < data.resources.length; i++)
                    _MediaChip(
                      resource: data.resources[i],
                      onDelete: () => onRemoveMedia(i),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onAttachMedia,
                icon: const Icon(Icons.attach_file),
                label: const Text('Attach media'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaChip extends StatelessWidget {
  const _MediaChip({required this.resource, required this.onDelete});

  final Resource resource;
  final VoidCallback onDelete;

  String get _label => resource.title.isNotEmpty
      ? resource.title
      : resource.type.name.toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(_label),
      avatar: Icon(_iconForType(resource.type), size: 16),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onDelete,
    );
  }

  IconData _iconForType(ResourceType type) {
    switch (type) {
      case ResourceType.photo:
        return Icons.photo_outlined;
      case ResourceType.video:
        return Icons.videocam_outlined;
      case ResourceType.website:
        return Icons.language;
      default:
        return Icons.attach_file;
    }
  }
}
