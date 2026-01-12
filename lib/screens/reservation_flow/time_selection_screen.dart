import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/reservation_provider.dart';
import '../../config/app_config.dart';
import '../../models/pricing.dart';

class TimeSelectionScreen extends ConsumerWidget {
  const TimeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservation = ref.watch(reservationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('이용시간 선택')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '이용시간을 선택해주세요',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ...AppConfig.availableDurations.map((duration) {
            final price = Pricing.getPrice(duration);
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text('$duration시간'),
                subtitle: Text('${price.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]},',
                    )}원'),
                trailing: reservation.selectedDuration == duration
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  ref.read(reservationProvider.notifier).selectDuration(duration);
                  context.push('/date-time-selection');
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
