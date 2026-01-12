// 빌드업 키트 데이터를 Firebase에 추가하는 스크립트
// 사용법: dart scripts/add_build_kits.dart

// import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase 설정 후 주석 해제
// import 'package:firebase_core/firebase_core.dart'; // Firebase 설정 후 주석 해제

// 실제 Firebase 설정 필요
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   final firestore = FirebaseFirestore.instance;
//
//   // 31개 빌드업 키트 샘플 데이터
//   final buildKits = [
//     // GitHub 저장소 자료를 참고하여 실제 데이터로 채워야 함
//     // 구조 예시:
//     {
//       'theme': '테마1',
//       'brand': '브랜드1',
//       'productName': '제품명1',
//       'partsCount': 100,
//       'image1': 'https://example.com/image1.jpg',
//       'image2': 'https://example.com/image2.jpg',
//       'image3': 'https://example.com/image3.jpg',
//       'image4': 'https://example.com/image4.jpg',
//     },
//     // ... 나머지 30개
//   ];
//
//   for (var kit in buildKits) {
//     await firestore.collection('buildKits').add(kit);
//   }
//
//   print('빌드업 키트 데이터 추가 완료');
// }
