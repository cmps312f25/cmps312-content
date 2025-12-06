import 'package:go_router/go_router.dart';
import 'package:kalimati/features/auth/presentation/screens/login.dart';
import 'package:kalimati/features/package_editor/screens/package_editor.dart';
import 'package:kalimati/features/package_list/screens/package_list.dart';
import 'package:kalimati/features/package_editor/screens/manage_words_page.dart';
import 'package:kalimati/features/games/flashcards/flash_cards_screen.dart';
import 'package:kalimati/features/games/matching/screens/matching_screen.dart';
import 'package:kalimati/features/games/unscramble/unscramble_screen.dart';

class AppRouter {
  // static final home = (path: "/", name: "home", screen: MainPage());

  static final router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        name: "packagesDashboard",
        builder: (context, state) => PackageList(),
      ),
      GoRoute(
        path: "/manageWordsPage",
        name: "manageWordsPage",
        builder: (context, state) => ManageWordsPage(),
      ),
      /*       GoRoute(
        path: "/word-editor",
        name: "word-editor",
        builder: (context, state) => WordEditorFormPage(),
      ), */
      GoRoute(
        path: "/package-editor",
        name: "package-editor",
        builder: (context, state) => PackageEditor(),
      ),
      GoRoute(
        path: "/flashcards",
        name: "flashcards",
        builder: (context, state) => FlashCardsScreen(),
      ),
      GoRoute(
        path: "/matching",
        name: "matching",
        builder: (context, state) => MatchingScreen(),
      ),
      GoRoute(
        path: "/unscramble",
        name: "unscramble",
        builder: (context, state) => UnscrambleScreen(),
      ),
      GoRoute(path: "/login", builder: (context, state) => LoginPage()),
    ],
  );
}
