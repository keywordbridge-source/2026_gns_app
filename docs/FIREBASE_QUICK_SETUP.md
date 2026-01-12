# Firebase 빠른 설정 가이드

## 1. google-services.json 파일 다운로드

1. [Firebase Console](https://console.firebase.google.com/)에 접속
2. 프로젝트 선택
3. 프로젝트 설정 (톱니바퀴 아이콘) 클릭
4. "내 앱" 섹션에서 Android 앱 선택 (없으면 추가)
5. `google-services.json` 파일 다운로드
6. 다운로드한 파일을 `android/app/google-services.json` 위치에 복사

## 2. FlutterFire CLI로 설정 파일 생성

터미널에서 다음 명령어 실행:

```bash
flutterfire configure
```

실행 시:
1. Firebase 프로젝트 선택
2. Android 플랫폼 선택
3. iOS 플랫폼은 선택 안 해도 됨 (Android만 사용)
4. `lib/firebase_options.dart` 파일이 자동 생성됨

## 3. Firestore 데이터베이스 생성

1. Firebase Console에서 "Firestore Database" 클릭
2. "데이터베이스 만들기" 클릭
3. 프로덕션 모드 또는 테스트 모드 선택 (개발 중에는 테스트 모드 권장)
4. 위치 선택 (asia-northeast3 권장 - 서울)

## 4. 컬렉션 생성

### buildKits 컬렉션
1. Firestore Database에서 "컬렉션 시작" 클릭
2. 컬렉션 ID: `buildKits` 입력
3. 문서 ID: 자동 생성
4. 필드 추가:
   - `theme` (문자열)
   - `brand` (문자열)
   - `productName` (문자열)
   - `partsCount` (숫자)
   - `image1` (문자열)
   - `image2` (문자열)
   - `image3` (문자열)
   - `image4` (문자열)

### reservations 컬렉션
1. "컬렉션 시작" 클릭
2. 컬렉션 ID: `reservations` 입력
3. 문서 ID: 자동 생성
4. 필드는 앱에서 자동으로 생성됨

## 5. 빌드업 키트 데이터 추가

Firebase Console에서 `buildKits` 컬렉션에 31개 키트 데이터를 추가하세요.

각 문서에 다음 필드를 포함:
- `theme`: 키트 테마
- `brand`: 브랜드명
- `productName`: 제품명
- `partsCount`: 부품 수
- `image1`, `image2`, `image3`, `image4`: 이미지 URL

## 6. 앱 실행 확인

설정이 완료되면 앱을 실행하여 Firebase 연결을 확인하세요:

```bash
flutter run
```

로그에서 "Firebase 초기화 완료" 메시지가 보이면 성공입니다.
