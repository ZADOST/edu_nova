import 'dart:ui'; // FIX: Imported for ImageFilter
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/db/local_auth_db.dart';
import '../../../core/widgets/glass_container.dart';
import 'widgets/course_glass_card.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;

  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final authDb = LocalAuthDb(prefs);
    await authDb.clearSession();
    
    if (context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkCharcoal,
      body: CustomScrollView(
        slivers: [
          // 1. Animated Slivers App Bar
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.darkCharcoal,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: AppTheme.mintGlow),
                onPressed: () => _handleLogout(context),
                tooltip: 'Logout',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: const Text(
                'Welcome back, Student',
                style: TextStyle(
                  color: AppTheme.pureWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.deepTeal.withValues(alpha: 0.8), // FIX: Updated opacity
                      AppTheme.darkCharcoal,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -50,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: AppTheme.mintGlow.withValues(alpha: 0.05), // FIX: Updated opacity
                      ),
                    ),
                    Positioned(
                      left: 24,
                      top: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Spring Semester 2026',
                            style: TextStyle(
                              color: AppTheme.mintGlow,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GlassContainer(
                            blur: 5,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            borderRadius: BorderRadius.circular(12),
                            child: const Text(
                              'GPA: 3.85',
                              style: TextStyle(color: AppTheme.pureWhite, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Dashboard Content
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Quick Actions Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickAction(Icons.schedule, 'Schedule'),
                    _buildQuickAction(Icons.assignment, 'Grades'),
                    _buildQuickAction(Icons.receipt_long, 'Transcript'),
                    _buildQuickAction(Icons.person, 'Profile'),
                  ],
                ),
                const SizedBox(height: 32),

                // Section Title
                const Text(
                  'Today\'s Courses',
                  style: TextStyle(
                    color: AppTheme.pureWhite,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Course List (Mock Data for now)
                const CourseGlassCard(
                  courseName: 'Advanced Flutter Architecture',
                  instructor: 'Dr. Alan Turing',
                  time: '10:00 AM - 11:30 AM',
                  progress: 0.75,
                ),
                const CourseGlassCard(
                  courseName: 'Database Management Systems',
                  instructor: 'Prof. Grace Hopper',
                  time: '12:00 PM - 01:30 PM',
                  progress: 0.40,
                ),
                const CourseGlassCard(
                  courseName: 'Software Engineering Principles',
                  instructor: 'Dr. Ada Lovelace',
                  time: '02:00 PM - 03:30 PM',
                  progress: 0.90,
                ),
                const SizedBox(height: 80), // Padding for Bottom Nav
              ]),
            ),
          ),
        ],
      ),
      
      // Custom Floating Bottom Navigation Bar
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppTheme.darkCharcoal.withValues(alpha: 0.5), // FIX: Updated opacity
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // FIX: Now recognized because of dart:ui
            child: BottomNavigationBar(
              backgroundColor: AppTheme.deepTeal.withValues(alpha: 0.8), // FIX: Updated opacity
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.mintGlow,
              unselectedItemColor: AppTheme.pureWhite.withValues(alpha: 0.5), // FIX: Updated opacity
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Schedule'),
                BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Grades'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for Quick Actions
  Widget _buildQuickAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.deepTeal.withValues(alpha: 0.3), // FIX: Updated opacity
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.mintGlow.withValues(alpha: 0.3), width: 1), // FIX: Updated opacity
          ),
          child: Icon(icon, color: AppTheme.mintGlow, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.pureWhite.withValues(alpha: 0.8), // FIX: Updated opacity
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}