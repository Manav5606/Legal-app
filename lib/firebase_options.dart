// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyASW-G6L4r6qLOdX3m7rD05C8jMazwwwtY',
    appId: '1:763789981693:web:506ac48e43cb6384b54b94',
    messagingSenderId: '763789981693',
    projectId: 'legaldemo-87a20',
    authDomain: 'legaldemo-87a20.firebaseapp.com',
    storageBucket: 'legaldemo-87a20.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBFCpBIx8v8G-QHU7PLcjK3HsefTFkkF7Y',
    appId: '1:763789981693:android:050ac3d6252e8b77b54b94',
    messagingSenderId: '763789981693',
    projectId: 'legaldemo-87a20',
    storageBucket: 'legaldemo-87a20.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbv5ggqWKXmikFq58SNgGrDrFuomF1e_8',
    appId: '1:763789981693:ios:5cd883aa11126902b54b94',
    messagingSenderId: '763789981693',
    projectId: 'legaldemo-87a20',
    storageBucket: 'legaldemo-87a20.appspot.com',
    iosClientId: '763789981693-ovgojibq9anabu0e3knvmm8fgmrpdfdj.apps.googleusercontent.com',
    iosBundleId: 'com.example.legalapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCbv5ggqWKXmikFq58SNgGrDrFuomF1e_8',
    appId: '1:763789981693:ios:5cd883aa11126902b54b94',
    messagingSenderId: '763789981693',
    projectId: 'legaldemo-87a20',
    storageBucket: 'legaldemo-87a20.appspot.com',
    iosClientId: '763789981693-ovgojibq9anabu0e3knvmm8fgmrpdfdj.apps.googleusercontent.com',
    iosBundleId: 'com.example.legalapp',
  );
}
