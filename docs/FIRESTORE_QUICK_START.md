# Firestore 빠른 시작 가이드

## 단계별 설정

### 1단계: Firestore 데이터베이스 생성

1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 `gns-app-45d6d` 선택
3. 왼쪽 메뉴: **Firestore Database** 클릭
4. **데이터베이스 만들기** 클릭
5. **테스트 모드로 시작** 선택 (개발 중)
6. 위치: **asia-northeast3 (서울)** 선택
7. **사용 설정** 클릭

### 2단계: buildKits 컬렉션 생성

1. Firestore Database 화면에서 **컬렉션 시작** 클릭
2. 컬렉션 ID: `buildKits` 입력
3. **다음** 클릭
4. 문서 ID: **자동 ID** 선택
5. 첫 번째 필드 추가:
   - 필드 이름: `theme`
   - 유형: **문자열**
   - 값: `테스트`
6. **저장** 클릭

**나머지 필드는 앱에서 자동으로 추가되거나, 수동으로 추가할 수 있습니다.**

### 3단계: 빌드업 키트 데이터 추가

#### 방법 A: Firebase Console에서 직접 추가 (권장)

1. `buildKits` 컬렉션에서 **문서 추가** 클릭
2. 각 필드 추가:
   - `theme` (문자열)
   - `brand` (문자열)
   - `productName` (문자열)
   - `partsCount` (숫자)
   - `image1` (문자열)
   - `image2` (문자열)
   - `image3` (문자열)
   - `image4` (문자열)
3. **저장** 클릭
4. 31개 키트 모두 반복

#### 방법 B: CSV 임포트 (대량 추가)

1. CSV 파일 준비 (필드: theme, brand, productName, partsCount, image1, image2, image3, image4)
2. Firebase Console에서 가져오기 기능 사용
3. 또는 스크립트 사용

### 4단계: 보안 규칙 설정

1. Firestore Database → **규칙** 탭 클릭
2. `scripts/firestore_rules.txt` 파일 내용 복사
3. 규칙 편집기에 붙여넣기
4. **게시** 클릭

### 5단계: reservations 컬렉션

`reservations` 컬렉션은 앱에서 자동으로 생성되므로 수동 생성 불필요합니다.

첫 예약이 생성될 때 자동으로 컬렉션이 만들어집니다.

## 확인 체크리스트

- [ ] Firestore 데이터베이스 생성 완료
- [ ] `buildKits` 컬렉션 생성 완료
- [ ] 빌드업 키트 데이터 31개 추가 완료
- [ ] 보안 규칙 설정 완료
- [ ] 앱에서 연결 테스트 완료

## 다음 작업

Firestore 설정이 완료되면:
1. Firebase 설정 파일 생성 (`flutterfire configure`)
2. 앱 실행 및 테스트
3. 빌드업 키트 목록 조회 확인
