import 'package:flutter/material.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../db/local_auth_db.dart';

// Placeholder widgets for initial setup. 
// These will be replaced by actual feature presentation screens in later steps.

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});
  @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Student Dashboard')));
}
class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});
  @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Teacher Dashboard')));
}
class PrincipalAssistantDashboard extends StatelessWidget {
  const PrincipalAssistantDashboard({super.key});
  @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Assistant Principal Dashboard')));
}
class PrincipalDashboard extends StatelessWidget {
  const PrincipalDashboard({super.key});
  @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Principal Dashboard')));
}
class AccountingDashboard extends StatelessWidget {
  const AccountingDashboard({super.key});
  @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Accounting Dashboard')));
}
class HRDashboard extends StatelessWidget {
  const HRDashboard({super.key});
  @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('HR Dashboard')));
}
class AlumniDashboard extends StatelessWidget {
  const AlumniDashboard({super.key});
  @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Alumni Dashboard')));
}

class AppRouter {
  final LocalAuthDb authDb;

  AppRouter(this.authDb);

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    refreshListenable: _GoRouterRefreshStream(), // Listen to auth state changes here if using Riverpod/Bloc
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authDb.isLoggedIn;
      final bool loggingIn = state.matchedLocation == '/login';

      // If not logged in and not on login page, force to login
      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      // If logged in but trying to access login page, redirect to correct dashboard
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
          default: return '/login'; // Fallback
        }
      }

      return null; // No redirect needed
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

// Helper to refresh router on state change (can be expanded later with StreamController)
class _GoRouterRefreshStream extends ChangeNotifier {}