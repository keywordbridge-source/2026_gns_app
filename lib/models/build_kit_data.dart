// 빌드업 키트 샘플 데이터 구조
// 실제 데이터는 Firebase Firestore에 저장되어야 함
// GitHub 저장소 자료를 참고하여 31개 키트 정보를 채워야 함

class BuildKitData {
  static List<Map<String, dynamic>> getSampleData() {
    // 실제 데이터는 GitHub 저장소나 Firebase에서 가져와야 함
    // 여기서는 구조만 제공
    return [
      // 예시:
      // {
      //   'theme': '테마명',
      //   'brand': '브랜드명',
      //   'productName': '제품명',
      //   'partsCount': 부품수,
      //   'image1': '이미지 URL 1',
      //   'image2': '이미지 URL 2',
      //   'image3': '이미지 URL 3',
      //   'image4': '이미지 URL 4',
      // },
      // ... 총 31개
    ];
  }

  // Firebase에 초기 데이터 추가하는 헬퍼 함수
  static Future<void> addInitialDataToFirebase() async {
    // scripts/add_build_kits.dart 참고
    // Firebase Console에서 직접 추가하거나 스크립트 실행
  }
}
