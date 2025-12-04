import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hikayati/core/theme/app_theme.dart';
import 'package:hikayati/core/entities/quiz.dart';
import 'package:hikayati/core/entities/quiz_question.dart';
import 'package:hikayati/core/entities/quiz_option.dart';
import 'package:hikayati/features/quiz_editor/providers/quiz_provider.dart';
import 'package:hikayati/features/quiz_editor/widgets/quiz_top_bar.dart';
import 'package:hikayati/features/quiz_editor/widgets/quiz_empty_state.dart';
import 'package:hikayati/features/quiz_editor/widgets/question_editor_card.dart';
import 'package:hikayati/features/quiz_viewer/providers/quiz_provider.dart'
    as viewer;

class QuizEditor extends ConsumerStatefulWidget {
  final int storyId;

  const QuizEditor({super.key, required this.storyId});

  @override
  ConsumerState<QuizEditor> createState() => _QuizEditorState();
}

class _QuizEditorState extends ConsumerState<QuizEditor> {
  late List<Question> _questions;
  int? _quizId;
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

  void _markAsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.error),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppTheme.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String get _questionCountText {
    final count = _questions.length;
    return '$count Question${count != 1 ? 's' : ''}';
  }

  Widget _buildQuestionCount() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        _questionCountText,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.grey900,
        ),
      ),
    );
  }

  void _addQuestion() {
    HapticFeedback.mediumImpact();
    setState(() {
      _questions.add(
        Question(
          quizId: 0, // Will be set when saved
          text: '',
          options: [
            Option(text: '', isCorrect: true, questionId: 0),
            Option(text: '', isCorrect: false, questionId: 0),
          ],
          isMultiSelect: false,
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
      _showError('Please add at least one question');
      return false;
    }

    for (var i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      final questionNum = i + 1;

      if (question.text.trim().isEmpty) {
        _showError('Question $questionNum is empty');
        return false;
      }

      if (question.options.length < 2) {
        _showError('Question $questionNum needs at least 2 options');
        return false;
      }

      if (question.options.any((opt) => opt.text.trim().isEmpty)) {
        _showError('Question $questionNum has empty options');
        return false;
      }

      if (!question.options.any((opt) => opt.isCorrect)) {
        _showError('Question $questionNum needs at least one correct answer');
        return false;
      }
    }

    return true;
  }

  Future<bool> _saveQuiz({bool closeAfterSave = false}) async {
    if (!_validateQuiz()) return false;

    HapticFeedback.heavyImpact();
    final updatedQuiz = Quiz(
      id: _quizId,
      storyId: widget.storyId,
      questions: _questions,
    );

    try {
      await ref
          .read(quizNotifierProvider.notifier)
          .updateQuiz(widget.storyId, updatedQuiz);

      if (!mounted) return false;

      setState(() => _hasUnsavedChanges = false);

      // Invalidate quiz viewer provider to reload fresh data
      ref.invalidate(viewer.quizProvider(widget.storyId));

      if (closeAfterSave) {
        context.pop();
      } else {
        _showSuccess('Quiz saved successfully!');
      }
      return true;
    } catch (e) {
      if (mounted) {
        _showError('Failed to save quiz: $e');
      }
      return false;
    }
  }

  Future<void> _handleBack() async {
    if (await _onWillPop() && context.mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to quiz changes and update questions
    ref.listen(quizNotifierProvider, (previous, next) {
      next.whenData((quiz) {
        if (quiz != null && _questions.isEmpty) {
          setState(() {
            _quizId = quiz.id;
            _questions = quiz.questions.toList();
          });
        }
      });
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              QuizTopBar(
                hasUnsavedChanges: _hasUnsavedChanges,
                onBack: _handleBack,
                onSave: _saveQuiz,
              ),
              Expanded(
                child: _questions.isEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildQuestionCount(),
                            const QuizEmptyState(),
                          ],
                        ),
                      )
                    : _buildQuestionsList(),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildAddQuestionButton(),
      ),
    );
  }

  Widget _buildQuestionsList() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildQuestionCount()),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => QuestionEditorCard(
                key: ValueKey('question_$index'),
                questionNumber: index + 1,
                question: _questions[index],
                onChanged: (updatedQuestion) =>
                    _updateQuestion(index, updatedQuestion),
                onDelete: () => _deleteQuestion(index),
              ),
              childCount: _questions.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
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
