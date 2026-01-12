import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/firebase_service.dart';
import '../../models/reservation.dart';
import 'package:intl/intl.dart';

class MyReservationScreen extends StatefulWidget {
  const MyReservationScreen({super.key});

  @override
  State<MyReservationScreen> createState() => _MyReservationScreenState();
}

class _MyReservationScreenState extends State<MyReservationScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  List<Reservation>? _reservations;
  bool _isLoading = false;

  Future<void> _loadReservations() async {
    if (_nameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름과 비밀번호를 입력해주세요.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final reservations = await FirebaseService.getReservationsByCustomer(
        _nameController.text,
        _passwordController.text,
      );
      setState(() {
        _reservations = reservations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('예약 정보를 불러오는데 실패했습니다: $e')),
        );
      }
    }
  }

  Future<void> _cancelReservation(Reservation reservation) async {
    final cancelFee = reservation.calculateCancellationFee();
    final refundAmount = reservation.totalAmount - cancelFee;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('예약 취소'),
        content: Text(
          '예약을 취소하시겠습니까?\n\n'
          '취소 수수료: ${cancelFee.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              )}원\n'
          '환불 금액: ${refundAmount.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              )}원',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('예'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseService.updateReservation(
          reservation.copyWith(
            status: ReservationStatus.cancelled,
            cancelledAt: DateTime.now(),
            refundAmount: refundAmount,
          ),
        );
        await _loadReservations();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('예약이 취소되었습니다.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('예약 취소 중 오류가 발생했습니다: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 예약')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: '예약자 이름',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: '비밀번호 (4자리)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _loadReservations,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('조회'),
                  ),
                ],
              ),
            ),
          ),
          if (_reservations != null) ...[
            const SizedBox(height: 24),
            ...(_reservations!.isEmpty
                ? [
                    const Center(
                      child: Text('예약 내역이 없습니다.'),
                    )
                  ]
                : _reservations!.map((reservation) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(reservation.buildKitName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${DateFormat('yyyy-MM-dd').format(reservation.date)} ${reservation.startHour}시 시작',
                            ),
                            Text('이용시간: ${reservation.durationHours}시간'),
                            Text('좌석: ${reservation.seatNumber}번'),
                            if (reservation.usageStartTime != null)
                              Text(
                                '사용시작: ${DateFormat('HH:mm').format(reservation.usageStartTime!)}',
                              ),
                            if (reservation.additionalFee != null &&
                                reservation.additionalFee! > 0)
                              Text(
                                '추가요금: ${reservation.additionalFee!.toString().replaceAllMapped(
                                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                      (Match m) => '${m[1]},',
                                    )}원',
                                style: const TextStyle(color: Colors.red),
                              ),
                          ],
                        ),
                        trailing: reservation.status != ReservationStatus.cancelled
                            ? TextButton(
                                onPressed: () => _cancelReservation(reservation),
                                child: const Text('취소'),
                              )
                            : const Text(
                                '취소됨',
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                    );
                  })),
          ],
        ],
      ),
    );
  }
}
