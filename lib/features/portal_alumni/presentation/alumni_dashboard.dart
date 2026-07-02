import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/db/local_auth_db.dart';
import '../../../core/widgets/glass_container.dart';
import '../data/alumni_repository.dart';
import 'widgets/event_glass_card.dart';

class AlumniDashboard extends StatefulWidget {
  const AlumniDashboard({super.key});

  @override
  State<AlumniDashboard> createState() => _AlumniDashboardState();
}

class _AlumniDashboardState extends State<AlumniDashboard> {
  final AlumniRepository _repository = AlumniRepository();
  List<AlumniEvent> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final events = await _repository.fetchUpcomingEvents();
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

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
        title: const Text('Alumni Network'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.mintGlow),
            onPressed: () => _handleLogout(context),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.mintGlow))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Digital ID Card
                  GlassContainer(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppTheme.darkCharcoal,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.mintGlow, width: 2),
                          ),
                          child: const Icon(Icons.workspace_premium, color: AppTheme.mintGlow, size: 32),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Class of 2025', style: TextStyle(color: AppTheme.mintGlow, fontSize: 14, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('Computer Education', style: TextStyle(color: AppTheme.pureWhite, fontSize: 18, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('Status: Verified Alumni', style: TextStyle(color: Colors.white60, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Quick Services
                  Row(
                    children: [
                      Expanded(
                        child: _buildServiceButton(
                          icon: Icons.description,
                          label: 'Request\nTranscript',
                          onTap: () {}, // Action to trigger document request
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildServiceButton(
                          icon: Icons.card_membership,
                          label: 'Digital\nDiploma',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildServiceButton(
                          icon: Icons.volunteer_activism,
                          label: 'Mentorship\nProgram',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  const Text('Upcoming Events', style: TextStyle(color: AppTheme.pureWhite, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Dynamic Events List
                  ..._events.map((event) => EventGlassCard(event: event)).toList(),
                ],
              ),
            ),
    );
  }

  Widget _buildServiceButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.mintGlow, size: 28),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.pureWhite, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}