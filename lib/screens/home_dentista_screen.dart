import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'welcome_screen.dart';

class HomeDentistaScreen extends StatelessWidget {
  const HomeDentistaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dentista')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenido, Doctor(a)', style: TextStyle(fontSize: 20)),
            ElevatedButton(
              onPressed: () {},
              child: const Text('[ Mi perfil ]'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('[ Pacientes ]'),
            ),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (r) => false,
                );
              },
              child: const Text('[ Cerrar sesión ]'),
            ),
          ],
        ),
      ),
    );
  }
}
