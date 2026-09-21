import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_controller.dart';
import '../features/auth/code_screen.dart';
import '../features/auth/interests_screen.dart';
import '../features/auth/email_screen.dart';
import '../features/auth/welcome_screen.dart';
import '../features/compose/compose_screen.dart';
import '../features/compose/spark_screen.dart';
import '../features/feed/feed_screen.dart';
import '../features/feed/submission_screen.dart';
import '../features/profile/edit_profile_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/settings_screen.dart';
import '../features/shell/tab_shell.dart';
import '../features/today/today_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// Every page is a [CupertinoPage] so the interactive back-swipe keeps working.
/// Creation is a `fullscreenDialog` — it is a mode, not a destination.
CustomTransitionPage<T> _fade<T>(Widget child, GoRouterState state) =>
    CustomTransitionPage<T>(
      key: state.pageKey,
      opaque: true,
      transitionDuration: const Duration(milliseconds: 320),
      child: child,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ValueNotifier<AuthStatus>(AuthStatus.unknown);
  ref.listen(
    authControllerProvider.select((s) => s.status),
    (_, next) => auth.value = next,
    fireImmediately: true,
  );
  ref.onDispose(auth.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/today',
    refreshListenable: auth,
    redirect: (context, state) {
      final status = auth.value;
      if (status == AuthStatus.unknown) return null;
      final onAuthRoute = state.matchedLocation.startsWith('/welcome') ||
          state.matchedLocation.startsWith('/auth');
      if (status == AuthStatus.signedOut) return onAuthRoute ? null : '/welcome';
      if (onAuthRoute && !state.matchedLocation.startsWith('/auth/crafts')) {
        return '/today';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/welcome',
        pageBuilder: (c, s) => _fade(const WelcomeScreen(), s),
      ),
      GoRoute(
        path: '/auth/email',
        pageBuilder: (c, s) => CupertinoPage(key: s.pageKey, child: const EmailScreen()),
      ),
      GoRoute(
        path: '/auth/code',
        pageBuilder: (c, s) => CupertinoPage(key: s.pageKey, child: const CodeScreen()),
      ),
      GoRoute(
        path: '/auth/crafts',
        pageBuilder: (c, s) => CupertinoPage(key: s.pageKey, child: const InterestsScreen()),
      ),

      // Compose and The Spark live above the tab bar: full-screen, undistracted.
      GoRoute(
        path: '/compose',
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => CupertinoPage(
          key: s.pageKey,
          fullscreenDialog: true,
          child: const ComposeScreen(),
        ),
      ),
      GoRoute(
        path: '/spark',
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _fade(
          SparkScreen(streakDays: int.tryParse(s.uri.queryParameters['day'] ?? '') ?? 1),
          s,
        ),
      ),
      GoRoute(
        path: '/u/:username',
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => CupertinoPage(
          key: s.pageKey,
          child: ProfileScreen(username: s.pathParameters['username']),
        ),
      ),
      GoRoute(
        path: '/s/:id',
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => CupertinoPage(
          key: s.pageKey,
          child: SubmissionScreen(submissionId: s.pathParameters['id']!),
        ),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => TabShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/today',
              pageBuilder: (c, s) => const NoTransitionPage(child: TodayScreen()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/feed',
              pageBuilder: (c, s) => const NoTransitionPage(child: FeedScreen()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/you',
              pageBuilder: (c, s) => const NoTransitionPage(child: ProfileScreen()),
              routes: [
                GoRoute(
                  path: 'settings',
                  pageBuilder: (c, s) =>
                      CupertinoPage(key: s.pageKey, child: const SettingsScreen()),
                ),
                GoRoute(
                  path: 'interests',
                  pageBuilder: (c, s) => CupertinoPage(
                    key: s.pageKey,
                    child: const InterestsScreen(isOnboarding: false),
                  ),
                ),
                GoRoute(
                  path: 'edit',
                  pageBuilder: (c, s) => CupertinoPage(
                    key: s.pageKey,
                    fullscreenDialog: true,
                    child: const EditProfileScreen(),
                  ),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
});
