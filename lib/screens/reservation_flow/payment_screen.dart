import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/reservation_provider.dart';
import '../../services/firebase_service.dart';
import '../../services/iamport_webview_service.dart';
import '../../models/reservation.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservation = ref.watch(reservationProvider);
    final totalAmount = reservation.totalAmount;

    return Scaffold(
      appBar: AppBar(title: const Text('결제')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '예약 정보',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text('키트: ${reservation.selectedKit?.productName ?? ""}'),
                  Text('이용시간: ${reservation.selectedDuration}시간'),
                  Text('날짜: ${reservation.selectedDate?.toString().split(' ')[0] ?? ""}'),
                  Text('시작시간: ${reservation.selectedStartHour}시'),
                  Text('좌석: ${reservation.selectedSeat}번'),
                  const Divider(),
                  Text(
                    '총 결제금액: ${totalAmount.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        )}원',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              try {
                final reservationData = reservation.toReservation('');
                if (reservationData == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('예약 정보가 불완전합니다.')),
                  );
                  return;
                }

                // 아임포트 결제
                final merchantUid = const Uuid().v4();
                final paymentResult = await IamportWebViewService.showPaymentWebView(
                  context: context,
                  merchantUid: merchantUid,
                  amount: totalAmount,
                  customerName: reservation.customerName ?? '',
                  customerPhone: reservation.customerPhone ?? '',
                );

                if (paymentResult == null || paymentResult['cancelled'] == true) {
                  return; // 사용자가 취소
                }

                if (paymentResult['success'] == true) {
                  // 예약 저장
                  final newReservation = Reservation(
                    id: '',
                    buildKitId: reservationData.buildKitId,
                    buildKitName: reservationData.buildKitName,
                    durationHours: reservationData.durationHours,
                    date: reservationData.date,
                    startHour: reservationData.startHour,
                    seatNumber: reservationData.seatNumber,
                    customerName: reservationData.customerName,
                    customerPhone: reservationData.customerPhone,
                    customerPassword: reservationData.customerPassword,
                    totalAmount: reservationData.totalAmount,
                    status: ReservationStatus.confirmed,
                    paymentDate: DateTime.now(),
                    paymentId: paymentResult['imp_uid'] as String? ?? merchantUid,
                    createdAt: reservationData.createdAt,
                  );
                  await FirebaseService.createReservation(newReservation);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('예약이 완료되었습니다.')),
                    );
                    ref.read(reservationProvider.notifier).reset();
                    context.go('/');
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          paymentResult['error'] as String? ?? '결제에 실패했습니다.',
                        ),
                      ),
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('결제 처리 중 오류가 발생했습니다: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('결제하기', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}

