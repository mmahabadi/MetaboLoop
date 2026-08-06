import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/home/presentation/main_shell.dart';
import '../../features/onboarding/presentation/activity_level_screen.dart';
import '../../features/onboarding/presentation/body_stats_screen.dart';
import '../../features/onboarding/presentation/goal_selection_screen.dart';
import '../../features/onboarding/presentation/macro_estimate_screen.dart';
import '../../features/onboarding/presentation/welcome_screen.dart';
import '../../features/paywall/presentation/paywall_screen.dart';

abstract final class AppRoutes {
  static const welcome = '/onboarding/welcome';
  static const goal = '/onboarding/goal';
  static const bodyStats = '/onboarding/body-stats';
  static const activity = '/onboarding/activity';
  static const estimate = '/onboarding/estimate';
  static const signIn = '/onboarding/account';
  static const paywall = '/onboarding/paywall';
  static const home = '/';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.welcome,
  routes: [
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.goal,
      builder: (context, state) => const GoalSelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.bodyStats,
      builder: (context, state) => const BodyStatsScreen(),
    ),
    GoRoute(
      path: AppRoutes.activity,
      builder: (context, state) => const ActivityLevelScreen(),
    ),
    GoRoute(
      path: AppRoutes.estimate,
      builder: (context, state) => const MacroEstimateScreen(),
    ),
    GoRoute(
      path: AppRoutes.signIn,
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: AppRoutes.paywall,
      builder: (context, state) => const PaywallScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const MainShell(),
    ),
  ],
);
