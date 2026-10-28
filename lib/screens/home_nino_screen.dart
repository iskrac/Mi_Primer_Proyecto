import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'welcome_screen.dart';

class HomeNinoScreen extends StatelessWidget {
  const HomeNinoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nino / Alumno')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hola!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(onPressed: () {}, child: const Text('Mi perfil')),
            ElevatedButton(onPressed: () {}, child: const Text('Actividades')),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signOut();
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
