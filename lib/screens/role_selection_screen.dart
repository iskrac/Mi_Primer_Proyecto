import 'package:flutter/material.dart';

import 'register_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _selectRole(BuildContext context, String rol) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RegisterScreen(rol: rol)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '¿Qué tipo de usuario eres?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectRole(context, 'Apoderado'),
              child: const Text('Apoderado'),
            ),
            ElevatedButton(
              onPressed: () => _selectRole(context, 'Niño'),
              child: const Text('Niño / Alumno'),
            ),
            ElevatedButton(
              onPressed: () => _selectRole(context, 'Dentista'),
              child: const Text('Dentista'),
            ),
          ],
        ),
      ),
    );
  }
}
