import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../data/services/firebase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  void _login() async {
    if (_email.text.isEmpty || _pass.text.isEmpty) return;

    setState(() => _loading = true);
    final user = await FirebaseService().signIn(
      _email.text.trim(),
      _pass.text.trim(),
    );
    setState(() => _loading = false);

    if (user != null && mounted) {
      // REEMPLAZAR la ruta actual.
      // Así, si el usuario da "atrás" desde el Admin, irá al Home, no al Login.
      Navigator.pushReplacementNamed(context, '/admin');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Credenciales incorrectas")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black12)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "DELTA DAI BIM",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Admin Login", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: "Correo"),
              ),
              TextField(
                controller: _pass,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
              ),
              const SizedBox(height: 30),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "ENTRAR",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
