import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_apoderado_screen.dart';
import 'home_nino_screen.dart';
import 'home_dentista_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final AuthService _auth = AuthService();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? rol = await _auth.login(_emailCtrl.text, _passCtrl.text);

        if (!mounted) return;

        if (rol == 'Apoderado') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeApoderadoScreen()),
          );
        } else if (rol == 'Niño') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeNinoScreen()),
          );
        } else if (rol == 'Dentista') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeDentistaScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rol de usuario no reconocido.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciales inválidas o error de conexión.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                validator: (v) =>
                    v!.isEmpty ? 'Ingrese su correo electrónico.' : null,
              ),
              TextFormField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (v) => v!.isEmpty ? 'Ingrese su contraseña.' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _login, child: const Text('INGRESAR')),
            ],
          ),
        ),
      ),
    );
  }
}
