# Firebase Storage 체크리스트

## ✅ 확인 사항

### 1. Storage 활성화 확인
- [ ] Storage 콘솔에 접속 가능
- [ ] 파일 목록이 보이거나 "시작하기" 버튼이 보임
- [ ] Storage가 활성화되어 있음

### 2. 보안 규칙 설정
- [ ] Storage → 규칙 탭 접속
- [ ] `docs/FIREBASE_STORAGE_RULES.txt` 내용 복사
- [ ] 규칙 편집기에 붙여넣기
- [ ] 게시 완료

### 3. 앱 설정 확인
- [ ] `firebase_storage` 패키지 설치됨
- [ ] `image_picker` 패키지 설치됨
- [ ] Android 권한 설정됨 (카메라, 저장소)

### 4. 테스트
- [ ] 앱 실행
- [ ] 관리자 화면 접속
- [ ] 키트 추가 화면에서 이미지 선택 가능
- [ ] 이미지 업로드 성공

## 🔧 문제 해결

### Storage가 활성화되지 않음
1. Storage 콘솔에서 "시작하기" 클릭
2. 테스트 모드 선택
3. 위치 선택 (asia-northeast3 권장)
4. 완료

### 이미지 업로드 실패
1. Storage 보안 규칙 확인
2. 인터넷 연결 확인
3. 앱 권한 확인 (카메라, 저장소)

### 이미지가 보이지 않음
1. Firebase Storage에 이미지가 업로드되었는지 확인
2. Firestore에 이미지 URL이 저장되었는지 확인
3. 네트워크 연결 확인
