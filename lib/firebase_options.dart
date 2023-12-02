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
    apiKey: 'AIzaSyCdVuqKkkb7XJ0-M6RukL7dgVlME12Uhmw',
    appId: '1:776764532531:web:bcd7736dd272ef84efc046',
    messagingSenderId: '776764532531',
    projectId: 'fir-testing-820cd',
    authDomain: 'fir-testing-820cd.firebaseapp.com',
    storageBucket: 'fir-testing-820cd.appspot.com',
    measurementId: 'G-J94C94EWQB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAiBOCCDaPFUelDSGV4wTKJgyxJYNEutWA',
    appId: '1:776764532531:android:7ad7ba7bd3c4e4dcefc046',
    messagingSenderId: '776764532531',
    projectId: 'fir-testing-820cd',
    storageBucket: 'fir-testing-820cd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBo118Lrrt_DRiDwkImwSaH-R4SNXNDXfg',
    appId: '1:776764532531:ios:3c950755941bc0eaefc046',
    messagingSenderId: '776764532531',
    projectId: 'fir-testing-820cd',
    storageBucket: 'fir-testing-820cd.appspot.com',
    iosBundleId: 'com.example.firebaseTesting',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBo118Lrrt_DRiDwkImwSaH-R4SNXNDXfg',
    appId: '1:776764532531:ios:3c950755941bc0eaefc046',
    messagingSenderId: '776764532531',
    projectId: 'fir-testing-820cd',
    storageBucket: 'fir-testing-820cd.appspot.com',
    iosBundleId: 'com.example.firebaseTesting',
  );
}
