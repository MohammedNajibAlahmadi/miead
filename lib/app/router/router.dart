import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/main_shell_screen.dart';

import '../../features/prayer/presentation/screens/prayer_screen.dart';
import '../../features/prayer/presentation/screens/qibla_compass_screen.dart';
import '../../features/timer/presentation/screens/focus_screen.dart';
import '../../features/alarms/presentation/screens/alarms_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/adhkar/presentation/screens/adhkar_screen.dart';
import '../../features/heritage/presentation/screens/friday_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/statistics/presentation/screens/statistics_screen.dart';
import '../../features/notes/presentation/screens/notes_screen.dart';
import '../../features/settings/presentation/bloc/settings_cubit.dart';
import '../../app/dependency_injection/di.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) {
    final isFirstRun = getIt<SettingsCubit>().state.isFirstRun;
    final goingToOnboarding = state.uri.path == '/onboarding';
    
    // If it's the first run and we are not already going to onboarding, send them there.
    if (isFirstRun && !goingToOnboarding) {
      return '/onboarding';
    }
    
    // If it's not the first run but they are trapped in onboarding, send them home.
    if (!isFirstRun && goingToOnboarding) {
      return '/';
    }
    
    return null; // no redirect
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/statistics',
      builder: (context, state) => const StatisticsScreen(),
    ),
    GoRoute(
      path: '/notes',
      builder: (context, state) => const NotesScreen(),
    ),
    GoRoute(
      path: '/adhkar',
      builder: (context, state) => const AdhkarScreen(),
    ),
    GoRoute(
      path: '/friday',
      builder: (context, state) => const FridayScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainShellScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/prayer',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const PrayerScreen(),
        ),
        GoRoute(
          path: '/focus',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const FocusScreen(),
        ),
        GoRoute(
          path: '/alarms',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const AlarmsScreen(),
        ),
        GoRoute(
          path: '/settings',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
