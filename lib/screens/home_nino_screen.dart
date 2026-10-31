import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';
import 'welcome_screen.dart';

class HomeNinoScreen extends StatefulWidget {
  const HomeNinoScreen({super.key});

  @override
  State<HomeNinoScreen> createState() => _HomeNinoScreenState();
}

class _HomeNinoScreenState extends State<HomeNinoScreen> {
  final AuthService _authService = AuthService();

  // Función para mostrar y editar el formulario de perfil del niño
  void _mostrarPerfil(
    BuildContext context,
    Map<String, dynamic> userData,
    String uid,
  ) {
    final nombreCtrl = TextEditingController(text: userData['nombre'] ?? '');
    final apellidoCtrl = TextEditingController(
      text: userData['apellido'] ?? '',
    );
    final edadCtrl = TextEditingController(
      text: userData['edad']?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Mi Perfil de Niño/a'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Correo: ${userData['email'] ?? ''}'),
                const SizedBox(height: 12),
                TextField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: apellidoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Apellido',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: edadCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Edad',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({
                      'nombre': nombreCtrl.text.trim(),
                      'apellido': apellidoCtrl.text.trim(),
                      'edad': int.tryParse(edadCtrl.text.trim()) ?? 0,
                    });

                if (!mounted) return;
                Navigator.pop(dialogContext);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Perfil actualizado con éxito!'),
                  ),
                );
              },
              child: const Text('Guardar cambios'),
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar la sección de Actividades del niño
  void _mostrarActividades(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Mis Actividades'),
          content: const SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text('Cepillado de dientes matutino'),
                  subtitle: Text('Estado: Completado'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.pending, color: Colors.orange),
                  title: Text('Cuestionario de hábitos'),
                  subtitle: Text('Estado: Pendiente'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Nino / Alumno')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              var userData =
                  snapshot.data?.data() as Map<String, dynamic>? ?? {};

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¡Hola!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bienvenido, ${userData['nombre'] ?? 'Estudiante'}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () =>
                        _mostrarPerfil(context, userData, uid ?? ''),
                    child: const Text('Mi perfil'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _mostrarActividades(context),
                    child: const Text('Actividades'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      await _authService.signOut();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WelcomeScreen(),
                        ),
                        (r) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                    ),
                    child: const Text('Cerrar sesion'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
