import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../db/local_auth_db.dart';

// Importing all 7 role-based dashboards
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/dashboard_student/presentation/student_dashboard.dart';
import '../../features/dashboard_teacher/presentation/teacher_dashboard.dart';
import '../../features/management_admin/presentation/assistant_dashboard.dart';
import '../../features/management_admin/presentation/principal_dashboard.dart';
import '../../features/management_finance/presentation/accounting_dashboard.dart';
import '../../features/management_hr/presentation/hr_dashboard.dart';
import '../../features/portal_alumni/presentation/alumni_dashboard.dart';

class AppRouter {
  final LocalAuthDb authDb;

  AppRouter(this.authDb);

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    refreshListenable: _GoRouterRefreshStream(),
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authDb.isLoggedIn;
      final bool loggingIn = state.matchedLocation == '/login';

      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      if (loggedIn && loggingIn) {
        final role = authDb.userRole;
        switch (role) {
          case 'student': return '/student';
          case 'teacher': return '/teacher';
          case 'assistant_principal': return '/assistant_principal';
          case 'principal': return '/principal';
          case 'accounting': return '/accounting';
          case 'hr': return '/hr';
          case 'alumni': return '/alumni';
          default: return '/login';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/student',
        builder: (context, state) => const StudentDashboard(),
      ),
      GoRoute(
        path: '/teacher',
        builder: (context, state) => const TeacherDashboard(),
      ),
      GoRoute(
        path: '/assistant_principal',
        builder: (context, state) => const PrincipalAssistantDashboard(),
      ),
      GoRoute(
        path: '/principal',
        builder: (context, state) => const PrincipalDashboard(),
      ),
      GoRoute(
        path: '/accounting',
        builder: (context, state) => const AccountingDashboard(),
      ),
      GoRoute(
        path: '/hr',
        builder: (context, state) => const HRDashboard(),
      ),
      GoRoute(
        path: '/alumni',
        builder: (context, state) => const AlumniDashboard(),
      ),
    ],
  );
}

class _GoRouterRefreshStream extends ChangeNotifier {}