import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBFIRiQq75VBLjxI7WwrEgpXrvA83np5IY",
    appId: '1:1082536493449:web:58d4ee7c977459885be158',
    messagingSenderId: '1082536493449',
    projectId: 'happybee-e2914',
    authDomain: 'happybee-e2914.firebaseapp.com',
    storageBucket: 'happybee-e2914.firebasestorage.app',
  );
}
