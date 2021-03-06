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
    apiKey: 'AIzaSyDB_xYhVIzNXfsEebbJ7cPIxbn4DZEZyvU',
    appId: '1:1058043953021:web:d54fa7334edef017be5614',
    messagingSenderId: '1058043953021',
    projectId: 'bigdata-18b08',
    authDomain: 'bigdata-18b08.firebaseapp.com',
    storageBucket: 'bigdata-18b08.appspot.com',
    measurementId: 'G-R35QTR9P4H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBynX66H9xKlFbrjkC_fpUp2AkM5yhzeiw',
    appId: '1:1058043953021:android:08abd2977cf902bebe5614',
    messagingSenderId: '1058043953021',
    projectId: 'bigdata-18b08',
    storageBucket: 'bigdata-18b08.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBqJJ1kzHRNrkHM3Eocj_v_FziD2z8bN_o',
    appId: '1:1058043953021:ios:7ee4eda5e106fc99be5614',
    messagingSenderId: '1058043953021',
    projectId: 'bigdata-18b08',
    storageBucket: 'bigdata-18b08.appspot.com',
    iosClientId: '1058043953021-fm3u2mig339k0g95mhkm431voketpsga.apps.googleusercontent.com',
    iosBundleId: 'com.ruson.bigdata.bigdata',
  );
}
