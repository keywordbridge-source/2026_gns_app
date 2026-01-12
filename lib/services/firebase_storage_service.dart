import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // 이미지 업로드
  static Future<String> uploadImage({
    required File imageFile,
    required String folder,
    String? fileName,
  }) async {
    try {
      final finalFileName = fileName ?? 
          '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('$folder/$finalFileName');
      
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      print('이미지 업로드 오류: $e');
      rethrow;
    }
  }

  // 여러 이미지 업로드
  static Future<List<String>> uploadImages({
    required List<File> imageFiles,
    required String folder,
  }) async {
    final urls = <String>[];
    
    for (int i = 0; i < imageFiles.length; i++) {
      final url = await uploadImage(
        imageFile: imageFiles[i],
        folder: folder,
        fileName: '${DateTime.now().millisecondsSinceEpoch}_$i.jpg',
      );
      urls.add(url);
    }
    
    return urls;
  }

  // 이미지 삭제
  static Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('이미지 삭제 오류: $e');
      rethrow;
    }
  }

  // 이미지 선택 (갤러리)
  static Future<File?> pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('이미지 선택 오류: $e');
      return null;
    }
  }

  // 이미지 선택 (카메라)
  static Future<File?> pickImageFromCamera() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('이미지 선택 오류: $e');
      return null;
    }
  }

  // 빌드업 키트 이미지 폴더 경로
  static String getBuildKitImagePath(String kitId, int imageNumber) {
    return 'buildKits/$kitId/image$imageNumber.jpg';
  }
}
