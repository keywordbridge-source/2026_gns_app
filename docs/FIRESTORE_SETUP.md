# Firestore 데이터베이스 설정 가이드

## 1. Firestore 데이터베이스 생성

### Firebase Console에서 생성

1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 `gns-app-45d6d` 선택
3. 왼쪽 메뉴에서 "Firestore Database" 클릭
4. "데이터베이스 만들기" 버튼 클릭

### 데이터베이스 모드 선택

**개발 단계: 테스트 모드 (권장)**
- 30일 동안 모든 읽기/쓰기 허용
- 빠른 개발 가능
- 나중에 보안 규칙 설정 필요

**프로덕션: 프로덕션 모드**
- 처음부터 보안 규칙 설정 필요
- 더 안전하지만 초기 설정 복잡

### 위치 선택

- 권장: `asia-northeast3` (서울)
- 또는 가장 가까운 지역 선택

## 2. 컬렉션 구조

### buildKits 컬렉션

**컬렉션 ID**: `buildKits`

**문서 구조**:
```json
{
  "theme": "테마명 (string)",
  "brand": "브랜드명 (string)",
  "productName": "제품명 (string)",
  "partsCount": 100 (number),
  "image1": "이미지 URL 1 (string)",
  "image2": "이미지 URL 2 (string)",
  "image3": "이미지 URL 3 (string)",
  "image4": "이미지 URL 4 (string)"
}
```

**예시 문서**:
```json
{
  "theme": "City",
  "brand": "LEGO",
  "productName": "도시 건물 세트",
  "partsCount": 1250,
  "image1": "https://example.com/image1.jpg",
  "image2": "https://example.com/image2.jpg",
  "image3": "https://example.com/image3.jpg",
  "image4": "https://example.com/image4.jpg"
}
```

### reservations 컬렉션

**컬렉션 ID**: `reservations`

**문서 구조** (앱에서 자동 생성):
```json
{
  "id": "문서 ID (string)",
  "buildKitId": "키트 ID (string)",
  "buildKitName": "키트 이름 (string)",
  "durationHours": 2 (number),
  "date": "2026-01-15T00:00:00Z (timestamp)",
  "startHour": 10 (number),
  "seatNumber": 5 (number),
  "customerName": "홍길동 (string)",
  "customerPhone": "010-1234-5678 (string)",
  "customerPassword": "1234 (string)",
  "totalAmount": 20000 (number),
  "status": "confirmed (string)",
  "paymentDate": "2026-01-10T10:30:00Z (timestamp)",
  "paymentId": "imp_1234567890 (string)",
  "usageStartTime": null (timestamp 또는 null),
  "additionalFee": null (number 또는 null),
  "createdAt": "2026-01-10T10:00:00Z (timestamp)",
  "cancelledAt": null (timestamp 또는 null),
  "refundAmount": null (number 또는 null)
}
```

## 3. 보안 규칙 설정

### 테스트 모드 (초기 개발용)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2026, 12, 31);
    }
  }
}
```

### 프로덕션 모드 (권장)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // buildKits: 모든 사용자가 읽기 가능, 쓰기는 관리자만
    match /buildKits/{kitId} {
      allow read: if true;
      allow write: if false; // 관리자 인증 추가 필요
    }
    
    // reservations: 인증된 사용자만 읽기/쓰기
    match /reservations/{reservationId} {
      allow read: if true; // 예약자 이름/비밀번호로 검증
      allow create: if true; // 예약 생성은 허용
      allow update: if true; // 예약 수정은 허용
      allow delete: if false; // 삭제는 관리자만
    }
  }
}
```

## 4. 인덱스 생성 (선택사항)

예약 조회 성능 향상을 위한 인덱스:

1. Firestore Console → "인덱스" 탭
2. "인덱스 만들기" 클릭
3. 컬렉션: `reservations`
4. 필드 추가:
   - `date` (오름차순)
   - `startHour` (오름차순)
   - `status` (오름차순)

## 5. 빌드업 키트 데이터 추가 방법

### 방법 1: Firebase Console에서 직접 추가

1. Firestore Database → `buildKits` 컬렉션
2. "문서 추가" 클릭
3. 필드 하나씩 추가:
   - `theme` (문자열)
   - `brand` (문자열)
   - `productName` (문자열)
   - `partsCount` (숫자)
   - `image1` (문자열)
   - `image2` (문자열)
   - `image3` (문자열)
   - `image4` (문자열)
4. 31개 키트 모두 추가

### 방법 2: CSV 임포트 (대량 추가)

1. CSV 파일 준비 (31개 키트 데이터)
2. Firebase Console → Firestore → `buildKits`
3. "가져오기" 기능 사용 (있는 경우)
4. 또는 스크립트 사용 (아래 참고)

### 방법 3: 스크립트 사용

`scripts/add_build_kits.dart` 파일을 수정하여 실행

## 6. 확인 사항

✅ Firestore 데이터베이스 생성 완료
✅ `buildKits` 컬렉션 생성 완료
✅ `reservations` 컬렉션 생성 완료 (또는 자동 생성 대기)
✅ 보안 규칙 설정 완료
✅ 빌드업 키트 데이터 31개 추가 완료

## 다음 단계

Firestore 설정이 완료되면:
1. 앱에서 Firebase 연결 테스트
2. 빌드업 키트 목록 조회 테스트
3. 예약 생성 테스트
