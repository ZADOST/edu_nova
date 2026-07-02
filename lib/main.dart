import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/db/local_auth_db.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  // Ensure Flutter bindings are initialized before async DB operations
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode for consistent UI layout
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Local Database
  final localAuthDb = await LocalAuthDb.init();
  
  // Initialize Router
  final appRouter = AppRouter(localAuthDb);

  runApp(EduNovaApp(router: appRouter.router));
}

class EduNovaApp extends StatelessWidget {
  final RouterConfig<Object> router;

  const EduNovaApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Edu Nova',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}