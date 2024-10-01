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
    apiKey: 'AIzaSyD5GQPvjs2JmymAfgoCId3nF1kb-006dAw',
    appId: '1:287989231:web:af77a6308ccba0cd462a1a',
    messagingSenderId: '287989231',
    projectId: 'safewings-sos',
    authDomain: 'safewings-sos.firebaseapp.com',
    storageBucket: 'safewings-sos.appspot.com',
    measurementId: 'G-F58T0MM391',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzSHXqAUJrDbr9a4mws8JM6LRa4fnaNXg',
    appId: '1:287989231:android:bce032936bf166e4462a1a',
    messagingSenderId: '287989231',
    projectId: 'safewings-sos',
    storageBucket: 'safewings-sos.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCy8D9YcHIHiF0K0VLfADU_S7AM_6dnZOc',
    appId: '1:287989231:ios:311ef8ec8468ce82462a1a',
    messagingSenderId: '287989231',
    projectId: 'safewings-sos',
    storageBucket: 'safewings-sos.appspot.com',
    iosBundleId: 'com.example.safeWings',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCy8D9YcHIHiF0K0VLfADU_S7AM_6dnZOc',
    appId: '1:287989231:ios:311ef8ec8468ce82462a1a',
    messagingSenderId: '287989231',
    projectId: 'safewings-sos',
    storageBucket: 'safewings-sos.appspot.com',
    iosBundleId: 'com.example.safeWings',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD5GQPvjs2JmymAfgoCId3nF1kb-006dAw',
    appId: '1:287989231:web:2cf6cea94bba82f1462a1a',
    messagingSenderId: '287989231',
    projectId: 'safewings-sos',
    authDomain: 'safewings-sos.firebaseapp.com',
    storageBucket: 'safewings-sos.appspot.com',
    measurementId: 'G-WLNN9GXGCE',
  );
}