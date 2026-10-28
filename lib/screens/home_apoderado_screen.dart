import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'welcome_screen.dart';

class HomeApoderadoScreen extends StatelessWidget {
  const HomeApoderadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apoderado')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenido, Apoderado', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () {}, child: const Text('Mis hijos')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () {}, child: const Text('Mi perfil')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signOut();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (r) => false,
                );
              },
              child: const Text('Cerrar sesion'),
            ),
          ],
        ),
      ),
    );
  }
}
