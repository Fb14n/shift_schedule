import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shift_schedule/services/api_service.dart';
import 'package:shift_schedule/ui/custom_scaffold.dart';
import 'package:shift_schedule/ui/widgets/calender_day_decoration.dart';
import 'package:shift_schedule/utils/load_shifts.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final DateTime _firstDay = DateTime.now().subtract(const Duration(days: 30));
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 180));
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, String> _shifts = {};
  bool _isLoading = true;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadShifts();
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


  Widget _buildDayCell(DateTime day, String? shift, {Color? highlight}) {
    Color backgroundColor;

    switch (shift) {
      case 'Frühschicht':
        backgroundColor = Colors.green;
        break;
      case 'Spätschicht':
        backgroundColor = Colors.blue;
        break;
      case 'Urlaub':
        backgroundColor = Colors.orange;
        break;
      case 'Krankheit':
      case 'Krank':
        backgroundColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.transparent;
    }

    return Container(
      decoration: CalendarDayDecoration(
        color: highlight ?? backgroundColor,
      ).decoration,
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return CustomScaffold(
      body: Column(
        children: [
          TableCalendar(
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
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return _buildDayCell(day, _shifts[DateTime(day.year, day.month, day.day)]);
              },
              todayBuilder: (context, day, focusedDay) {
                return _buildDayCell(day, _shifts[DateTime(day.year, day.month, day.day)], highlight: Colors.purple);
              },
              selectedBuilder: (context, day, focusedDay) {
                return _buildDayCell(day, _shifts[DateTime(day.year, day.month, day.day)], highlight: Colors.yellow);
              },
            ),
            headerStyle: HeaderStyle(
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
    );
  }
}