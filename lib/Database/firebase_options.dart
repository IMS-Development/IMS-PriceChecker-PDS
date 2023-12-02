import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7hLzfwzO9IQ8c3hja1gbHihGSMSt1tCM',
    appId: '1:346805857052:android:3334c7ba583557580ce8d9',
    messagingSenderId: '346805857052',
    projectId: 'pds-rms-version',
    databaseURL:
    'https://pds-rms-version-default-rtdb.firebaseio.com',
    storageBucket: 'pds-rms-version.appspot.com',
  );
}