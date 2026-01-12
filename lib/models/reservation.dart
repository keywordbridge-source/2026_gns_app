import 'package:cloud_firestore/cloud_firestore.dart';

enum ReservationStatus {
  pending,
  confirmed,
  inUse,
  completed,
  cancelled,
}

class Reservation {
  final String id;
  final String buildKitId;
  final String buildKitName;
  final int durationHours; // 1, 2, or 4
  final DateTime date;
  final int startHour; // 9-17
  final int seatNumber; // 1-10
  final String customerName;
  final String customerPhone;
  final String customerPassword; // 4 digits
  final int totalAmount;
  final ReservationStatus status;
  final DateTime? paymentDate;
  final String? paymentId;
  final DateTime? usageStartTime;
  final int? additionalFee; // 추가 요금 (1분당 300원)
  final DateTime createdAt;
  final DateTime? cancelledAt;
  final int? refundAmount;

  Reservation({
    required this.id,
    required this.buildKitId,
    required this.buildKitName,
    required this.durationHours,
    required this.date,
    required this.startHour,
    required this.seatNumber,
    required this.customerName,
    required this.customerPhone,
    required this.customerPassword,
    required this.totalAmount,
    required this.status,
    this.paymentDate,
    this.paymentId,
    this.usageStartTime,
    this.additionalFee,
    required this.createdAt,
    this.cancelledAt,
    this.refundAmount,
  });

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'] ?? '',
      buildKitId: map['buildKitId'] ?? '',
      buildKitName: map['buildKitName'] ?? '',
      durationHours: map['durationHours'] ?? 1,
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      startHour: map['startHour'] ?? 9,
      seatNumber: map['seatNumber'] ?? 1,
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      customerPassword: map['customerPassword'] ?? '',
      totalAmount: map['totalAmount'] ?? 0,
      status: ReservationStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
        orElse: () => ReservationStatus.pending,
      ),
      paymentDate: (map['paymentDate'] as Timestamp?)?.toDate(),
      paymentId: map['paymentId'],
      usageStartTime: (map['usageStartTime'] as Timestamp?)?.toDate(),
      additionalFee: map['additionalFee'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      cancelledAt: (map['cancelledAt'] as Timestamp?)?.toDate(),
      refundAmount: map['refundAmount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buildKitId': buildKitId,
      'buildKitName': buildKitName,
      'durationHours': durationHours,
      'date': Timestamp.fromDate(date),
      'startHour': startHour,
      'seatNumber': seatNumber,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerPassword': customerPassword,
      'totalAmount': totalAmount,
      'status': status.toString(),
      'paymentDate': paymentDate != null ? Timestamp.fromDate(paymentDate!) : null,
      'paymentId': paymentId,
      'usageStartTime': usageStartTime != null ? Timestamp.fromDate(usageStartTime!) : null,
      'additionalFee': additionalFee,
      'createdAt': Timestamp.fromDate(createdAt),
      'cancelledAt': cancelledAt != null ? Timestamp.fromDate(cancelledAt!) : null,
      'refundAmount': refundAmount,
    };
  }

  DateTime get endTime {
    return date.add(Duration(hours: startHour + durationHours));
  }

  int calculateCancellationFee() {
    final now = DateTime.now();
    final daysUntilReservation = date.difference(now).inDays;
    
    if (daysUntilReservation >= 3) {
      return 0; // 3일 전: 무료
    } else if (daysUntilReservation == 2) {
      return (totalAmount * 0.2).round(); // 2일 전: 20%
    } else if (daysUntilReservation == 1) {
      return (totalAmount * 0.5).round(); // 1일 전: 50%
    } else {
      return totalAmount; // 당일: 100%
    }
  }

  Reservation copyWith({
    String? id,
    String? buildKitId,
    String? buildKitName,
    int? durationHours,
    DateTime? date,
    int? startHour,
    int? seatNumber,
    String? customerName,
    String? customerPhone,
    String? customerPassword,
    int? totalAmount,
    ReservationStatus? status,
    DateTime? paymentDate,
    String? paymentId,
    DateTime? usageStartTime,
    int? additionalFee,
    DateTime? createdAt,
    DateTime? cancelledAt,
    int? refundAmount,
  }) {
    return Reservation(
      id: id ?? this.id,
      buildKitId: buildKitId ?? this.buildKitId,
      buildKitName: buildKitName ?? this.buildKitName,
      durationHours: durationHours ?? this.durationHours,
      date: date ?? this.date,
      startHour: startHour ?? this.startHour,
      seatNumber: seatNumber ?? this.seatNumber,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerPassword: customerPassword ?? this.customerPassword,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentId: paymentId ?? this.paymentId,
      usageStartTime: usageStartTime ?? this.usageStartTime,
      additionalFee: additionalFee ?? this.additionalFee,
      createdAt: createdAt ?? this.createdAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      refundAmount: refundAmount ?? this.refundAmount,
    );
  }
}
