import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/firebase_service.dart';
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

  Future<void> _addKit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final kit = BuildKit(
        id: '', // Firestore에서 자동 생성
        theme: _themeController.text,
        brand: _brandController.text,
        productName: _productNameController.text,
        partsCount: int.tryParse(_partsCountController.text) ?? 0,
        image1: _image1Controller.text,
        image2: _image2Controller.text,
        image3: _image3Controller.text,
        image4: _image4Controller.text,
      );

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
            TextFormField(
              controller: _image1Controller,
              decoration: const InputDecoration(
                labelText: '이미지1 URL *',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? '이미지1 URL을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _image2Controller,
              decoration: const InputDecoration(
                labelText: '이미지2 URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _image3Controller,
              decoration: const InputDecoration(
                labelText: '이미지3 URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _image4Controller,
              decoration: const InputDecoration(
                labelText: '이미지4 URL',
                border: OutlineInputBorder(),
              ),
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
