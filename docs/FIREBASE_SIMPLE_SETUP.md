# Firebase 연결 - 초보자용 가이드

## 🎯 목표
Firebase에서 다운로드한 파일을 앱 폴더에 넣는 것

## 📋 단계별 설명

### 1단계: google-services.json 파일 다운로드

1. 웹 브라우저 열기 (Chrome, Edge 등)
2. 주소창에 입력: `https://console.firebase.google.com/`
3. 로그인 (Google 계정)
4. 프로젝트 `gns-app-45d6d` 클릭
5. 왼쪽 아래 ⚙️ (톱니바퀴) 아이콘 클릭
6. "프로젝트 설정" 클릭
7. "내 앱" 탭 클릭
8. Android 앱 섹션에서 "google-services.json" 버튼 클릭
9. 파일이 다운로드됨 (보통 다운로드 폴더에 저장됨)

### 2단계: 파일 찾기

다운로드한 파일은 보통 여기에 있습니다:
- **Windows**: `C:\Users\GetnShow - 37\Downloads\google-services.json`
- 또는 브라우저 하단의 다운로드 아이콘 클릭

### 3단계: 파일 복사하기

#### 방법 1: 파일 탐색기 사용 (가장 쉬움)

1. **파일 탐색기 열기** (Windows 키 + E)
2. **다운로드 폴더로 이동**
   - 왼쪽에서 "다운로드" 클릭
   - 또는 주소창에 입력: `C:\Users\GetnShow - 37\Downloads`
3. **google-services.json 파일 찾기**
4. **파일을 복사** (Ctrl + C 또는 우클릭 → 복사)
5. **앱 폴더로 이동**
   - 주소창에 입력: `C:\Users\GetnShow - 37\Desktop\2026 gns app\android\app`
   - 또는 파일 탐색기에서:
     - Desktop → "2026 gns app" → android → app 폴더 열기
6. **파일 붙여넣기** (Ctrl + V 또는 우클릭 → 붙여넣기)

#### 방법 2: 드래그 앤 드롭

1. 다운로드 폴더에서 `google-services.json` 파일 찾기
2. 파일을 마우스로 잡고 드래그
3. 파일 탐색기에서 `C:\Users\GetnShow - 37\Desktop\2026 gns app\android\app` 폴더 열기
4. 파일을 폴더 안으로 드롭

### 4단계: 확인하기

`android\app` 폴더 안에 `google-services.json` 파일이 있는지 확인하세요.

## 🎨 그림으로 설명

```
다운로드 폴더                    앱 폴더
┌─────────────┐                ┌─────────────────────┐
│ google-     │   복사/이동     │ android/            │
│ services.   │  ───────────>  │   app/              │
│ json        │                │     google-services │
└─────────────┘                │     .json  ← 여기!  │
                               └─────────────────────┘
```

## ❓ 문제 해결

### 파일을 찾을 수 없어요
- 브라우저의 다운로드 기록 확인
- 다운로드 폴더에서 "google-services.json" 검색

### 폴더를 찾을 수 없어요
- 파일 탐색기 주소창에 입력: `C:\Users\GetnShow - 37\Desktop\2026 gns app\android\app`
- 또는 "2026 gns app" 폴더를 찾아서 안으로 들어가기

### 파일이 이미 있어요
- 기존 파일을 덮어쓰기 (덮어쓰기 확인 시 "예" 클릭)
