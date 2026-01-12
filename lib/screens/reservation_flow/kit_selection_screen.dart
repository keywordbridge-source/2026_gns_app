import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/build_kit.dart';
import '../../services/firebase_service.dart';
import '../../providers/reservation_provider.dart';

class KitSelectionScreen extends ConsumerStatefulWidget {
  const KitSelectionScreen({super.key});

  @override
  ConsumerState<KitSelectionScreen> createState() => _KitSelectionScreenState();
}

class _KitSelectionScreenState extends ConsumerState<KitSelectionScreen> {
  List<BuildKit>? _kits;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadKits();
  }

  Future<void> _loadKits() async {
    try {
      final kits = await FirebaseService.getBuildKits();
      setState(() {
        _kits = kits;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('키트 목록을 불러오는데 실패했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('빌드업 키트 선택')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_kits == null || _kits!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('빌드업 키트 선택')),
        body: const Center(child: Text('키트가 없습니다.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('빌드업 키트 선택')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _kits!.length,
        itemBuilder: (context, index) {
          final kit = _kits![index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: kit.image1.isNotEmpty
                  ? Image.network(kit.image1, width: 60, height: 60, fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 60),
              title: Text(kit.productName),
              subtitle: Text('${kit.brand} - ${kit.theme}\n부품수: ${kit.partsCount}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ref.read(reservationProvider.notifier).selectKit(kit);
                context.push('/time-selection');
              },
            ),
          );
        },
      ),
    );
  }
}
