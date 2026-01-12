# Firebase 설정 가이드

## 1. Firebase 프로젝트 생성

1. [Firebase Console](https://console.firebase.google.com/)에 접속
2. "프로젝트 추가" 클릭
3. 프로젝트 이름 입력 및 설정 완료

## 2. Android 앱 추가

1. Firebase 프로젝트에서 "Android 앱 추가" 클릭
2. 패키지 이름 입력: `com.example.gns_app_2026`
3. `google-services.json` 파일 다운로드
4. 다운로드한 파일을 `android/app/` 디렉토리에 복사

## 3. Firebase SDK 설정

### Android 설정

`android/build.gradle`에 이미 추가되어 있어야 함:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.4.0'
}
```

`android/app/build.gradle` 파일 하단에 추가:
```gradle
apply plugin: 'com.google.gms.google-services'
```

### Flutter 설정

1. FlutterFire CLI 설치:
```bash
dart pub global activate flutterfire_cli
```

2. Firebase 프로젝트 연결:
```bash
flutterfire configure
```

3. `lib/firebase_options.dart` 파일이 자동 생성됨

## 4. Firestore 데이터베이스 설정

1. Firebase Console에서 "Firestore Database" 생성
2. 테스트 모드로 시작 (나중에 보안 규칙 설정 필요)
3. `buildKits` 컬렉션 생성
4. `reservations` 컬렉션 생성

## 5. 빌드업 키트 데이터 추가

### 방법 1: Firebase Console에서 직접 추가
1. Firestore Database에서 `buildKits` 컬렉션 선택
2. "문서 추가" 클릭
3. 다음 필드 추가:
   - `theme` (string)
   - `brand` (string)
   - `productName` (string)
   - `partsCount` (number)
   - `image1` (string)
   - `image2` (string)
   - `image3` (string)
   - `image4` (string)

### 방법 2: 스크립트 사용
`scripts/add_build_kits.dart` 파일을 수정하여 실행

## 6. 보안 규칙 설정

Firestore 보안 규칙 예시:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 빌드업 키트는 모든 사용자가 읽기 가능
    match /buildKits/{kitId} {
      allow read: if true;
      allow write: if false; // 관리자만 수정 가능하도록 별도 설정
    }
    
    // 예약은 인증된 사용자만 읽기/쓰기 가능
    match /reservations/{reservationId} {
      allow read, write: if request.auth != null;
      // 또는 특정 조건 추가
    }
  }
}
```

## 7. 앱에서 Firebase 초기화

`lib/main.dart`에서 주석 해제:
```dart
await FirebaseInitService.initialize();
await FirebaseInitService.initializeBuildKits();
```
