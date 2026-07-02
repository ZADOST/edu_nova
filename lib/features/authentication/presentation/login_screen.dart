import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/db/local_auth_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  late AnimationController _bgController;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  // Temporary dropdown variable for testing different roles
  String _selectedTestRole = 'student';
  final List<String> _roles = [
    'student', 'teacher', 'assistant_principal', 
    'principal', 'accounting', 'hr', 'alumni'
  ];

  @override
  void initState() {
    super.initState();
    // Dynamic breathing background animation
    _bgController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation1 = ColorTween(
      begin: AppTheme.darkCharcoal,
      end: AppTheme.deepTeal.withOpacity(0.5),
    ).animate(_bgController);

    _colorAnimation2 = ColorTween(
      begin: AppTheme.deepTeal.withOpacity(0.3),
      end: AppTheme.darkCharcoal,
    ).animate(_bgController);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // 1. Get the local DB instance
    final prefs = await SharedPreferences.getInstance();
    final authDb = LocalAuthDb(prefs);

    // 2. Simulate API login by saving the selected role to local storage
    await authDb.saveSession(
      token: 'dummy_token_123',
      role: _selectedTestRole,
      userId: 'user_001',
    );

    // 3. Trigger GoRouter to recalculate the redirect based on the new role
    if (mounted) {
      context.go('/'); // The router will intercept this and redirect to the correct dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_colorAnimation1.value!, _colorAnimation2.value!],
              ),
            ),
            child: child,
          );
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GlassContainer(
              height: 550,
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Title Area
                  const Icon(Icons.school_rounded, size: 64, color: AppTheme.mintGlow),
                  const SizedBox(height: 16),
                  const Text(
                    'EDU NOVA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.pureWhite,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Powered by ZAS TECH',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.mintGlow.withOpacity(0.8),
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Development Testing Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.deepTeal.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedTestRole,
                        dropdownColor: AppTheme.darkCharcoal,
                        icon: const Icon(Icons.arrow_drop_down, color: AppTheme.mintGlow),
                        style: const TextStyle(color: AppTheme.pureWhite),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedTestRole = newValue!;
                          });
                        },
                        items: _roles.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text('Simulate Login As: ${value.toUpperCase()}'),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: AppTheme.pureWhite),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined, color: AppTheme.mintGlow),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: AppTheme.pureWhite),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline, color: AppTheme.mintGlow),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Login Button
                  ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('SECURE LOGIN'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}