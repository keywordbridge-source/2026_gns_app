// import 'package:firebase_core/firebase_core.dart'; // Firebase 설정 후 주석 해제
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseInitService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Firebase 초기화
      // 실제 Firebase 프로젝트 설정 후 아래 주석 해제하고 설정
      // await Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );
      
      // Firestore 설정
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      _initialized = true;
    } catch (e) {
      print('Firebase 초기화 오류: $e');
      rethrow;
    }
  }

  static Future<void> initializeBuildKits() async {
    // 빌드업 키트 초기 데이터가 없을 경우 샘플 데이터 추가
    try {
      final kitsSnapshot = await FirebaseFirestore.instance
          .collection('buildKits')
          .limit(1)
          .get();

      if (kitsSnapshot.docs.isEmpty) {
        // 샘플 데이터 추가는 별도 함수에서 처리
        await _addSampleBuildKits();
      }
    } catch (e) {
      print('빌드업 키트 초기화 오류: $e');
    }
  }

  static Future<void> _addSampleBuildKits() async {
    // 실제 데이터는 Firebase Console에서 추가하거나
    // 별도 스크립트로 추가
    // 여기서는 구조만 제공
  }
}
