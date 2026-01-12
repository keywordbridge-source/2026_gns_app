import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/reservation_provider.dart';
import '../../config/app_config.dart';

class DateTimeSelectionScreen extends ConsumerStatefulWidget {
  const DateTimeSelectionScreen({super.key});

  @override
  ConsumerState<DateTimeSelectionScreen> createState() =>
      _DateTimeSelectionScreenState();
}

class _DateTimeSelectionScreenState
    extends ConsumerState<DateTimeSelectionScreen> {
  DateTime? _selectedDate;
  int? _selectedHour;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final minDate = DateTime(today.year, today.month, today.day);

    return Scaffold(
      appBar: AppBar(title: const Text('날짜 및 시작시간 선택')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '날짜 선택',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? today,
                firstDate: minDate,
                lastDate: minDate.add(const Duration(days: 30)),
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                  _selectedHour = null;
                });
                ref.read(reservationProvider.notifier).selectDate(date);
              }
            },
            child: Text(
              _selectedDate != null
                  ? DateFormat('yyyy년 MM월 dd일').format(_selectedDate!)
                  : '날짜를 선택하세요',
            ),
          ),
          if (_selectedDate != null) ...[
            const SizedBox(height: 32),
            const Text(
              '시작시간 선택',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              AppConfig.endHour - AppConfig.startHour + 1,
              (index) {
                final hour = AppConfig.startHour + index;
                final isSelected = _selectedHour == hour;
                final isToday = _selectedDate!.year == today.year &&
                    _selectedDate!.month == today.month &&
                    _selectedDate!.day == today.day;
                final isPast = isToday && hour <= today.hour;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: isPast ? Colors.grey[300] : null,
                  child: ListTile(
                    title: Text('$hour시'),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    onTap: isPast
                        ? null
                        : () {
                            setState(() {
                              _selectedHour = hour;
                            });
                            ref
                                .read(reservationProvider.notifier)
                                .selectStartHour(hour);
                            context.push('/seat-selection');
                          },
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
