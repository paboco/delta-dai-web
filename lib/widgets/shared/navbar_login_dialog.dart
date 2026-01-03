import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../services/firebase_service.dart';

class NavbarLoginDialog extends StatefulWidget {
  const NavbarLoginDialog({super.key});

  @override
  State<NavbarLoginDialog> createState() => _NavbarLoginDialogState();
}

class _NavbarLoginDialogState extends State<NavbarLoginDialog> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _service = FirebaseService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Acceso Administrativo"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: "Correo"),
          ),
          TextField(
            controller: _passCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Contraseña"),
          ),
          if (_isLoading) const LinearProgressIndicator(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("CANCELAR"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
          ),
          onPressed: _isLoading ? null : _handleLogin,
          child: const Text("ENTRAR", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _handleLogin() async {
    setState(() => _isLoading = true);
    var user = await _service.signIn(
      _emailCtrl.text.trim(),
      _passCtrl.text.trim(),
    );
    setState(() => _isLoading = false);

    if (user != null) {
      if (mounted) {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/admin');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Credenciales incorrectas")),
        );
      }
    }
  }
}
