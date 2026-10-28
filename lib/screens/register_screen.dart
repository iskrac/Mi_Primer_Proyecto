import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  final String rol;
  const RegisterScreen({super.key, required this.rol});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _rutCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();

  // Campos para Niño
  final _fechaNacCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();
  final _apoderadoIdCtrl = TextEditingController();
  String? _sexoSelected;

  bool _loading = false;

  void _registrar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      if (widget.rol == 'Niño') {
        await _authService.registerChild(
          email: _emailCtrl.text,
          password: _passCtrl.text,
          nombre: _nombreCtrl.text,
          apellido: _apellidoCtrl.text,
          fechaNacimiento: _fechaNacCtrl.text,
          edad: int.parse(_edadCtrl.text),
          sexo: _sexoSelected ?? 'Masculino',
          apoderadoId: _apoderadoIdCtrl.text,
        );
      } else {
        await _authService.registerUser(
          email: _emailCtrl.text,
          password: _passCtrl.text,
          nombre: _nombreCtrl.text,
          apellido: _apellidoCtrl.text,
          rut: _rutCtrl.text,
          telefono: _telefonoCtrl.text,
          rol: widget.rol,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('¡Registro exitoso!')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool esNino = widget.rol == 'Niño';

    return Scaffold(
      appBar: AppBar(title: Text('Registro: ${widget.rol}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (v) => v!.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _apellidoCtrl,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              if (!esNino) ...[
                TextFormField(
                  controller: _rutCtrl,
                  decoration: const InputDecoration(labelText: 'RUT'),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: _telefonoCtrl,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
              ],
              if (esNino) ...[
                TextFormField(
                  controller: _fechaNacCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Fecha Nacimiento (DD/MM/AAAA)',
                  ),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: _edadCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Edad (7 a 12 años)',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Requerido';
                    int? edad = int.tryParse(v);
                    if (edad == null || edad < 7 || edad > 12)
                      return 'Edad debe ser entre 7 y 12';
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _sexoSelected,
                  hint: const Text('Seleccionar Sexo'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Masculino',
                      child: Text('Masculino'),
                    ),
                    DropdownMenuItem(
                      value: 'Femenino',
                      child: Text('Femenino'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _sexoSelected = v),
                  validator: (v) => v == null ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: _apoderadoIdCtrl,
                  decoration: const InputDecoration(
                    labelText: 'ID / RUT del Apoderado',
                  ),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
              ],
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _registrar,
                      child: const Text('Registrar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
