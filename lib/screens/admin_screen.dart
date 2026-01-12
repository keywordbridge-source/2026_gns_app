import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../services/additional_fee_service.dart';
import '../../models/reservation.dart';
import 'admin/manual_reservation_screen.dart';
import 'admin/edit_reservation_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  DateTime _selectedDate = DateTime.now();
  List<Reservation>? _reservations;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final reservations = await FirebaseService.getReservationsByDate(_selectedDate);
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

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
      _loadReservations();
    }
  }

  Future<void> _startUsage(Reservation reservation) async {
    try {
      final updatedReservation = reservation.copyWith(
        status: ReservationStatus.inUse,
        usageStartTime: DateTime.now(),
      );
      await FirebaseService.updateReservation(updatedReservation);
      
      // 추가 요금 계산 시작 (백그라운드)
      AdditionalFeeService.calculateAndUpdateAdditionalFee(updatedReservation);
      
      await _loadReservations();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사용 시작 처리되었습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('처리 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  Future<void> _showWeeklyRevenue() async {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    setState(() {
      _isLoading = true;
    });

    try {
      final reservations = await FirebaseService.getReservationsByDateRange(
        startOfWeek,
        endOfWeek,
      );
      
      int totalRevenue = 0;
      int totalReservations = 0;
      int totalAdditionalFee = 0;
      
      for (final reservation in reservations) {
        if (reservation.status != ReservationStatus.cancelled) {
          totalRevenue += reservation.totalAmount;
          if (reservation.additionalFee != null) {
            totalAdditionalFee += reservation.additionalFee!;
          }
          totalReservations++;
        }
      }
      
      final grandTotal = totalRevenue + totalAdditionalFee;
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('주간 매출'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '기간: ${DateFormat('yyyy-MM-dd').format(startOfWeek)} ~ ${DateFormat('yyyy-MM-dd').format(endOfWeek)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text('총 예약 수: $totalReservations건'),
                  const SizedBox(height: 8),
                  Text(
                    '기본 요금: ${totalRevenue.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        )}원',
                  ),
                  Text(
                    '추가 요금: ${totalAdditionalFee.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        )}원',
                  ),
                  const Divider(),
                  Text(
                    '총 매출: ${grandTotal.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        )}원',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('주간 매출 조회 중 오류: $e')),
        );
      }
    }
  }

  Future<void> _showManualReservation() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ManualReservationScreen(),
      ),
    );
    
    if (result == true) {
      await _loadReservations();
    }
  }

  Future<void> _editReservation(Reservation reservation) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditReservationScreen(reservation: reservation),
      ),
    );
    
    if (result == true) {
      await _loadReservations();
    }
  }

  Future<void> _deleteReservation(Reservation reservation) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('예약 삭제'),
        content: const Text('정말로 이 예약을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseService.deleteReservation(reservation.id);
        await _loadReservations();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('예약이 삭제되었습니다.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('삭제 중 오류가 발생했습니다: $e')),
          );
        }
      }
    }
  }

  int _calculateDailyRevenue() {
    if (_reservations == null) return 0;
    return _reservations!
        .where((r) => r.status != ReservationStatus.cancelled)
        .fold(0, (sum, r) {
          final baseAmount = sum + r.totalAmount;
          final additionalFee = r.additionalFee ?? 0;
          return baseAmount + additionalFee;
        });
  }

  Future<void> _calculateAdditionalFeeForReservation(Reservation reservation) async {
    if (reservation.usageStartTime == null) return;
    
    try {
      await AdditionalFeeService.calculateAndUpdateAdditionalFee(reservation);
      await _loadReservations();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('추가 요금이 계산되었습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('추가 요금 계산 중 오류: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
            return Scaffold(
      appBar: AppBar(
        title: const Text('관리자'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_view_week),
            onPressed: _showWeeklyRevenue,
            tooltip: '주간 매출',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showManualReservation,
            tooltip: '수동 예약',
          ),
          PopupMenuButton(
            icon: const Icon(Icons.inventory_2),
            tooltip: '키트 관리',
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add',
                child: Text('키트 추가'),
              ),
              const PopupMenuItem(
                value: 'batch',
                child: Text('키트 일괄 추가'),
              ),
            ],
            onSelected: (value) {
              if (value == 'add') {
                context.push('/admin/add-kit');
              } else if (value == 'batch') {
                context.push('/admin/batch-add-kits');
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('yyyy-MM-dd').format(_selectedDate),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _selectDate,
                              child: const Text('날짜 선택'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '일일 매출: ${_calculateDailyRevenue().toString().replaceAllMapped(
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
                if (_reservations == null || _reservations!.isEmpty)
                  const Center(child: Text('예약이 없습니다.'))
                else
                  ..._reservations!.map((reservation) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(reservation.buildKitName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${reservation.customerName} (${reservation.customerPhone})'),
                            Text('${reservation.startHour}시 - ${reservation.startHour + reservation.durationHours}시'),
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (reservation.status == ReservationStatus.confirmed)
                              ElevatedButton(
                                onPressed: () => _startUsage(reservation),
                                child: const Text('사용시작'),
                              ),
                            if (reservation.status == ReservationStatus.inUse)
                              ElevatedButton(
                                onPressed: () => _calculateAdditionalFeeForReservation(reservation),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('추가요금계산'),
                              ),
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('변경'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('삭제'),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _editReservation(reservation);
                                } else if (value == 'delete') {
                                  _deleteReservation(reservation);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
    );
  }
}
