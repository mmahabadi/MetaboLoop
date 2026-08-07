import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/cycle/presentation/cycle_screen.dart';
import '../../features/home/presentation/main_shell.dart';
import '../../features/logging/presentation/barcode_scanner_screen.dart';
import '../../features/logging/presentation/custom_food_screen.dart';
import '../../features/logging/presentation/describe_screen.dart';
import '../../features/logging/presentation/quick_add_screen.dart';
import '../../features/logging/presentation/search_screen.dart';
import '../../features/logging/presentation/snap_screen.dart';
import '../../features/onboarding/presentation/activity_level_screen.dart';
import '../../features/onboarding/presentation/body_stats_screen.dart';
import '../../features/onboarding/presentation/goal_selection_screen.dart';
import '../../features/onboarding/presentation/macro_estimate_screen.dart';
import '../../features/onboarding/presentation/welcome_screen.dart';
import '../../features/paywall/presentation/paywall_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/recipes/presentation/recipe_list_screen.dart';
import '../../features/workouts/presentation/workouts_screen.dart';

abstract final class AppRoutes {
  static const welcome = '/onboarding/welcome';
  static const goal = '/onboarding/goal';
  static const bodyStats = '/onboarding/body-stats';
  static const activity = '/onboarding/activity';
  static const estimate = '/onboarding/estimate';
  static const signIn = '/onboarding/account';
  static const paywall = '/onboarding/paywall';
  static const home = '/';

  static const logSearch = '/log/search';
  static const logBarcode = '/log/barcode';
  static const logQuickAdd = '/log/quick-add';
  static const logSnap = '/log/snap';
  static const logDescribe = '/log/describe';
  static const logCustomFood = '/log/custom-food';
  static const recipes = '/recipes';
  static const progress = '/progress';
  static const cycle = '/cycle';
  static const workouts = '/workouts';
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
    GoRoute(
      path: AppRoutes.logSearch,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: AppRoutes.logBarcode,
      builder: (context, state) => const BarcodeScannerScreen(),
    ),
    GoRoute(
      path: AppRoutes.logQuickAdd,
      builder: (context, state) => const QuickAddScreen(),
    ),
    GoRoute(
      path: AppRoutes.logSnap,
      builder: (context, state) => const SnapScreen(),
    ),
    GoRoute(
      path: AppRoutes.logDescribe,
      builder: (context, state) => const DescribeScreen(),
    ),
    GoRoute(
      path: AppRoutes.logCustomFood,
      builder: (context, state) => const CustomFoodScreen(),
    ),
    GoRoute(
      path: AppRoutes.recipes,
      builder: (context, state) => const RecipeListScreen(),
    ),
    GoRoute(
      path: AppRoutes.progress,
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: AppRoutes.cycle,
      builder: (context, state) => const CycleScreen(),
    ),
    GoRoute(
      path: AppRoutes.workouts,
      builder: (context, state) => const WorkoutsScreen(),
    ),
  ],
);
