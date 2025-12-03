import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/utils/responsive_helper.dart';
import 'package:hikayati/core/widgets/loading_widget.dart';
import 'package:hikayati/core/widgets/error_display_widget.dart';
import 'package:hikayati/features/story_editor/presentation/providers/section_provider.dart';

class SectionEditor extends ConsumerStatefulWidget {
  final int storyId;
  final int? sectionId;

  const SectionEditor({super.key, required this.storyId, this.sectionId});

  @override
  ConsumerState<SectionEditor> createState() => _SectionEditorState();
}

class _SectionEditorState extends ConsumerState<SectionEditor> {
  final _textController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isSaving = false;

  bool get _isEditMode => widget.sectionId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(sectionNotifierProvider.notifier)
            .loadSection(widget.sectionId!);
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateControllers(String? text, String? imageUrl) {
    if (_textController.text != (text ?? '')) {
      _textController.text = text ?? '';
    }
    if (_imageUrlController.text != (imageUrl ?? '')) {
      _imageUrlController.text = imageUrl ?? '';
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Colors.green,
      ),
    );
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);

    try {
      if (_isEditMode) {
        await ref
            .read(sectionNotifierProvider.notifier)
            .updateSection(
              sectionId: widget.sectionId!,
              sectionText: _textController.text,
              imageUrl: _imageUrlController.text.isEmpty
                  ? null
                  : _imageUrlController.text,
            );
      } else {
        await ref
            .read(sectionNotifierProvider.notifier)
            .createSection(
              storyId: widget.storyId,
              sectionText: _textController.text,
              imageUrl: _imageUrlController.text.isEmpty
                  ? null
                  : _imageUrlController.text,
            );
      }

      if (mounted) {
        _showMessage('Section saved successfully');
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) Navigator.of(context).pop();
        });
      }
    } catch (e) {
      _showMessage('Failed to save: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sectionAsync = ref.watch(sectionNotifierProvider);

    ref.listen(sectionNotifierProvider, (_, next) {
      if (next case AsyncData(:final value) when value != null) {
        _updateControllers(value.sectionText, value.imageUrl);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Section' : 'Add Section'),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(onPressed: _handleSave, child: const Text('Save')),
        ],
      ),
      body: sectionAsync.when(
        data: (section) => section == null && _isEditMode
            ? const LoadingWidget(message: 'Loading section...')
            : _buildForm(),
        loading: () => const LoadingWidget(message: 'Loading section...'),
        error: (error, _) => ErrorDisplayWidget(
          message: 'Failed to load section: $error',
          onRetry: () {
            if (_isEditMode) {
              ref
                  .read(sectionNotifierProvider.notifier)
                  .loadSection(widget.sectionId!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildForm() {
    return ResponsivePadding.page(
      child: ListView(
        children: [
          TextFormField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Section Text',
              hintText: 'Once upon a time...',
              alignLabelWithHint: true,
            ),
            maxLines: null,
            minLines: 3,
            textAlignVertical: TextAlignVertical.top,
          ),
          ResponsiveGap.md(),
          Text(
            'Image URL (Optional)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ResponsiveGap.sm(),
          TextField(
            controller: _imageUrlController,
            decoration: const InputDecoration(
              hintText: 'Enter image URL',
              prefixIcon: Icon(Icons.image),
            ),
          ),
        ],
      ),
    );
  }
}
