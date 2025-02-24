import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:vocary/resources/screens/collection_detail_screen.dart';
import 'package:vocary/resources/screens/collection_list_words_screen.dart';
import 'package:vocary/resources/screens/home_screen.dart';
import 'package:vocary/resources/screens/navbar.dart';
import 'package:vocary/resources/screens/practice_screen.dart';
import 'package:vocary/resources/screens/splash_screen.dart';
import 'package:vocary/resources/screens/onboarding_screen.dart';
import 'package:vocary/resources/screens/profile_screen.dart';
import 'package:vocary/resources/screens/review_screen.dart';
import 'package:vocary/resources/screens/sign_in_screen.dart';
import 'package:vocary/resources/screens/word_detail_screen.dart';
import 'package:vocary/router/routes.dart';

GoRoute transitionGoRoute({
  required String path,
  required Widget Function(BuildContext, GoRouterState) pageBuilder,
}) {
  return GoRoute(
    path: path,
    pageBuilder:
        (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 200),
          child: pageBuilder(context, state),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeIn).animate(animation),
              child: child,
            );
          },
        ),
  );
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // No-auth routes
      transitionGoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => const SplashScreen(),
      ),
      transitionGoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => const OnboardingScreen(),
      ),
      transitionGoRoute(
        path: AppRoutes.signIn,
        pageBuilder: (context, state) => const SignInScreen(),
      ),

      // Authenticated routes inside Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => NavBar(child: child),
        routes: [
          transitionGoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const HomeScreen(),
          ),
          transitionGoRoute(
            path: AppRoutes.collectionDetail,
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'];
              return CollectionDetailScreen(collectionId: id!);
            },
          ),
          transitionGoRoute(
            path: AppRoutes.collectionListWords,
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'];
              return CollectionListWordsScreen(collectionId: id!);
            },
          ),
          transitionGoRoute(
            path: AppRoutes.wordDetail,
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'];
              return WordDetailScreen(wordId: id!);
            },
          ),
          transitionGoRoute(
            path: AppRoutes.practice,
            pageBuilder: (context, state) {
              return PracticeScreen();
            },
          ),
          transitionGoRoute(
            path: AppRoutes.review,
            pageBuilder: (context, state) => const ReviewScreen(),
          ),
          transitionGoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
