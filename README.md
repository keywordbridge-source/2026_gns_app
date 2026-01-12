# 2026 GNS App

Flutter로 개발된 2026 GNS App입니다.

## 프로젝트 개요

2026 GNS App은 Flutter 프레임워크를 사용하여 개발된 크로스 플랫폼 모바일 애플리케이션입니다.

## 시작하기

### 필수 요구사항

- Flutter SDK (버전 3.0.0 이상)
- Dart SDK (Flutter와 함께 설치됨)
- Android Studio 또는 VS Code (선택사항)
- Android SDK (Android 개발용)
- Xcode (iOS 개발용, macOS만 해당)

### Flutter 설치

Flutter가 설치되어 있지 않다면 [Flutter 공식 웹사이트](https://flutter.dev/docs/get-started/install)에서 설치 가이드를 참고하세요.

### 설치

프로젝트 의존성을 설치합니다:

```bash
flutter pub get
```

### 실행

#### 모든 플랫폼에서 사용 가능한 디바이스 확인
```bash
flutter devices
```

#### 앱 실행
```bash
flutter run
```

#### 특정 디바이스에서 실행
```bash
flutter run -d <device-id>
```

### 빌드

#### Android APK 빌드
```bash
flutter build apk
```

#### Android App Bundle 빌드
```bash
flutter build appbundle
```

#### iOS 빌드 (macOS만 가능)
```bash
flutter build ios
```

#### Web 빌드
```bash
flutter build web
```

## 프로젝트 구조

```
lib/
  main.dart          # 앱 진입점
test/
  widget_test.dart   # 위젯 테스트
android/             # Android 플랫폼 코드
ios/                 # iOS 플랫폼 코드
web/                 # Web 플랫폼 코드
```

## 개발

### 코드 포맷팅
```bash
flutter format .
```

### 코드 분석
```bash
flutter analyze
```

### 테스트 실행
```bash
flutter test
```

## Git 저장소

이 프로젝트는 다음 GitHub 저장소와 연결되어 있습니다:
https://github.com/keywordbridge-source/2026_gns_app.git

## 라이선스

MIT
