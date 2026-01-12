import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../models/build_kit.dart';

class BatchAddKitsScreen extends StatefulWidget {
  const BatchAddKitsScreen({super.key});

  @override
  State<BatchAddKitsScreen> createState() => _BatchAddKitsScreenState();
}

class _BatchAddKitsScreenState extends State<BatchAddKitsScreen> {
  final _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _addKits() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('데이터를 입력하세요.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // JSON 형식으로 파싱
      final lines = text.split('\n').where((line) => line.trim().isNotEmpty).toList();
      final kits = <BuildKit>[];

      for (final line in lines) {
        // 탭 또는 쉼표로 구분된 형식 지원
        final parts = line.split('\t');
        if (parts.length < 4) {
          continue; // 형식이 맞지 않으면 스킵
        }

        final kit = BuildKit(
          id: '',
          theme: parts[0].trim(),
          brand: parts[1].trim(),
          productName: parts[2].trim(),
          partsCount: int.tryParse(parts[3].trim()) ?? 0,
          image1: parts.length > 4 ? parts[4].trim() : '',
          image2: parts.length > 5 ? parts[5].trim() : '',
          image3: parts.length > 6 ? parts[6].trim() : '',
          image4: parts.length > 7 ? parts[7].trim() : '',
        );

        kits.add(kit);
      }

      if (kits.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('유효한 데이터가 없습니다.')),
        );
        return;
      }

      await FirebaseService.addBuildKitsBatch(kits);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${kits.length}개의 키트가 추가되었습니다.')),
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
      appBar: AppBar(title: const Text('키트 일괄 추가')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '형식: 테마\t브랜드\t제품명\t부품수\t이미지1\t이미지2\t이미지3\t이미지4',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '각 줄에 하나의 키트 정보를 입력하세요.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: '테마1\t브랜드1\t제품명1\t100\t이미지1\t이미지2\t이미지3\t이미지4\n테마2\t브랜드2\t제품명2\t200\t...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _addKits,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('일괄 추가', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
