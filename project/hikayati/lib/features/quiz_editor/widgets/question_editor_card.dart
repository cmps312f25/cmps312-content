import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hikayati/core/entities/quiz.dart';
import 'package:hikayati/core/theme/app_theme.dart';
import 'package:hikayati/features/quiz_editor/widgets/option_item.dart';

class QuestionEditorCard extends StatefulWidget {
  final int questionNumber;
  final Question question;
  final ValueChanged<Question> onChanged;
  final VoidCallback onDelete;

  const QuestionEditorCard({
    super.key,
    required this.questionNumber,
    required this.question,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<QuestionEditorCard> createState() => _QuestionEditorCardState();
}

class _QuestionEditorCardState extends State<QuestionEditorCard> {
  late TextEditingController _questionController;
  late List<TextEditingController> _optionControllers;
  late List<QuizOption> _options;
  late bool _allowMultipleAnswers;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question.question);
    _options = widget.question.options.toList();
    _allowMultipleAnswers = widget.question.allowMultipleAnswers;
    _optionControllers = _options
        .map((option) => TextEditingController(text: option.text))
        .toList();
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _notifyChanged() {
    widget.onChanged(
      Question(
        question: _questionController.text,
        options: _options,
        allowMultipleAnswers: _allowMultipleAnswers,
      ),
    );
  }

  void _addOption() {
    HapticFeedback.lightImpact();
    setState(() {
      _options.add(QuizOption(text: '', isCorrect: false));
      _optionControllers.add(TextEditingController());
    });
    _notifyChanged();
  }

  void _deleteOption(int index) {
    if (_options.length <= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A question must have at least 2 options'),
          backgroundColor: AppTheme.error,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    HapticFeedback.lightImpact();
    setState(() {
      _options.removeAt(index);
      _optionControllers[index].dispose();
      _optionControllers.removeAt(index);
    });
    _notifyChanged();
  }

  void _toggleCorrect(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_allowMultipleAnswers) {
        // Multiple answers allowed - toggle this option
        _options[index] = QuizOption(
          text: _options[index].text,
          isCorrect: !_options[index].isCorrect,
        );
      } else {
        // Single answer only - uncheck all others
        _options = _options.asMap().entries.map((entry) {
          return QuizOption(
            text: entry.value.text,
            isCorrect: entry.key == index,
          );
        }).toList();
      }
    });
    _notifyChanged();
  }

  void _updateOptionText(int index, String text) {
    setState(() {
      _options[index] = QuizOption(
        text: text,
        isCorrect: _options[index].isCorrect,
      );
    });
    _notifyChanged();
  }

  void _showDeleteDialog() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Delete Question?'),
        content: const Text('Are you sure you want to delete this question?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
              widget.onDelete();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildHeader(theme), if (_isExpanded) _buildContent(theme)],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryPurple.withOpacity(0.1),
              AppTheme.accentPink.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          children: [
            _buildQuestionBadge(theme),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _questionController.text.isEmpty
                    ? 'New Question'
                    : _questionController.text,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.grey900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _showDeleteDialog,
              icon: const Icon(Icons.delete_outline),
              color: AppTheme.error,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionBadge(ThemeData theme) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryPurple, AppTheme.accentPink],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          '${widget.questionNumber}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppTheme.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionInput(),
          const SizedBox(height: 20),
          _buildMultipleAnswersToggle(theme),
          const SizedBox(height: 20),
          Text(
            'Answer Options',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.grey900,
            ),
          ),
          const SizedBox(height: 12),
          ..._buildOptions(),
          const SizedBox(height: 12),
          _buildAddOptionButton(theme),
        ],
      ),
    );
  }

  Widget _buildQuestionInput() {
    return TextField(
      controller: _questionController,
      decoration: InputDecoration(
        labelText: 'Question',
        hintText: 'Enter your question here...',
        prefixIcon: const Icon(Icons.help_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: AppTheme.grey50,
      ),
      maxLines: 3,
      onChanged: (value) {
        setState(() {});
        _notifyChanged();
      },
    );
  }

  Widget _buildMultipleAnswersToggle(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.grey50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _allowMultipleAnswers ? AppTheme.accentPink : AppTheme.grey200,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _allowMultipleAnswers
                  ? AppTheme.accentPink
                  : AppTheme.grey400,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check_box, color: AppTheme.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Multiple Correct Answers',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.grey900,
                  ),
                ),
                Text(
                  'Allow selecting multiple answers',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.grey600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _allowMultipleAnswers,
            onChanged: (value) {
              setState(() {
                _allowMultipleAnswers = value;
                if (!value) {
                  // Ensure only one correct answer
                  final firstCorrect = _options.indexWhere(
                    (opt) => opt.isCorrect,
                  );
                  if (firstCorrect != -1) {
                    _options = _options.asMap().entries.map((e) {
                      return QuizOption(
                        text: e.value.text,
                        isCorrect: e.key == firstCorrect,
                      );
                    }).toList();
                  }
                }
              });
              _notifyChanged();
              HapticFeedback.lightImpact();
            },
            activeThumbColor: AppTheme.accentPink,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOptions() {
    return _options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;
      return OptionItem(
        key: ValueKey('option_$index'),
        index: index,
        option: option,
        controller: _optionControllers[index],
        onTextChanged: (text) => _updateOptionText(index, text),
        onToggleCorrect: () => _toggleCorrect(index),
        onDelete: () => _deleteOption(index),
      );
    }).toList();
  }

  Widget _buildAddOptionButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _addOption,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: AppTheme.primaryPurple, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.add, color: AppTheme.primaryPurple),
        label: Text(
          'Add Option',
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppTheme.primaryPurple,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
