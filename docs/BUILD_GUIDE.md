# 빌드 가이드

## Debug APK 빌드

```bash
flutter pub get
flutter analyze
flutter build apk --debug
```

빌드된 APK 위치: `build/app/outputs/flutter-apk/app-debug.apk`

## Release APK 빌드

### 1. Keystore 생성

#### Windows:
```cmd
scripts\generate_keystore.bat
```

#### Linux/Mac:
```bash
bash scripts/generate_keystore.sh
```

또는 수동으로:
```bash
keytool -genkey -v -keystore android/app/gns_app_2026.keystore \
  -alias gns_app_2026 \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

### 2. key.properties 파일 생성

1. `android/key.properties.example` 파일을 `android/key.properties`로 복사
2. 실제 비밀번호와 경로 입력:
```properties
storePassword=실제_스토어_비밀번호
keyPassword=실제_키_비밀번호
keyAlias=gns_app_2026
storeFile=app/gns_app_2026.keystore
```

**중요**: `key.properties` 파일은 절대 Git에 커밋하지 마세요!

### 3. Release APK 빌드

```bash
flutter build apk --release
```

빌드된 APK 위치: `build/app/outputs/flutter-apk/app-release.apk`

## App Bundle 빌드 (Play Store용)

```bash
flutter build appbundle --release
```

빌드된 AAB 위치: `build/app/outputs/bundle/release/app-release.aab`

## 빌드 검증

빌드 후 다음 명령어로 검증:
```bash
flutter pub get
flutter analyze
flutter build apk --debug
```

모든 명령어가 성공해야 합니다.

## 문제 해결

### Java 버전 오류
- JDK 17 설치 확인
- JAVA_HOME 환경 변수 설정

### Gradle 오류
- `android/gradle/wrapper/gradle-wrapper.properties`에서 Gradle 버전 확인
- JDK 17과 호환되는 Gradle 8.3 이상 사용

### Keystore 오류
- `key.properties` 파일이 올바른 위치에 있는지 확인
- 비밀번호가 정확한지 확인
- keystore 파일 경로가 올바른지 확인
