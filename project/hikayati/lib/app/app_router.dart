import 'package:hikayati/features/story_viewer/pages/story_viewer.dart';
import 'package:hikayati/features/quiz_viewer/providers/story_quiz_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:hikayati/features/auth/presentation/pages/signin_screen.dart';
import 'package:hikayati/features/auth/presentation/pages/signup_screen.dart';
import 'package:hikayati/features/story_list/pages/stroy_list_page.dart';
import 'package:hikayati/features/story_editor/pages/story_editor.dart';
import 'package:hikayati/features/quiz_viewer/pages/quiz_viewer.dart';
import 'package:hikayati/features/story_editor/pages/section_editor.dart';
import 'package:hikayati/features/quiz_editor/pages/quiz_editor.dart';

/// Provider for GoRouter
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      // Routes outside the main navigation shell
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),

      GoRoute(
        path: '/story/:id',
        builder: (context, state) =>
            StoryViewer(storyId: int.parse(state.pathParameters['id']!)),
        routes: [
          GoRoute(
            path: 'quiz',
            builder: (context, state) {
              final storyId = int.parse(state.pathParameters['id']!);

              return Consumer(
                builder: (context, ref, _) {
                  final quizAsync = ref.watch(storyQuizProvider(storyId));

                  return quizAsync.when(
                    data: (quiz) {
                      if (quiz == null) {
                        return Scaffold(
                          appBar: AppBar(title: const Text('Quiz')),
                          body: const Center(
                            child: Text('No quiz available for this story'),
                          ),
                        );
                      }
                      return QuizViewer(quiz: quiz, storyId: storyId);
                    },
                    loading: () => const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, _) => Scaffold(
                      appBar: AppBar(title: const Text('Quiz')),
                      body: Center(child: Text('Error loading quiz: $error')),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) => const StoryListPage(),
      ),
      GoRoute(
        path: '/story-editor/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return StoryEditor(
            storyId: id == null || id == 'new' ? null : int.parse(id),
          );
        },
      ),
      GoRoute(
        path: '/section-editor/:storyId', // Route for adding a new section
        builder: (context, state) =>
            SectionEditor(storyId: int.parse(state.pathParameters['storyId']!)),
      ),
      GoRoute(
        path:
            '/section-editor/:storyId/:sectionId', // Route for editing an existing section
        builder: (context, state) => SectionEditor(
          storyId: int.parse(state.pathParameters['storyId']!),
          sectionId: int.parse(state.pathParameters['sectionId']!),
        ),
      ),
      GoRoute(
        path: '/quiz-editor/:storyId',
        builder: (context, state) =>
            QuizEditor(storyId: int.parse(state.pathParameters['storyId']!)),
      ),
    ],
  );
});
