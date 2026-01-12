// Firebase 설정 파일
// Firebase Console에서 정보를 가져와서 아래 값들을 채워주세요

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Android 설정 - google-services.json에서 자동 추출된 값
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAg7AEMBpm7bvVxA5cfQcCFnU2riNVfjfA',
    appId: '1:87443577978:android:86f4a08f06f105883aefc3',
    messagingSenderId: '87443577978',
    projectId: 'brick-reserve',
    storageBucket: 'brick-reserve.firebasestorage.app',
  );

  // iOS 설정 (Android만 사용하므로 임시 값)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'gns-app-45d6d',
    storageBucket: 'gns-app-45d6d.appspot.com',
    iosBundleId: 'com.example.gnsApp2026',
  );
}
