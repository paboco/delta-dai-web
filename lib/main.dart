import 'package:delta_dai_bim_/pages/admin/upload_model_page.dart';
import 'package:delta_dai_bim_/pages/models_page.dart';
import 'package:delta_dai_bim_/services/auth_guard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firebase_options.dart';
import 'package:delta_dai_bim_/pages/home_page.dart';
import 'package:delta_dai_bim_/pages/admin_page.dart';
// SERVICIOS

// PÁGINAS PÚBLICAS
import 'pages/login_page.dart';

// PÁGINAS ADMINISTRATIVAS (Dentro de la carpeta admin)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Quitamos el '#' de la URL
  usePathUrlStrategy();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

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
        '/models': (context) => ModelsPage(),

        // SECCIÓN PROTEGIDA: Aquí unifiqué tus rutas de admin
        // Se eliminó la duplicidad de '/admin' que causaba el error amarillo
        '/admin': (context) => const AuthGuard(child: AdminPage()),
        '/upload-model': (context) => const AuthGuard(child: UploadModelPage()),
      },
    );
  }
}
