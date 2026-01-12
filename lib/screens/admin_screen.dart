import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../services/additional_fee_service.dart';
import '../../models/reservation.dart';
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
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    int totalRevenue = 0;
    int totalReservations = 0;
    
    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final reservations = await FirebaseService.getReservationsByDate(date);
      
      for (final reservation in reservations) {
        if (reservation.status != ReservationStatus.cancelled) {
          totalRevenue += reservation.totalAmount;
          if (reservation.additionalFee != null) {
            totalRevenue += reservation.additionalFee!;
          }
          totalReservations++;
        }
      }
    }
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('주간 매출'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('기간: ${DateFormat('yyyy-MM-dd').format(startOfWeek)} ~ ${DateFormat('yyyy-MM-dd').format(endOfWeek)}'),
              Text('총 예약 수: $totalReservations건'),
              Text(
                '총 매출: ${totalRevenue.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]},',
                    )}원',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
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
  }

  Future<void> _showManualReservation() async {
    // 수동 예약 기능은 별도 화면으로 구현 필요
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('수동 예약 기능은 준비 중입니다.')),
      );
    }
  }

  Future<void> _editReservation(Reservation reservation) async {
    // 예약 변경 기능은 별도 화면으로 구현 필요
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('예약 변경 기능은 준비 중입니다.')),
      );
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
        .fold(0, (sum, r) => sum + r.totalAmount);
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
