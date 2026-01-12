# Firebase 완전 설정 가이드

## 프로젝트 정보
- **프로젝트 ID**: `gns-app-45d6d`
- **패키지명**: `com.example.gns_app_2026`

## 1단계: google-services.json 다운로드

1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 `gns-app-45d6d` 선택
3. 프로젝트 설정 (⚙️) 클릭
4. "내 앱" 섹션에서 Android 앱 확인
   - 없으면 "Android 앱 추가" 클릭
   - 패키지 이름: `com.example.gns_app_2026` 입력
   - 앱 닉네임: `2026 GNS App` 입력
   - `google-services.json` 다운로드
5. 다운로드한 `google-services.json` 파일을 `android/app/` 디렉토리에 복사

## 2단계: FlutterFire CLI 설정

### Firebase CLI 설치 (필수)

**Windows (PowerShell):**
```powershell
npm install -g firebase-tools
```

또는 Chocolatey 사용:
```powershell
choco install firebase-cli
```

### FlutterFire 설정

```bash
flutterfire configure --project=gns-app-45d6d --platforms=android
```

이 명령어가 실행되면:
- `lib/firebase_options.dart` 파일이 자동 생성됨
- Firebase 프로젝트와 연결됨

## 3단계: Firestore 데이터베이스 생성

1. Firebase Console → Firestore Database
2. "데이터베이스 만들기" 클릭
3. **테스트 모드로 시작** 선택
4. 위치: **asia-northeast3 (서울)** 선택
5. "사용 설정" 클릭

## 4단계: 보안 규칙 설정

1. Firestore Database → "규칙" 탭
2. `scripts/firestore_rules.txt` 파일 내용 복사하여 붙여넣기
3. "게시" 클릭

## 5단계: buildKits 컬렉션 생성

1. Firestore Database → "컬렉션 시작"
2. 컬렉션 ID: `buildKits`
3. 문서 ID: 자동 ID
4. 첫 필드 추가 (임시):
   - 필드: `theme`, 유형: 문자열, 값: `테스트`
5. "저장" 클릭

## 6단계: 앱에서 키트 데이터 추가

앱을 실행하여 관리자 화면에서 키트를 추가할 수 있습니다:

1. 앱 실행: `flutter run`
2. 홈 화면 → "관리자" 클릭
3. 우측 상단 메뉴 (📦) → "키트 추가" 또는 "키트 일괄 추가"
4. 31개 키트 데이터 입력

## 확인 체크리스트

- [ ] `google-services.json` 파일이 `android/app/` 디렉토리에 있음
- [ ] `lib/firebase_options.dart` 파일이 생성됨
- [ ] Firestore 데이터베이스 생성 완료
- [ ] `buildKits` 컬렉션 생성 완료
- [ ] 보안 규칙 설정 완료
- [ ] 앱 실행 및 Firebase 연결 확인
- [ ] 키트 데이터 추가 완료

## 문제 해결

### Firebase CLI 설치 오류
- Node.js가 설치되어 있는지 확인
- npm이 PATH에 있는지 확인

### flutterfire configure 오류
- Firebase CLI가 설치되어 있는지 확인
- Firebase에 로그인: `firebase login`

### google-services.json 오류
- 파일이 올바른 위치(`android/app/`)에 있는지 확인
- 파일 내용이 올바른지 확인
