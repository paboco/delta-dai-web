import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firebase_options.dart';

// Importaciones de UI
import 'ui/client/home/pages/home_page.dart';
import 'ui/auth/pages/login_page.dart';
import 'ui/client/models/pages/models_page.dart';
import 'ui/client/projects/pages/projects_page.dart';
import 'ui/admin/pages/admin_page.dart';
import 'ui/shared/auth_guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Quita la '#' de la URL en la web
  usePathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

// ... tus imports se mantienen igual ...

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delta Dai BIM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFFAC1C1C),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/models': (context) => const ModelsPage(),
        '/projects': (context) => ProjectsPage(),
        // El Admin siempre envuelto por el guardia
        '/admin': (context) => const AuthGuard(child: AdminPage()),
      },
    );
  }
}
