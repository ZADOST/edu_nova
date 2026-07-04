import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../db/local_auth_db.dart';
import '../theme/app_theme.dart';

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
      final bool isRoot = state.matchedLocation == '/'; 

      // If not logged in and not on login page, force to login
      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      // If logged in but trying to access the login page OR the root '/' path, 
      // intercept and redirect to the correct dashboard based on their role.
      if (loggedIn && (loggingIn || isRoot)) {
        final role = authDb.userRole;
        switch (role) {
          case 'student': return '/student';
          case 'teacher': return '/teacher';
          case 'assistant_principal': return '/assistant_principal';
          case 'principal': return '/principal';
          case 'accounting': return '/accounting';
          case 'hr': return '/hr';
          case 'alumni': return '/alumni';
          default: return '/login'; // Fallback
        }
      }

      return null; // No redirect needed
    },
    // Custom 404 Error Screen
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: AppTheme.darkCharcoal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 80),
            const SizedBox(height: 16),
            const Text(
              '404 - System Route Not Found',
              style: TextStyle(color: AppTheme.pureWhite, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'The requested module could not be located.',
              style: TextStyle(color: AppTheme.pureWhite.withValues(alpha: 0.6), fontSize: 14),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Return to Dashboard'),
            ),
          ],
        ),
      ),
    ),
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