# 빠른 시작 가이드

## 전체 설정 순서

### 1. Firebase 설정 (필수)

#### A. google-services.json 다운로드
1. [Firebase Console](https://console.firebase.google.com/) → 프로젝트 `gns-app-45d6d`
2. 프로젝트 설정 → Android 앱 → `google-services.json` 다운로드
3. `android/app/google-services.json`에 배치

#### B. FlutterFire 설정
```bash
# Firebase CLI 설치 (한 번만)
npm install -g firebase-tools

# FlutterFire 설정
flutterfire configure --project=gns-app-45d6d --platforms=android
```

#### C. Firestore 생성
1. Firebase Console → Firestore Database
2. 데이터베이스 만들기 → 테스트 모드 → asia-northeast3
3. `buildKits` 컬렉션 생성 (임시 문서 하나 추가)

### 2. 앱 실행

```bash
flutter pub get
flutter run
```

### 3. 키트 데이터 추가

1. 앱 실행 후 "관리자" 클릭
2. 우측 상단 메뉴 (📦) → "키트 추가" 또는 "키트 일괄 추가"
3. 31개 키트 데이터 입력

### 4. 테스트

1. 홈 화면 → "예약하기"
2. 키트 선택 → 시간 선택 → 날짜/시간 선택 → 좌석 선택
3. 예약자 정보 입력 → 결제

## 문제 해결

### Firebase 연결 오류
- `google-services.json` 파일 위치 확인
- `firebase_options.dart` 파일 생성 확인
- Firestore 데이터베이스 생성 확인

### 키트 목록이 비어있음
- 관리자 화면에서 키트 추가
- Firestore의 `buildKits` 컬렉션 확인

### 빌드 오류
```bash
flutter clean
flutter pub get
flutter run
```
