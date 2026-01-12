import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../services/firebase_service.dart';
import '../../models/reservation.dart';
import '../../models/pricing.dart';
import '../../config/app_config.dart';

class ManualReservationScreen extends StatefulWidget {
  const ManualReservationScreen({super.key});

  @override
  State<ManualReservationScreen> createState() => _ManualReservationScreenState();
}

class _ManualReservationScreenState extends State<ManualReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _kitNameController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _customerPasswordController = TextEditingController();
  
  DateTime? _selectedDate;
  int? _selectedStartHour;
  int? _selectedDuration;
  int? _selectedSeat;
  bool _isLoading = false;

  @override
  void dispose() {
    _kitNameController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailableSeats() async {
    if (_selectedDate == null || _selectedStartHour == null || _selectedDuration == null) {
      return;
    }

    try {
      final seats = await FirebaseService.getAvailableSeats(
        _selectedDate!,
        _selectedStartHour!,
        _selectedDuration!,
      );
      
      if (mounted && seats.isNotEmpty) {
        setState(() {
          _selectedSeat = seats.first;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('좌석 확인 중 오류: $e')),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null ||
        _selectedStartHour == null ||
        _selectedDuration == null ||
        _selectedSeat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final reservation = Reservation(
        id: '',
        buildKitId: '', // 수동 예약은 키트 ID 없이 이름만
        buildKitName: _kitNameController.text,
        durationHours: _selectedDuration!,
        date: _selectedDate!,
        startHour: _selectedStartHour!,
        seatNumber: _selectedSeat!,
        customerName: _customerNameController.text,
        customerPhone: _customerPhoneController.text,
        customerPassword: _customerPasswordController.text,
        totalAmount: Pricing.getPrice(_selectedDuration!),
        status: ReservationStatus.confirmed,
        paymentDate: DateTime.now(),
        paymentId: 'manual_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
      );

      await FirebaseService.createReservation(reservation);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('수동 예약이 완료되었습니다.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('예약 생성 중 오류: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('수동 예약')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _kitNameController,
              decoration: const InputDecoration(
                labelText: '키트 이름 *',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? '키트 이름을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _customerNameController,
              decoration: const InputDecoration(
                labelText: '예약자 이름 *',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? '이름을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _customerPhoneController,
              decoration: const InputDecoration(
                labelText: '휴대전화번호 *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value == null || value.isEmpty ? '휴대전화번호를 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _customerPasswordController,
              decoration: const InputDecoration(
                labelText: '비밀번호 (4자리) *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) =>
                  value == null || value.length != 4 ? '4자리 숫자를 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: '이용시간 *',
                border: OutlineInputBorder(),
              ),
              value: _selectedDuration,
              items: AppConfig.availableDurations.map((duration) {
                return DropdownMenuItem(
                  value: duration,
                  child: Text('$duration시간 (${Pricing.getPrice(duration).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원)'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDuration = value;
                });
                _loadAvailableSeats();
              },
              validator: (value) => value == null ? '이용시간을 선택하세요' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                    _selectedStartHour = null;
                    _selectedSeat = null;
                  });
                  _loadAvailableSeats();
                }
              },
              child: Text(
                _selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                    : '날짜 선택 *',
              ),
            ),
            if (_selectedDate != null) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: '시작시간 *',
                  border: OutlineInputBorder(),
                ),
                value: _selectedStartHour,
                items: List.generate(
                  AppConfig.endHour - AppConfig.startHour + 1,
                  (index) {
                    final hour = AppConfig.startHour + index;
                    return DropdownMenuItem(
                      value: hour,
                      child: Text('$hour시'),
                    );
                  },
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedStartHour = value;
                  });
                  _loadAvailableSeats();
                },
                validator: (value) => value == null ? '시작시간을 선택하세요' : null,
              ),
            ],
            if (_selectedStartHour != null && _selectedDuration != null) ...[
              const SizedBox(height: 16),
              FutureBuilder<List<int>>(
                future: FirebaseService.getAvailableSeats(
                  _selectedDate!,
                  _selectedStartHour!,
                  _selectedDuration!,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  
                  final availableSeats = snapshot.data ?? [];
                  
                  if (availableSeats.isEmpty) {
                    return const Text(
                      '선택하신 시간에 이용 가능한 좌석이 없습니다.',
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  
                  return DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: '좌석 *',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedSeat ?? availableSeats.first,
                    items: availableSeats.map((seat) {
                      return DropdownMenuItem(
                        value: seat,
                        child: Text('$seat번 좌석'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSeat = value;
                      });
                    },
                    validator: (value) => value == null ? '좌석을 선택하세요' : null,
                  );
                },
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('예약 생성', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
