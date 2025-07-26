import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


    

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAz_0-xg3S8LE-jSTrSK-ybt6bp4krFwLo',
    appId: '1:253820942555:web:web-app-id-here',
    messagingSenderId: '253820942555',
    projectId: 'todo-list-bc1c5',
    authDomain: 'todo-list-bc1c5.firebaseapp.com',
    storageBucket: 'todo-list-bc1c5.firebasestorage.app',
  );

  // Android данные из google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxMv5pFd2gFYXl3_N1ohtevkWy2oCwW1Q',
    appId: '1:253820942555:android:03f240d54c90df756c34fe',
    messagingSenderId: '253820942555',
    projectId: 'todo-list-bc1c5',
    storageBucket: 'todo-list-bc1c5.firebasestorage.app',
  );

  // iOS данные из GoogleService-Info.plist
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAz_0-xg3S8LE-jSTrSK-ybt6bp4krFwLo',
    appId: '1:253820942555:ios:79969a6b5e20467e6c34fe',
    messagingSenderId: '253820942555',
    projectId: 'todo-list-bc1c5',
    storageBucket: 'todo-list-bc1c5.firebasestorage.app',
    iosBundleId: 'com.myself.todo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAz_0-xg3S8LE-jSTrSK-ybt6bp4krFwLo',
    appId: '1:253820942555:ios:79969a6b5e20467e6c34fe',
    messagingSenderId: '253820942555',
    projectId: 'todo-list-bc1c5',
    storageBucket: 'todo-list-bc1c5.firebasestorage.app',
    iosBundleId: 'com.myself.todo',
  );
}
