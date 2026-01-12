import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/reservation_provider.dart';
import '../../services/firebase_service.dart';
import '../../config/app_config.dart';

class SeatSelectionScreen extends ConsumerStatefulWidget {
  const SeatSelectionScreen({super.key});

  @override
  ConsumerState<SeatSelectionScreen> createState() =>
      _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends ConsumerState<SeatSelectionScreen> {
  List<int>? _availableSeats;
  bool _isLoading = true;
  int? _selectedSeat;

  @override
  void initState() {
    super.initState();
    _loadAvailableSeats();
  }

  Future<void> _loadAvailableSeats() async {
    final reservation = ref.read(reservationProvider);
    if (reservation.selectedDate == null ||
        reservation.selectedStartHour == null ||
        reservation.selectedDuration == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final seats = await FirebaseService.getAvailableSeats(
        reservation.selectedDate!,
        reservation.selectedStartHour!,
        reservation.selectedDuration!,
      );
      setState(() {
        _availableSeats = seats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('좌석 정보를 불러오는데 실패했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('좌석 선택')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_availableSeats == null || _availableSeats!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('좌석 선택')),
        body: const Center(
          child: Text('선택하신 시간에 이용 가능한 좌석이 없습니다.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('좌석 선택')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '좌석을 선택해주세요',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(AppConfig.seatsPerHour, (index) {
              final seatNumber = index + 1;
              final isAvailable = _availableSeats!.contains(seatNumber);
              final isSelected = _selectedSeat == seatNumber;

              return SizedBox(
                width: 80,
                height: 80,
                child: ElevatedButton(
                  onPressed: isAvailable
                      ? () {
                          setState(() {
                            _selectedSeat = seatNumber;
                          });
                          ref
                              .read(reservationProvider.notifier)
                              .selectSeat(seatNumber);
                          context.push('/customer-info');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? Colors.blue
                        : isAvailable
                            ? Colors.green
                            : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    '$seatNumber',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
