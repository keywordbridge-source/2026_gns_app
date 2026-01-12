# Firebase Storage 빠른 가이드

## Storage 콘솔 접속

링크: https://console.firebase.google.com/project/gns-app-45d6d/storage/gns-app-45d6d.firebasestorage.app/files?hl=ko

## Storage 활성화 확인

Storage 콘솔에 접속하면:
- ✅ **파일 목록이 보이면**: Storage가 활성화되어 있습니다
- ❌ **"Storage를 시작하세요" 메시지가 보이면**: Storage를 활성화해야 합니다

## Storage 활성화 방법

1. Storage 콘솔에서 **"시작하기"** 버튼 클릭
2. **테스트 모드** 선택 (개발 중)
3. 위치: **asia-northeast3 (서울)** 선택
4. **완료** 클릭

## 폴더 구조

Storage에 다음과 같은 구조로 이미지를 저장합니다:

```
buildKits/
  {kitId}/
    image1.jpg
    image2.jpg
    image3.jpg
    image4.jpg
```

## 보안 규칙 설정

Storage → **규칙** 탭에서:

1. `docs/FIREBASE_STORAGE_RULES.txt` 파일 내용 복사
2. 규칙 편집기에 붙여넣기
3. **게시** 클릭

## 앱에서 이미지 업로드

1. 앱 실행
2. 관리자 화면 → 키트 추가
3. 이미지 선택 버튼 클릭
4. 갤러리 또는 카메라에서 선택
5. 자동으로 Storage에 업로드됨

## 수동으로 이미지 업로드 (선택사항)

Storage 콘솔에서 직접 업로드도 가능합니다:

1. Storage 콘솔에서 **"파일 업로드"** 클릭
2. `buildKits` 폴더 생성 (없으면)
3. 각 키트별 폴더 생성
4. 이미지 파일 업로드

하지만 앱에서 업로드하는 것이 더 편리합니다!
