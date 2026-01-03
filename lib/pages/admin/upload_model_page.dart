import 'package:flutter/material.dart';

class UploadModelPage extends StatefulWidget {
  const UploadModelPage({super.key});

  @override
  State<UploadModelPage> createState() => _UploadModelPageState();
}

class _UploadModelPageState extends State<UploadModelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subir Nuevo Modelo")),
      body: const Center(
        child: Text("Aquí irá el formulario con nombre, descripción y fotos"),
      ),
    );
  }
}
