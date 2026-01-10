import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/pages/login_page.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Mientras carga el estado de Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFAC1C1C)),
            ),
          );
        }

        // SI HAY USUARIO: Entregamos el AdminPage (child)
        if (snapshot.hasData && snapshot.data != null) {
          return child;
        }

        // SI NO HAY USUARIO: Mostramos la LoginPage
        // Al devolver el widget directamente aquí, evitamos bucles de navegación
        return const LoginPage();
      },
    );
  }
}
