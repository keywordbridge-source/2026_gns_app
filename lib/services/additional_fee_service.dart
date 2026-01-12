import '../models/reservation.dart';
import '../models/pricing.dart';
import 'firebase_service.dart';

class AdditionalFeeService {
  // 추가 요금 계산 및 업데이트
  static Future<void> calculateAndUpdateAdditionalFee(Reservation reservation) async {
    if (reservation.usageStartTime == null) return;

    final endTime = reservation.usageStartTime!.add(
      Duration(hours: reservation.durationHours),
    );
    final additionalFee = Pricing.calculateAdditionalFee(
      reservation.usageStartTime!,
      endTime,
    );

    if (additionalFee > 0) {
      await FirebaseService.updateReservation(
        reservation.copyWith(additionalFee: additionalFee),
      );
    }
  }

  // 예약의 추가 요금을 주기적으로 체크
  static Future<void> checkAllReservationsForAdditionalFee() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // 오늘 예약 중 사용 중인 것들만 체크
    final reservations = await FirebaseService.getReservationsByDate(today);
    
    for (final reservation in reservations) {
      if (reservation.status == ReservationStatus.inUse &&
          reservation.usageStartTime != null) {
        await calculateAndUpdateAdditionalFee(reservation);
      }
    }
  }
}
