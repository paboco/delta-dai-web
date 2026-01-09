import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 1. SI HAY USUARIO: Todo bien, pasa adelante.
        if (snapshot.hasData && snapshot.data != null) {
          return child;
        }

        // 2. SI NO HAY USUARIO:
        // En lugar de hacer un Navigator agresivo, mostramos una pantalla
        // de seguridad simple. Esto evita que el Stream "secuestre" la navegación.
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
                const SizedBox(height: 20),
                const Text(
                  "Acceso restringido",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text("Debes iniciar sesión para ver esta página."),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text("Ir al Login"),
                ),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                  child: const Text("Regresar al Inicio"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
