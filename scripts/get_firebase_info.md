# Firebase 설정 정보 가져오기

## Firebase Console에서 정보 확인 방법

### 1. Firebase Console 접속
https://console.firebase.google.com/

### 2. 프로젝트 선택
프로젝트 `gns-app-45d6d` 선택

### 3. 프로젝트 설정 열기
왼쪽 하단의 ⚙️ (톱니바퀴) 아이콘 클릭 → "프로젝트 설정"

### 4. 필요한 정보 확인

#### 일반 탭에서:
- **프로젝트 ID**: `gns-app-45d6d` (이미 알고 있음)
- **웹 API 키**: "일반" 섹션의 "웹 API 키" 복사
- **메시징 발신자 ID**: "클라우드 메시징" 섹션의 "발신자 ID" 복사

#### 내 앱 탭에서:
- Android 앱 선택
- **앱 ID**: "앱 ID" 복사
- **스토리지 버킷**: "스토리지 버킷" 또는 `gns-app-45d6d.appspot.com`

### 5. firebase_options.dart에 입력

`lib/firebase_options.dart` 파일을 열고:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: '여기에_웹_API_키_붙여넣기',
  appId: '여기에_앱_ID_붙여넣기',
  messagingSenderId: '여기에_발신자_ID_붙여넣기',
  projectId: 'gns-app-45d6d',
  storageBucket: 'gns-app-45d6d.appspot.com',
);
```

### 6. google-services.json 확인

`android/app/google-services.json` 파일이 있는지 확인
- 없으면: Firebase Console → 프로젝트 설정 → 내 앱 → Android 앱 → `google-services.json` 다운로드
