// Generated for Firebase project my-flutter-app-authen.
// Re-run `flutterfire configure` if you switch Firebase projects.
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
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for desktop. '
          'Use Android/iOS for Google Sign-In testing.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgLF_xIiV-enZbDHj3k3zPTfR6RUFQ7zo',
    appId: '1:743748519680:android:7da6cae74ba0b7ee5855e5',
    messagingSenderId: '743748519680',
    projectId: 'my-flutter-app-authen',
    storageBucket: 'my-flutter-app-authen.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgLF_xIiV-enZbDHj3k3zPTfR6RUFQ7zo',
    appId: '1:743748519680:android:7da6cae74ba0b7ee5855e5',
    messagingSenderId: '743748519680',
    projectId: 'my-flutter-app-authen',
    storageBucket: 'my-flutter-app-authen.firebasestorage.app',
    iosBundleId: 'com.example.mapApplication1',
  );

  static const FirebaseOptions macos = ios;

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDgLF_xIiV-enZbDHj3k3zPTfR6RUFQ7zo',
    appId: '1:743748519680:android:7da6cae74ba0b7ee5855e5',
    messagingSenderId: '743748519680',
    projectId: 'my-flutter-app-authen',
    authDomain: 'my-flutter-app-authen.firebaseapp.com',
    storageBucket: 'my-flutter-app-authen.firebasestorage.app',
  );

  /// Web OAuth client ID (client_type: 3) from google-services.json.
  /// Needed so Google Sign-In returns an ID token for Firebase Auth.
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue:
        '743748519680-68go81vbga738pduoutncegfdrs1d6sj.apps.googleusercontent.com',
  );
}
