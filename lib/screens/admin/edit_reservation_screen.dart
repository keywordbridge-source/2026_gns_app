import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/firebase_service.dart';
import '../../models/reservation.dart';
import '../../models/pricing.dart';
import '../../config/app_config.dart';

class EditReservationScreen extends StatefulWidget {
  final Reservation reservation;

  const EditReservationScreen({
    super.key,
    required this.reservation,
  });

  @override
  State<EditReservationScreen> createState() => _EditReservationScreenState();
}

class _EditReservationScreenState extends State<EditReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _kitNameController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  
  DateTime? _selectedDate;
  int? _selectedStartHour;
  int? _selectedDuration;
  int? _selectedSeat;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _kitNameController.text = widget.reservation.buildKitName;
    _customerNameController.text = widget.reservation.customerName;
    _customerPhoneController.text = widget.reservation.customerPhone;
    _selectedDate = widget.reservation.date;
    _selectedStartHour = widget.reservation.startHour;
    _selectedDuration = widget.reservation.durationHours;
    _selectedSeat = widget.reservation.seatNumber;
  }

  @override
  void dispose() {
    _kitNameController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    super.dispose();
  }

  Future<void> _update() async {
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
      final updatedReservation = widget.reservation.copyWith(
        buildKitName: _kitNameController.text,
        customerName: _customerNameController.text,
        customerPhone: _customerPhoneController.text,
        date: _selectedDate!,
        startHour: _selectedStartHour!,
        durationHours: _selectedDuration!,
        seatNumber: _selectedSeat!,
        totalAmount: Pricing.getPrice(_selectedDuration!),
      );

      await FirebaseService.updateReservation(updatedReservation);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('예약이 수정되었습니다.')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('예약 수정 중 오류: $e')),
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
      appBar: AppBar(title: const Text('예약 수정')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _kitNameController,
              decoration: const InputDecoration(
                labelText: '키트 이름',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? '키트 이름을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _customerNameController,
              decoration: const InputDecoration(
                labelText: '예약자 이름',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? '이름을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _customerPhoneController,
              decoration: const InputDecoration(
                labelText: '휴대전화번호',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value == null || value.isEmpty ? '휴대전화번호를 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: '이용시간',
                border: OutlineInputBorder(),
              ),
              value: _selectedDuration,
              items: AppConfig.availableDurations.map((duration) {
                return DropdownMenuItem(
                  value: duration,
                  child: Text('$duration시간'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDuration = value;
                });
              },
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
                  });
                }
              },
              child: Text(
                _selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                    : '날짜 선택',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: '시작시간',
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
              },
            ),
            const SizedBox(height: 16),
            if (_selectedStartHour != null && _selectedDuration != null)
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
                      labelText: '좌석',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedSeat,
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
                  );
                },
              ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _update,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('수정 완료', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
