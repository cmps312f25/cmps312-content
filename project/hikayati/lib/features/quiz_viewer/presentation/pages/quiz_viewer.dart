import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/theme/app_theme.dart';
import 'package:hikayati/core/entities/quiz.dart';
import 'package:hikayati/features/quiz_viewer/presentation/widgets/quiz_score_indicator.dart';
import 'package:hikayati/features/quiz_viewer/presentation/widgets/quiz_progress_bar.dart';
import 'package:hikayati/features/quiz_viewer/presentation/widgets/quiz_question_card.dart';
import 'package:hikayati/features/quiz_viewer/presentation/widgets/quiz_navigation_buttons.dart';
import 'package:hikayati/features/quiz_viewer/presentation/widgets/quiz_completion_view.dart';

class QuizViewer extends ConsumerStatefulWidget {
  final Quiz quiz;
  final int storyId;

  const QuizViewer({super.key, required this.quiz, required this.storyId});

  @override
  ConsumerState<QuizViewer> createState() => _QuizViewerState();
}

class _QuizViewerState extends ConsumerState<QuizViewer> {
  int _currentQuestionIndex = 0;
  late Map<int, dynamic> _userAnswers;
  late Map<int, bool> _submittedQuestions;
  bool _quizCompleted = false;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  @override
  void initState() {
    super.initState();
    _userAnswers = {};
    _submittedQuestions = {};
  }

  void _selectOption(int optionIndex) {
    if (!(_submittedQuestions[_currentQuestionIndex] ?? false)) {
      final question = widget.quiz.questions[_currentQuestionIndex];

      setState(() {
        if (question.allowMultipleAnswers) {
          final currentAnswers =
              _userAnswers[_currentQuestionIndex] as Set<int>?;
          if (currentAnswers == null) {
            _userAnswers[_currentQuestionIndex] = {optionIndex};
          } else {
            if (currentAnswers.contains(optionIndex)) {
              currentAnswers.remove(optionIndex);
            } else {
              currentAnswers.add(optionIndex);
            }
          }
        } else {
          _userAnswers[_currentQuestionIndex] = optionIndex;
        }
      });
      HapticFeedback.lightImpact();
    }
  }

  bool _hasSelectedAnswer() {
    final answer = _userAnswers[_currentQuestionIndex];
    if (answer == null) return false;
    if (answer is Set<int>) return answer.isNotEmpty;
    return true;
  }

  bool _isOptionSelected(int optionIndex) {
    final answer = _userAnswers[_currentQuestionIndex];
    if (answer == null) return false;
    if (answer is Set<int>) return answer.contains(optionIndex);
    return answer == optionIndex;
  }

  bool _isAnswerCorrect(int questionIndex) {
    final answer = _userAnswers[questionIndex];
    if (answer == null) return false;

    final question = widget.quiz.questions[questionIndex];
    if (question.allowMultipleAnswers) {
      final selectedIndices = answer as Set<int>;
      final correctIndices = question.options
          .asMap()
          .entries
          .where((entry) => entry.value.isCorrect)
          .map((entry) => entry.key)
          .toSet();
      return selectedIndices.length == correctIndices.length &&
          selectedIndices.every((i) => correctIndices.contains(i));
    } else {
      return question.options[answer as int].isCorrect;
    }
  }

  void _nextQuestion() {
    if (!_hasSelectedAnswer()) return;

    final isAlreadySubmitted =
        _submittedQuestions[_currentQuestionIndex] ?? false;

    if (!isAlreadySubmitted) {
      setState(() {
        _submittedQuestions[_currentQuestionIndex] = true;
        if (_isAnswerCorrect(_currentQuestionIndex)) {
          _correctAnswers++;
          HapticFeedback.mediumImpact();
        } else {
          _wrongAnswers++;
          HapticFeedback.heavyImpact();
        }
      });
      return;
    }

    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _userAnswers = {};
      _submittedQuestions = {};
      _quizCompleted = false;
      _correctAnswers = 0;
      _wrongAnswers = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (_currentQuestionIndex + 1) / widget.quiz.questions.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryPurple,
        elevation: 0,
        foregroundColor: AppTheme.white,
        title: Text(
          'Quiz',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppTheme.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          QuizScoreIndicator(
            correctAnswers: _correctAnswers,
            wrongAnswers: _wrongAnswers,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryPurple, AppTheme.primaryPurpleLight],
          ),
        ),
        child: SafeArea(
          child: _quizCompleted
              ? QuizCompletionView(
                  correctAnswers: _correctAnswers,
                  wrongAnswers: _wrongAnswers,
                  totalQuestions: widget.quiz.questions.length,
                  onRestart: _restartQuiz,
                )
              : _buildQuizView(progress),
        ),
      ),
    );
  }

  Widget _buildQuizView(double progress) {
    final question = widget.quiz.questions[_currentQuestionIndex];
    final isQuestionSubmitted =
        _submittedQuestions[_currentQuestionIndex] ?? false;

    return Column(
      children: [
        QuizProgressBar(
          currentQuestion: _currentQuestionIndex + 1,
          totalQuestions: widget.quiz.questions.length,
          progress: progress,
        ),
        Expanded(
          child: QuizQuestionCard(
            question: question,
            isSubmitted: isQuestionSubmitted,
            isOptionSelected: _isOptionSelected,
            onSelectOption: _selectOption,
          ),
        ),
        QuizNavigationButtons(
          hasSelectedAnswer: _hasSelectedAnswer(),
          isLastQuestion:
              _currentQuestionIndex == widget.quiz.questions.length - 1,
          isQuestionSubmitted: isQuestionSubmitted,
          canGoBack: _currentQuestionIndex > 0,
          onNext: _nextQuestion,
          onPrevious: _previousQuestion,
        ),
      ],
    );
  }
}
