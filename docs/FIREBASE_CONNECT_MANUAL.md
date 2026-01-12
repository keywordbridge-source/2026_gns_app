# Firebase 수동 연결 가이드

## 1단계: google-services.json 다운로드

1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 `gns-app-45d6d` 선택
3. 프로젝트 설정 (⚙️ 아이콘) 클릭
4. "내 앱" 섹션에서 Android 앱 확인
   - Android 앱이 없으면:
     - "Android 앱 추가" 클릭
     - 패키지 이름: `com.example.gns_app_2026` 입력
     - 앱 닉네임: `2026 GNS App` 입력
     - "앱 등록" 클릭
5. `google-services.json` 파일 다운로드
6. 다운로드한 파일을 `android/app/google-services.json` 위치에 복사

## 2단계: Firebase 설정 정보 확인

Firebase Console → 프로젝트 설정 → 일반 탭에서 다음 정보 확인:
- 프로젝트 ID: `gns-app-45d6d`
- 웹 API 키
- 앱 ID
- 메시징 발신자 ID
- 스토리지 버킷

## 3단계: firebase_options.dart 파일 생성

`lib/firebase_options.dart` 파일을 열고 아래 내용으로 교체:

```dart
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '여기에_웹_API_키_입력',
    appId: '여기에_앱_ID_입력',
    messagingSenderId: '여기에_메시징_발신자_ID_입력',
    projectId: 'gns-app-45d6d',
    storageBucket: '여기에_스토리지_버킷_입력',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '여기에_iOS_API_키_입력',
    appId: '여기에_iOS_앱_ID_입력',
    messagingSenderId: '여기에_메시징_발신자_ID_입력',
    projectId: 'gns-app-45d6d',
    storageBucket: '여기에_스토리지_버킷_입력',
    iosBundleId: 'com.example.gnsApp2026',
  );
}
```

**중요**: Firebase Console에서 실제 값으로 교체하세요!

## 4단계: 코드 활성화

`lib/services/firebase_init_service.dart` 파일에서 주석 해제:

```dart
import '../firebase_options.dart'; // 이 줄 주석 해제

// 그리고 initialize() 메서드에서:
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
// 이 부분 주석 해제하고 기본 초기화는 주석 처리
```

## 5단계: 확인

```bash
flutter pub get
flutter analyze
flutter run
```

앱 실행 시 "Firebase 초기화 완료" 메시지가 보이면 성공입니다!
