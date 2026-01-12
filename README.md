# 2026 GNS App - 레고 브릭 빌드업 예약 시스템

Flutter로 개발된 레고 브릭 빌드업 예약 시스템입니다.

## 프로젝트 개요

회사가 직영하는 커피매장에서 레고브릭을 빌드업 할 수 있도록 예약시스템을 제공하는 모바일 애플리케이션입니다.

## 기술 스택

- **Flutter**: 크로스 플랫폼 프레임워크
- **Riverpod**: 상태 관리
- **Firebase**: 백엔드 (Firestore, Authentication)
- **GoRouter**: 네비게이션
- **Iamport**: 결제 시스템

## 개발 환경

- Flutter 버전: 고정 (변경 불가)
- JDK 버전: 17
- 패키지명: `com.example.gns_app_2026` (변경 불가)
- 상태관리: Riverpod
- 대상 플랫폼: Android (APK / Play Store)

## 주요 기능

### 1. 예약 플로우
- 빌드업 키트 선택 (31개)
- 이용시간 선택 (1시간/2시간/4시간)
- 날짜 및 시작시간 선택 (오전 9시 ~ 오후 5시)
- 좌석 선택 (시간당 10자리)
- 예약자 정보 입력 (이름, 휴대전화 인증, 비밀번호 4자리)
- 아임포트 결제

### 2. 내 예약
- 예약자 이름/비밀번호로 로그인
- 예약 확인 및 취소
- 취소 수수료 계산 (3일전 무료, 2일전 20%, 1일전 50%, 당일 100%)

### 3. 관리자 환경
- 일일/주간 매출 조회
- 예약 관리 (수동 예약, 변경, 삭제)
- 환불 처리
- 사용 시작 버튼
- 추가 요금 확인 (1분당 300원)

## 요금 체계

- 1시간: 10,000원
- 2시간: 20,000원
- 4시간: 30,000원
- 추가 요금: 사용시간 종료 후 1분당 300원

## 시작하기

### 필수 요구사항

- Flutter SDK
- JDK 17
- Android SDK
- Firebase 프로젝트 설정

### 설치

```bash
flutter pub get
```

### Firebase 설정

1. Firebase Console에서 프로젝트 생성
2. Android 앱 추가 (패키지명: `com.example.gns_app_2026`)
3. `google-services.json` 파일을 `android/app/` 디렉토리에 추가
4. FlutterFire CLI로 설정 파일 생성:
   ```bash
   flutterfire configure
   ```

### 실행

```bash
flutter run
```

### 빌드

#### Debug APK
```bash
flutter build apk --debug
```

#### Release APK
```bash
flutter build apk --release
```

## 개발 규칙

1. 빌드를 깨뜨릴 가능성이 있으면 작업을 중단하고 질의한다.
2. 한 번의 작업은 하나의 목적만 수행한다.
3. Dart 코드 수정을 우선하며, 네이티브(android/) 수정은 불가피할 때만 허용한다.
4. 플러그인 추가는 최소화하며 Flutter 버전 호환성을 검증한다.
5. 모든 결과물은 아래 명령어가 성공해야 한다:
   ```bash
   flutter pub get
   flutter analyze
   flutter build apk --debug
   ```
6. keystore는 초기에 생성하고 절대 저장소에 커밋하지 않는다.
7. 서명 정보는 GitHub Secrets 등 보안 채널로만 관리한다.

## 프로젝트 구조

```
lib/
  config/          # 앱 설정
  models/          # 데이터 모델
  providers/       # Riverpod 상태 관리
  screens/         # 화면
    reservation_flow/  # 예약 플로우
  services/        # 서비스 (Firebase, Iamport)
```

## 아임포트 설정

- 테스트 모드 사용
- 채널 키:
  - 이니시스: `channel-key-cbc91735-ccb5-4045-8ac1-4ef3f3731e8d`
  - 카카오페이: `channel-key-bcd6a1a1-d68f-407c-a9a1-5085029cc69b`

## 참고 자료

- 데모 사이트: https://5060-i1ytwr3anjc98ir9e40du-b32ec7bb.sandbox.novita.ai
- UI 디자인 참고: https://ui.shadcn.com

## 라이선스

MIT
