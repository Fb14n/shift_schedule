import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shift_schedule/services/api_service.dart';
import 'package:shift_schedule/ui/custom_scaffold.dart';
import 'package:shift_schedule/ui/widgets/day_cell.dart';
import 'package:shift_schedule/utils/load_shifts.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  //final DateTime _firstDay = DateTime.now().subtract(const Duration(days: 30));
  final DateTime _firstDay = DateTime(
    DateTime.now().month == 1 ? DateTime.now().year - 1 : DateTime.now().year,
    DateTime.now().month == 1 ? 12 : DateTime.now().month - 1,
    1,
  );
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 180));
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, String> _shifts = {};
  bool _isLoading = true;
  final ApiService apiService = ApiService();
  bool _isNextEnabled = true;
  bool _isPrevEnabled = true;

  @override
  void initState() {
    super.initState();
    _updateNavigationButtons();
    _loadShifts();
  }

  void _updateNavigationButtons() {
    final focusedMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final firstMonth = DateTime(_firstDay.year, _firstDay.month, 1);
    final lastMonth = DateTime(_lastDay.year, _lastDay.month, 1);
    setState(() {
      _isPrevEnabled = focusedMonth.isAfter(firstMonth);
      _isNextEnabled = focusedMonth.isBefore(lastMonth);
    });
  }

  Future<void> _loadShifts() async {
    setState(() {
      _isLoading = true; // sicherstellen, dass Loader angezeigt wird
    });

    try {
      final apiService = ApiService();
      final token = await apiService.getToken(); // Secure Storage
      if (token == null) {
        log('No token found, user not logged in', name: 'CalendarView');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final shifts = await loadShifts(token); // API-Call
      if (!mounted) return; // Widget wurde evtl. disposed

      setState(() {
        _shifts = shifts;
        _isLoading = false;
        log('Shifts successfully loaded.', name: 'CalendarView');
      });
    } catch (e, stack) {
      log('Error loading shifts: $e', name: 'CalendarView');
      log('$stack', name: 'CalendarView');

      // Loader beenden, sonst Infinite Loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final isCurrentMonth = _focusedDay.year == DateTime.now().year &&
        _focusedDay.month == DateTime.now().month;

    return CustomScaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TableCalendar(
                  locale: 'de_DE',
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  firstDay: _firstDay,
                  lastDay: _lastDay,
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                      _updateNavigationButtons();
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      return DayCell(day: day,shift: _shifts[DateTime(day.year, day.month, day.day)],);
                    },
                    todayBuilder: (context, day, focusedDay) {
                      return DayCell(day: day, shift: _shifts[DateTime(day.year, day.month, day.day)], highlight: Colors.purple);
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      return DayCell(day: day, shift: _shifts[DateTime(day.year, day.month, day.day)], highlight: Colors.yellow);
                    },
                  ),
                  headerStyle: HeaderStyle(
                    leftChevronVisible: _isPrevEnabled,
                    rightChevronVisible: _isNextEnabled,
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
                if (_selectedDay != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Schicht: ${_selectedDay!.day}.${_selectedDay!.month}.${_selectedDay!.year} - ${_shifts[_selectedDay] ?? 'Keine Schicht'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Visibility(
              visible: !isCurrentMonth,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime.now();
                    _updateNavigationButtons();
                  });
                },
                child: const Icon(Icons.today),
                tooltip: 'Zum aktuellen Monat springen',
              ),
            ),
          ),
        ],
      ),
    );
  }
}