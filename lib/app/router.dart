// lib/app/router.dart
// Define todas as rotas do app usando go_router.
// ShellRoute agrupa rotas que compartilham o AppShell (bottom nav).

import 'package:go_router/go_router.dart';
import '../presentation/dashboard/dashboard_screen.dart';
import '../presentation/patients/patients_screen.dart';
import '../presentation/schedule/schedule_screen.dart';
import '../presentation/finance/finance_screen.dart';
import '../presentation/settings/settings_screen.dart';
import '../shared/widgets/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const DashboardScreen()),
        GoRoute(path: '/patients', builder: (context, state) => const PatientsScreen()),
        GoRoute(path: '/schedule', builder: (context, state) => const ScheduleScreen()),
        GoRoute(path: '/finance', builder: (context, state) => const FinanceScreen()),
        GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      ],
    ),
  ],
);
