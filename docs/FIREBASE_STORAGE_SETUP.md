# Firebase Storage 설정 가이드

## Firebase Storage 활성화

### 1. Firebase Console에서 Storage 활성화

1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 `gns-app-45d6d` 선택
3. 왼쪽 메뉴에서 **Storage** 클릭
4. **시작하기** 버튼 클릭
5. **프로덕션 모드** 또는 **테스트 모드** 선택
   - 테스트 모드: 개발 중 권장
   - 프로덕션 모드: 실제 서비스용
6. 위치 선택: **asia-northeast3 (서울)** 권장
7. **완료** 클릭

### 2. Storage 보안 규칙 설정

Storage → **규칙** 탭에서 다음 규칙 설정:

#### 테스트 모드 (개발용)
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.time < timestamp.date(2026, 12, 31);
    }
  }
}
```

#### 프로덕션 모드 (권장)
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // 빌드업 키트 이미지
    match /buildKits/{kitId}/{imageName} {
      allow read: if true; // 모든 사용자가 읽기 가능
      allow write: if false; // 앱에서만 업로드 (인증 추가 가능)
    }
  }
}
```

### 3. 폴더 구조

Firebase Storage에 다음과 같은 구조로 이미지가 저장됩니다:

```
buildKits/
  {kitId}/
    image1.jpg
    image2.jpg
    image3.jpg
    image4.jpg
```

## 앱에서 사용 방법

### 키트 추가 시

1. 관리자 화면 → 키트 추가
2. 각 이미지 옆의 **"선택"** 버튼 클릭
3. **갤러리에서 선택** 또는 **카메라로 촬영**
4. 이미지 선택 후 자동으로 Firebase Storage에 업로드됨
5. 업로드된 이미지 URL이 Firestore에 저장됨

### 이미지 표시

앱에서 이미지를 표시할 때는 Firebase Storage URL을 사용하므로 별도 작업 불필요합니다.

## 주의사항

- 이미지 크기: 너무 큰 이미지는 업로드 시간이 오래 걸릴 수 있습니다
- 저장 공간: Firebase Storage는 사용량에 따라 요금이 부과됩니다
- 권한: Android에서 카메라 및 저장소 권한이 필요합니다
