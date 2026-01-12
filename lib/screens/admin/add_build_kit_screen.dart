import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/firebase_service.dart';
import '../../services/firebase_storage_service.dart';
import '../../models/build_kit.dart';

class AddBuildKitScreen extends StatefulWidget {
  const AddBuildKitScreen({super.key});

  @override
  State<AddBuildKitScreen> createState() => _AddBuildKitScreenState();
}

class _AddBuildKitScreenState extends State<AddBuildKitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _themeController = TextEditingController();
  final _brandController = TextEditingController();
  final _productNameController = TextEditingController();
  final _partsCountController = TextEditingController();
  final _image1Controller = TextEditingController();
  final _image2Controller = TextEditingController();
  final _image3Controller = TextEditingController();
  final _image4Controller = TextEditingController();
  bool _isLoading = false;
  
  File? _image1File;
  File? _image2File;
  File? _image3File;
  File? _image4File;

  @override
  void dispose() {
    _themeController.dispose();
    _brandController.dispose();
    _productNameController.dispose();
    _partsCountController.dispose();
    _image1Controller.dispose();
    _image2Controller.dispose();
    _image3Controller.dispose();
    _image4Controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage(int imageNumber) async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('이미지 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('갤러리에서 선택'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('카메라로 촬영'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    File? pickedFile;
    if (source == ImageSource.gallery) {
      pickedFile = await FirebaseStorageService.pickImageFromGallery();
    } else {
      pickedFile = await FirebaseStorageService.pickImageFromCamera();
    }

    if (pickedFile != null && mounted) {
      setState(() {
        switch (imageNumber) {
          case 1:
            _image1File = pickedFile;
            break;
          case 2:
            _image2File = pickedFile;
            break;
          case 3:
            _image3File = pickedFile;
            break;
          case 4:
            _image4File = pickedFile;
            break;
        }
      });
    }
  }

  Future<void> _addKit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_image1File == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지1을 선택해주세요.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 임시 키트 ID 생성 (실제로는 Firestore에서 생성됨)
      final tempKitId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // 이미지 업로드
      final imageUrls = <String>[];
      
      if (_image1File != null) {
        final url1 = await FirebaseStorageService.uploadImage(
          imageFile: _image1File!,
          folder: 'buildKits/$tempKitId',
          fileName: 'image1.jpg',
        );
        imageUrls.add(url1);
      }
      
      if (_image2File != null) {
        final url2 = await FirebaseStorageService.uploadImage(
          imageFile: _image2File!,
          folder: 'buildKits/$tempKitId',
          fileName: 'image2.jpg',
        );
        imageUrls.add(url2);
      }
      
      if (_image3File != null) {
        final url3 = await FirebaseStorageService.uploadImage(
          imageFile: _image3File!,
          folder: 'buildKits/$tempKitId',
          fileName: 'image3.jpg',
        );
        imageUrls.add(url3);
      }
      
      if (_image4File != null) {
        final url4 = await FirebaseStorageService.uploadImage(
          imageFile: _image4File!,
          folder: 'buildKits/$tempKitId',
          fileName: 'image4.jpg',
        );
        imageUrls.add(url4);
      }

      // 키트 생성
      final kit = BuildKit(
        id: '', // Firestore에서 자동 생성
        theme: _themeController.text,
        brand: _brandController.text,
        productName: _productNameController.text,
        partsCount: int.tryParse(_partsCountController.text) ?? 0,
        image1: imageUrls.isNotEmpty ? imageUrls[0] : '',
        image2: imageUrls.length > 1 ? imageUrls[1] : '',
        image3: imageUrls.length > 2 ? imageUrls[2] : '',
        image4: imageUrls.length > 3 ? imageUrls[3] : '',
      );

      // Firestore에 저장
      await FirebaseService.addBuildKit(kit);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('빌드업 키트가 추가되었습니다.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류 발생: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('빌드업 키트 추가')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _themeController,
              decoration: const InputDecoration(
                labelText: '테마 *',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? '테마를 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: '브랜드 *',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? '브랜드를 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _productNameController,
              decoration: const InputDecoration(
                labelText: '제품명 *',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? '제품명을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _partsCountController,
              decoration: const InputDecoration(
                labelText: '부품수 *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) =>
                  value == null || value.isEmpty ? '부품수를 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            const Text(
              '이미지1 *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _image1File != null
                      ? Image.file(_image1File!, height: 100, fit: BoxFit.cover)
                      : Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _pickImage(1),
                  child: const Text('선택'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '이미지2',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _image2File != null
                      ? Image.file(_image2File!, height: 100, fit: BoxFit.cover)
                      : Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _pickImage(2),
                  child: const Text('선택'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '이미지3',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _image3File != null
                      ? Image.file(_image3File!, height: 100, fit: BoxFit.cover)
                      : Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _pickImage(3),
                  child: const Text('선택'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '이미지4',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _image4File != null
                      ? Image.file(_image4File!, height: 100, fit: BoxFit.cover)
                      : Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _pickImage(4),
                  child: const Text('선택'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _addKit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('키트 추가', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
