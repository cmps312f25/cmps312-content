import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hikayati/core/theme/app_theme.dart';
import 'package:hikayati/core/entities/quiz.dart';
import 'package:hikayati/features/quiz_editor/presentation/providers/quiz_provider.dart';
import 'package:hikayati/features/quiz_editor/presentation/widgets/quiz_top_bar.dart';
import 'package:hikayati/features/quiz_editor/presentation/widgets/quiz_settings_card.dart';
import 'package:hikayati/features/quiz_editor/presentation/widgets/quiz_empty_state.dart';
import 'package:hikayati/features/quiz_editor/presentation/widgets/question_editor_card.dart';

class QuizEditor extends ConsumerStatefulWidget {
  final int storyId;

  const QuizEditor({super.key, required this.storyId});

  @override
  ConsumerState<QuizEditor> createState() => _QuizEditorState();
}

class _QuizEditorState extends ConsumerState<QuizEditor> {
  late List<Question> _questions;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _questions = [];

    // Load quiz data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quizNotifierProvider.notifier).loadQuiz(widget.storyId);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _markAsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  void _addQuestion() {
    HapticFeedback.mediumImpact();
    setState(() {
      _questions.add(
        Question(
          question: '',
          options: [
            QuizOption(text: '', isCorrect: true),
            QuizOption(text: '', isCorrect: false),
          ],
          allowMultipleAnswers: false,
        ),
      );
    });
    _markAsChanged();
  }

  void _deleteQuestion(int index) {
    HapticFeedback.mediumImpact();
    setState(() {
      _questions.removeAt(index);
    });
    _markAsChanged();
  }

  void _updateQuestion(int index, Question updatedQuestion) {
    setState(() {
      _questions[index] = updatedQuestion;
    });
    _markAsChanged();
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) {
      return true;
    }

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Unsaved Changes',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'You have unsaved changes. What would you like to do?',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop('cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop('discard'),
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            child: const Text('Discard'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop('save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: AppTheme.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == 'save') {
      return await _saveQuiz(closeAfterSave: true);
    } else if (result == 'discard') {
      return true;
    }
    return false;
  }

  bool _validateQuiz() {
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one question'),
          backgroundColor: AppTheme.error,
        ),
      );
      return false;
    }

    for (int i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      if (question.question.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Question ${i + 1} is empty'),
            backgroundColor: AppTheme.error,
          ),
        );
        return false;
      }

      if (question.options.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Question ${i + 1} needs at least 2 options'),
            backgroundColor: AppTheme.error,
          ),
        );
        return false;
      }

      if (question.options.any((opt) => opt.text.trim().isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Question ${i + 1} has empty options'),
            backgroundColor: AppTheme.error,
          ),
        );
        return false;
      }

      if (!question.options.any((opt) => opt.isCorrect)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Question ${i + 1} needs at least one correct answer',
            ),
            backgroundColor: AppTheme.error,
          ),
        );
        return false;
      }
    }

    return true;
  }

  Future<bool> _saveQuiz({bool closeAfterSave = false}) async {
    if (!_validateQuiz()) return false;

    HapticFeedback.heavyImpact();
    final updatedQuiz = Quiz(questions: _questions);

    try {
      await ref
          .read(quizNotifierProvider.notifier)
          .updateQuiz(widget.storyId, updatedQuiz);

      if (mounted) {
        setState(() => _hasUnsavedChanges = false);

        if (closeAfterSave) {
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppTheme.white),
                  const SizedBox(width: 12),
                  const Text('Quiz saved successfully!'),
                ],
              ),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save quiz: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to quiz changes and update questions
    ref.listen(quizNotifierProvider, (previous, next) {
      next.whenData((quiz) {
        if (quiz != null && _questions.isEmpty) {
          setState(() => _questions = quiz.questions.toList());
        }
      });
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await _onWillPop() && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              QuizTopBar(
                hasUnsavedChanges: _hasUnsavedChanges,
                onBack: () async {
                  if (await _onWillPop() && context.mounted) {
                    context.pop();
                  }
                },
                onSave: _saveQuiz,
              ),
              Expanded(
                child: _questions.isEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            QuizSettingsCard(questionCount: _questions.length),
                            const QuizEmptyState(),
                          ],
                        ),
                      )
                    : CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: QuizSettingsCard(
                              questionCount: _questions.length,
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                return QuestionEditorCard(
                                  key: ValueKey('question_$index'),
                                  questionNumber: index + 1,
                                  question: _questions[index],
                                  onChanged: (updatedQuestion) =>
                                      _updateQuestion(index, updatedQuestion),
                                  onDelete: () => _deleteQuestion(index),
                                );
                              }, childCount: _questions.length),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 100),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildAddQuestionButton(),
      ),
    );
  }

  Widget _buildAddQuestionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [AppTheme.accentYellow, AppTheme.accentYellowLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _addQuestion,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle, color: AppTheme.grey900, size: 24),
                SizedBox(width: 12),
                Text(
                  'Add Question',
                  style: TextStyle(
                    color: AppTheme.grey900,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
