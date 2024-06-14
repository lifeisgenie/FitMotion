// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB97X3e00vbr6GP1xuuQggw5RRoh_hKCo0',
    appId: '1:348050855923:web:1d0fff91ce3c21762ce486',
    messagingSenderId: '348050855923',
    projectId: 'fitmotion-a47b2',
    authDomain: 'fitmotion-a47b2.firebaseapp.com',
    storageBucket: 'fitmotion-a47b2.appspot.com',
    measurementId: 'G-6ZZB9E12TV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyABf8r9EcHFCNIFWfozJngVnB06GjPq7Xc',
    appId: '1:348050855923:android:787253590c6bb0792ce486',
    messagingSenderId: '348050855923',
    projectId: 'fitmotion-a47b2',
    storageBucket: 'fitmotion-a47b2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyByapalA4wybMep4NCOchr6pGEQcPSfE10',
    appId: '1:348050855923:ios:7a8bde879a89e3fc2ce486',
    messagingSenderId: '348050855923',
    projectId: 'fitmotion-a47b2',
    storageBucket: 'fitmotion-a47b2.appspot.com',
    iosBundleId: 'com.example.firstApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyByapalA4wybMep4NCOchr6pGEQcPSfE10',
    appId: '1:348050855923:ios:7a8bde879a89e3fc2ce486',
    messagingSenderId: '348050855923',
    projectId: 'fitmotion-a47b2',
    storageBucket: 'fitmotion-a47b2.appspot.com',
    iosBundleId: 'com.example.firstApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB97X3e00vbr6GP1xuuQggw5RRoh_hKCo0',
    appId: '1:348050855923:web:91a14efcc905811d2ce486',
    messagingSenderId: '348050855923',
    projectId: 'fitmotion-a47b2',
    authDomain: 'fitmotion-a47b2.firebaseapp.com',
    storageBucket: 'fitmotion-a47b2.appspot.com',
    measurementId: 'G-34XD5RB70W',
  );
}