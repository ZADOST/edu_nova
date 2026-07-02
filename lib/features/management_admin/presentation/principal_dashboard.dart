import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/db/local_auth_db.dart';
import '../../../core/widgets/glass_container.dart';
import 'widgets/admin_module_card.dart';

class PrincipalDashboard extends StatelessWidget {
  const PrincipalDashboard({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final authDb = LocalAuthDb(prefs);
    await authDb.clearSession();
    if (context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkCharcoal,
      appBar: AppBar(
        title: const Text('Principal Control Center'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.mintGlow),
            onPressed: () => _handleLogout(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Executive Summary
            GlassContainer(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('System Status', style: TextStyle(color: AppTheme.mintGlow, fontSize: 14, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('All Systems Operational', style: TextStyle(color: AppTheme.pureWhite, fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Last synced: Just now', style: TextStyle(color: Colors.white60, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.mintGlow.withOpacity(0.2),
                    ),
                    child: const Icon(Icons.check_circle, color: AppTheme.mintGlow, size: 32),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),

            const Text('Institutional Modules', style: TextStyle(color: AppTheme.pureWhite, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Absolute Authority Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                AdminModuleCard(
                  title: 'Academic Records',
                  subtitle: 'Transcripts & Grades',
                  icon: Icons.school,
                  onTap: () {}, // Will route to full academic overview
                ),
                AdminModuleCard(
                  title: 'Financial Overview',
                  subtitle: 'Revenues & Installments',
                  icon: Icons.account_balance,
                  onTap: () => context.push('/accounting'), // Principal can view accounting
                ),
                AdminModuleCard(
                  title: 'Human Resources',
                  subtitle: 'Staff & Faculties',
                  icon: Icons.work,
                  onTap: () => context.push('/hr'), // Principal can view HR
                ),
                AdminModuleCard(
                  title: 'Student Roster',
                  subtitle: 'Profiles & Status',
                  icon: Icons.people,
                  onTap: () {}, 
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}