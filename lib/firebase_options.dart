import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBFIRIq75VBLjxI7WwrEgpXrvA83np5IY',
    authDomain: 'happybee-e2914.firebaseapp.com',
    projectId: 'happybee-e2914',
    storageBucket: 'happybee-e2914.firebasestorage.app',
    messagingSenderId: '1082536493449',
    appId: '1:1082536493449:web:58d4ee7c977459885be158',
  );
}
