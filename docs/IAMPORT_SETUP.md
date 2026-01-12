# 아임포트 결제 설정 가이드

## 1. 아임포트 가입 및 설정

1. [아임포트](https://www.iamport.kr/) 가입
2. 관리자 페이지에서 "시스템 설정" > "PG설정" 이동
3. 테스트 모드 활성화

## 2. 채널 키 확인

현재 설정된 채널 키:
- **이니시스**: `channel-key-cbc91735-ccb5-4045-8ac1-4ef3f3731e8d`
- **카카오페이**: `channel-key-bcd6a1a1-d68f-407c-a9a1-5085029cc69b`

## 3. 아임포트 JavaScript SDK

현재 구현은 WebView를 통해 아임포트 결제 페이지를 로드합니다.

### 실제 구현 시 필요한 작업:

1. **아임포트 JavaScript SDK 로드**
   - WebView에서 아임포트 SDK를 로드해야 함
   - 현재는 기본 구조만 제공

2. **결제 요청**
   ```javascript
   IMP.init('channel-key');
   IMP.request_pay({
     pg: 'inicis',
     pay_method: 'card',
     merchant_uid: 'merchant_1234567890',
     name: '레고 브릭 빌드업 예약',
     amount: 10000,
     buyer_name: '구매자명',
     buyer_tel: '010-1234-5678',
   }, function(rsp) {
     if (rsp.success) {
       // 결제 성공
     } else {
       // 결제 실패
     }
   });
   ```

3. **결제 검증**
   - 서버에서 결제 검증 필요 (보안상 권장)
   - 또는 클라이언트에서 `IMP.certification()` 사용

## 4. 테스트 모드

현재는 테스트 모드로 설정되어 있습니다.
- 실제 결제가 발생하지 않음
- 테스트 카드 번호 사용 가능

## 5. 프로덕션 전환

실제 서비스 전환 시:
1. 테스트 모드 해제
2. 실제 채널 키로 변경
3. 서버 사이드 결제 검증 구현
4. 보안 검토

## 참고 자료

- [아임포트 개발자 가이드](https://developers.iamport.kr/)
- [아임포트 JavaScript SDK](https://github.com/iamport/iamport-manual)
