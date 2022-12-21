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
    apiKey: 'AIzaSyC7BZ9ZpRTR47fsTKVPw2dDj4vcBXaxeJU',
    appId: '1:533178034853:web:71c5ecaa694542f7367b4c',
    messagingSenderId: '533178034853',
    projectId: 'images-f943f',
    authDomain: 'images-f943f.firebaseapp.com',
    storageBucket: 'images-f943f.appspot.com',
    measurementId: 'G-QXRBFMD3JD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbpi83MF7aGLcNvazzsI54NpjSY-Ff-FQ',
    appId: '1:533178034853:android:744d9f683f9a6b5c367b4c',
    messagingSenderId: '533178034853',
    projectId: 'images-f943f',
    storageBucket: 'images-f943f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBehJyByrd-9y70hZtZ9NPkNoXcSrZZvQc',
    appId: '1:533178034853:ios:be283def08e432a5367b4c',
    messagingSenderId: '533178034853',
    projectId: 'images-f943f',
    storageBucket: 'images-f943f.appspot.com',
    iosClientId: '533178034853-fu7b81kf1hb7jham9v0ouf9e26ka2mno.apps.googleusercontent.com',
    iosBundleId: 'com.example.imagePickerApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBehJyByrd-9y70hZtZ9NPkNoXcSrZZvQc',
    appId: '1:533178034853:ios:be283def08e432a5367b4c',
    messagingSenderId: '533178034853',
    projectId: 'images-f943f',
    storageBucket: 'images-f943f.appspot.com',
    iosClientId: '533178034853-fu7b81kf1hb7jham9v0ouf9e26ka2mno.apps.googleusercontent.com',
    iosBundleId: 'com.example.imagePickerApplication',
  );
}