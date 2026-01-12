import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import '../firebase_options.dart'; // flutterfire configure 후 주석 해제

class FirebaseInitService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Firebase 초기화
      // flutterfire configure 실행 후 아래 주석 해제
      // await Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );
      
      // 임시: firebase_options.dart가 없을 때는 기본 초기화
      await Firebase.initializeApp();
      
      // Firestore 설정
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      _initialized = true;
      print('Firebase 초기화 완료');
    } catch (e) {
      print('Firebase 초기화 오류: $e');
      // firebase_options.dart 파일이 없거나 설정이 안 되어 있을 수 있음
      // FlutterFire CLI로 생성 필요: flutterfire configure
      rethrow;
    }
  }

  static Future<void> initializeBuildKits() async {
    // 빌드업 키트 초기 데이터가 없을 경우 안내만 출력
    try {
      final kitsSnapshot = await FirebaseFirestore.instance
          .collection('buildKits')
          .limit(1)
          .get();

      if (kitsSnapshot.docs.isEmpty) {
        print('빌드업 키트 데이터가 없습니다. 관리자 화면에서 키트를 추가하세요.');
      } else {
        print('빌드업 키트 ${kitsSnapshot.docs.length}개 이상 확인됨');
      }
    } catch (e) {
      print('빌드업 키트 확인 오류: $e');
      print('Firestore 데이터베이스가 생성되었는지 확인하세요.');
    }
  }
}
