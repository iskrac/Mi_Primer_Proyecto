import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import 'welcome_screen.dart';

class HomeApoderadoScreen extends StatefulWidget {
  const HomeApoderadoScreen({super.key});

  @override
  State<HomeApoderadoScreen> createState() => _HomeApoderadoScreenState();
}

class _HomeApoderadoScreenState extends State<HomeApoderadoScreen> {
  final _childEmailController = TextEditingController();

  // Función para mostrar el formulario de perfil del Apoderado
  void _mostrarPerfil(
    BuildContext context,
    Map<String, dynamic> userData,
    String uid,
  ) {
    final nombreCtrl = TextEditingController(text: userData['nombre'] ?? '');
    final apellidoCtrl = TextEditingController(
      text: userData['apellido'] ?? '',
    );
    final rutCtrl = TextEditingController(text: userData['rut'] ?? '');
    final telefonoCtrl = TextEditingController(
      text: userData['telefono'] ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Mi Perfil de Apoderado'),
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
                  controller: rutCtrl,
                  decoration: const InputDecoration(
                    labelText: 'RUT',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: telefonoCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
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
                      'rut': rutCtrl.text.trim(),
                      'telefono': telefonoCtrl.text.trim(),
                    });

                if (!mounted) return;
                Navigator.pop(dialogContext);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '¡Perfil de apoderado actualizado con éxito!',
                    ),
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

  // Función para abrir el formulario de vinculación de hijo
  void _mostrarFormularioVincular(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Vincular Hijo/a'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ingresa el correo electrónico del niño registrado:'),
              const SizedBox(height: 12),
              TextField(
                controller: _childEmailController,
                decoration: const InputDecoration(
                  labelText: 'Correo del niño',
                  hintText: 'ejemplo@nino.com',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                String childEmail = _childEmailController.text.trim();
                if (childEmail.isEmpty) return;

                QuerySnapshot childQuery = await FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: childEmail)
                    .get();

                if (childQuery.docs.isEmpty) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'No se encontró ningún niño con ese correo',
                      ),
                    ),
                  );
                  return;
                }

                String childUid = childQuery.docs.first.id;
                String currentUid = FirebaseAuth.instance.currentUser!.uid;

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUid)
                    .update({'childId': childUid});

                if (!mounted) return;
                Navigator.pop(dialogContext);
                _childEmailController.clear();
                setState(() {});

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Niño vinculado exitosamente!'),
                  ),
                );
              },
              child: const Text('Vincular'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String? currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Apoderado')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              var userData =
                  snapshot.data?.data() as Map<String, dynamic>? ?? {};
              String childId = userData['childId'] ?? '';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Bienvenido, Apoderado',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Sección del hijo vinculado
                  childId.isEmpty
                      ? Card(
                          color: Colors.orange.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Aún no tienes ningún hijo vinculado.',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      _mostrarFormularioVincular(context),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Vincular un Hijo ahora'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(childId)
                              .get(),
                          builder: (context, childSnapshot) {
                            if (!childSnapshot.hasData ||
                                !childSnapshot.data!.exists) {
                              return const Text('El niño vinculado no existe.');
                            }

                            var childData =
                                childSnapshot.data!.data()
                                    as Map<String, dynamic>?;

                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.child_care),
                                ),
                                title: Text(
                                  'Hijo Vinculado: ${childData?['email'] ?? 'Niño'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Rol: ${childData?['role'] ?? 'Niño'}',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () =>
                                      _mostrarFormularioVincular(context),
                                ),
                              ),
                            );
                          },
                        ),

                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () =>
                        _mostrarPerfil(context, userData, currentUid ?? ''),
                    child: const Text('Mi perfil'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      await AuthService().signOut();
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
                    child: const Text('Cerrar sesión'),
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
