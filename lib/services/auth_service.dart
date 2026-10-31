import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Obtener usuario actual
  User? get currentUser => _auth.currentUser;

  // Iniciar Sesión (Soporta nulo si falla)
  Future<String?> login(String email, String password) async {
    UserCredential res = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    DocumentSnapshot doc = await _db
        .collection('users')
        .doc(res.user!.uid)
        .get();
    if (doc.exists) {
      return doc['rol'] as String?;
    }
    return null;
  }

  // Registrar Apoderado o Dentista
  Future<void> registerUser({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required String rut,
    required String telefono,
    required String rol,
    String? especialidad,
    String? numRegistro,
  }) async {
    UserCredential res = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    Map<String, dynamic> userData = {
      'uid': res.user!.uid,
      'nombre': nombre,
      'apellido': apellido,
      'rut': rut,
      'email': email.trim(),
      'telefono': telefono,
      'rol': rol,
      'fechaRegistro': FieldValue.serverTimestamp(),
    };

    if (rol == 'Dentista') {
      userData['especialidad'] = especialidad;
      userData['numRegistro'] = numRegistro;
    }

    await _db.collection('users').doc(res.user!.uid).set(userData);
  }

  // Registrar Niño (Relacionado con Apoderado)
  Future<void> registerChild({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required String fechaNacimiento,
    required int edad,
    required String sexo,
    required String apoderadoId,
  }) async {
    UserCredential res = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await _db.collection('users').doc(res.user!.uid).set({
      'uid': res.user!.uid,
      'nombre': nombre,
      'apellido': apellido,
      'email': email.trim(),
      'rol': 'Niño',
      'fechaRegistro': FieldValue.serverTimestamp(),
    });

    await _db.collection('children').doc(res.user!.uid).set({
      'childId': res.user!.uid,
      'nombre': nombre,
      'apellido': apellido,
      'fechaNacimiento': fechaNacimiento,
      'edad': edad,
      'sexo': sexo,
      'apoderadoId': apoderadoId,
    });
  }

  // Cerrar Sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
