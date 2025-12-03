import 'package:flutter/material.dart';
import 'package:hikayati/core/entities/quiz.dart';
import 'package:hikayati/core/theme/app_theme.dart';

class OptionItem extends StatelessWidget {
  final int index;
  final QuizOption option;
  final TextEditingController controller;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onToggleCorrect;
  final VoidCallback onDelete;

  const OptionItem({
    super.key,
    required this.index,
    required this.option,
    required this.controller,
    required this.onTextChanged,
    required this.onToggleCorrect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCorrect = option.isCorrect;
    final letter = String.fromCharCode(65 + index); // A, B, C, D...

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppTheme.success.withValues(alpha: 0.1)
            : AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect ? AppTheme.success : AppTheme.grey300,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          _buildLetterBadge(theme, letter, isCorrect),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter option text...',
                border: InputBorder.none,
              ),
              onChanged: onTextChanged,
            ),
          ),
          IconButton(
            onPressed: onToggleCorrect,
            icon: Icon(
              isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCorrect ? AppTheme.success : AppTheme.grey400,
            ),
            tooltip: isCorrect ? 'Correct answer' : 'Mark as correct',
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.close),
            color: AppTheme.error,
            tooltip: 'Delete option',
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildLetterBadge(ThemeData theme, String letter, bool isCorrect) {
    return Container(
      margin: const EdgeInsets.all(12),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isCorrect ? AppTheme.success : AppTheme.grey300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          letter,
          style: theme.textTheme.titleSmall?.copyWith(
            color: isCorrect ? AppTheme.white : AppTheme.grey700,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
