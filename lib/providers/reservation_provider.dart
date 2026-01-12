import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/build_kit.dart';
import '../models/reservation.dart';
import '../models/pricing.dart';

class ReservationState {
  final BuildKit? selectedKit;
  final int? selectedDuration;
  final DateTime? selectedDate;
  final int? selectedStartHour;
  final int? selectedSeat;
  final String? customerName;
  final String? customerPhone;
  final String? customerPassword;

  ReservationState({
    this.selectedKit,
    this.selectedDuration,
    this.selectedDate,
    this.selectedStartHour,
    this.selectedSeat,
    this.customerName,
    this.customerPhone,
    this.customerPassword,
  });

  ReservationState copyWith({
    BuildKit? selectedKit,
    int? selectedDuration,
    DateTime? selectedDate,
    int? selectedStartHour,
    int? selectedSeat,
    String? customerName,
    String? customerPhone,
    String? customerPassword,
  }) {
    return ReservationState(
      selectedKit: selectedKit ?? this.selectedKit,
      selectedDuration: selectedDuration ?? this.selectedDuration,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedStartHour: selectedStartHour ?? this.selectedStartHour,
      selectedSeat: selectedSeat ?? this.selectedSeat,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerPassword: customerPassword ?? this.customerPassword,
    );
  }

  int get totalAmount {
    if (selectedDuration == null) return 0;
    return Pricing.getPrice(selectedDuration!);
  }

  Reservation? toReservation(String id) {
    if (selectedKit == null ||
        selectedDuration == null ||
        selectedDate == null ||
        selectedStartHour == null ||
        selectedSeat == null ||
        customerName == null ||
        customerPhone == null ||
        customerPassword == null) {
      return null;
    }

    return Reservation(
      id: id,
      buildKitId: selectedKit!.id,
      buildKitName: selectedKit!.productName,
      durationHours: selectedDuration!,
      date: selectedDate!,
      startHour: selectedStartHour!,
      seatNumber: selectedSeat!,
      customerName: customerName!,
      customerPhone: customerPhone!,
      customerPassword: customerPassword!,
      totalAmount: totalAmount,
      status: ReservationStatus.pending,
      createdAt: DateTime.now(),
    );
  }
}

class ReservationNotifier extends StateNotifier<ReservationState> {
  ReservationNotifier() : super(ReservationState());

  void selectKit(BuildKit kit) {
    state = state.copyWith(selectedKit: kit);
  }

  void selectDuration(int duration) {
    state = state.copyWith(selectedDuration: duration);
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void selectStartHour(int hour) {
    state = state.copyWith(selectedStartHour: hour);
  }

  void selectSeat(int seat) {
    state = state.copyWith(selectedSeat: seat);
  }

  void setCustomerInfo(String name, String phone, String password) {
    state = state.copyWith(
      customerName: name,
      customerPhone: phone,
      customerPassword: password,
    );
  }

  void reset() {
    state = ReservationState();
  }
}

final reservationProvider =
    StateNotifierProvider<ReservationNotifier, ReservationState>(
  (ref) => ReservationNotifier(),
);
