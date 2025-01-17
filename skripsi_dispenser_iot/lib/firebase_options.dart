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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD4Z9vpCpdrDBAgSM81CXQAOSxIUd2Ufxg',
    appId: '1:12309150803:web:2d7285e2d050df313f5aa6',
    messagingSenderId: '12309150803',
    projectId: 'dispenser-iot-225c2',
    authDomain: 'dispenser-iot-225c2.firebaseapp.com',
    databaseURL: 'https://dispenser-iot-225c2-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'dispenser-iot-225c2.appspot.com',
    measurementId: 'G-65VGNVZ903',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhAQokXYthad2RTwav0F1RvzpXOlREpk4',
    appId: '1:12309150803:android:fc38d06d49b9f6c13f5aa6',
    messagingSenderId: '12309150803',
    projectId: 'dispenser-iot-225c2',
    databaseURL: 'https://dispenser-iot-225c2-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'dispenser-iot-225c2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDIXE8kzOq_jeVa6xiSy-Fc8TtPbw2hIXM',
    appId: '1:12309150803:ios:2f11df8411df16f13f5aa6',
    messagingSenderId: '12309150803',
    projectId: 'dispenser-iot-225c2',
    databaseURL: 'https://dispenser-iot-225c2-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'dispenser-iot-225c2.appspot.com',
    iosBundleId: 'com.example.skripsiDispenserIot',
  );
}
