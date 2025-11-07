import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shift_schedule/services/api_service.dart';
import 'package:shift_schedule/ui/custom_scaffold.dart';
import 'package:shift_schedule/ui/themes/theme.dart';
import 'package:shift_schedule/ui/widgets/day_cell.dart';
import 'package:shift_schedule/ui/widgets/floating_action_button.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shift_schedule/ui/widgets/day_detail_popup.dart';
import 'package:shift_schedule/utils/get_color_contrast.dart';


class AdminCalendarView extends StatefulWidget {
  final Map<String, dynamic> user;
  const AdminCalendarView({super.key, required this.user});

  @override
  State<AdminCalendarView> createState() => _AdminCalendarViewState();
}

class _AdminCalendarViewState extends State<AdminCalendarView> {
  final DateTime _firstDay = DateTime(
    DateTime.now().month == 1 ? DateTime.now().year - 1 : DateTime.now().year,
    DateTime.now().month == 1 ? 12 : DateTime.now().month - 1,
    1,
  );
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 180));
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, Map<String, dynamic>> _shifts = {};
  bool _isLoading = true;
  final ApiService apiService = ApiService();
  bool _isNextEnabled = true;
  bool _isPrevEnabled = true;
  Map<String, Color> _shiftColors = {};
  Map<String, Color> _shiftTextColors = {};

  late Map<String, dynamic> _user;

  @override
  void initState() {
    super.initState();
    _user = Map<String, dynamic>.from(widget.user);
    _updateNavigationButtons();
    _loadAllData(showLoadingScreen: true);
  }

  Future<void> _loadShiftColors() async {
    try {
      final types = await apiService.getShiftTypes();
      final Map<String, Color> colorMap = {};
      final Map<String, Color> textColorMap = {};
      for (var type in types) {
        final colorString = type['type_color'] as String?;
        if (colorString != null &&
            colorString.startsWith('#') &&
            colorString.length == 7) {
          final colorValue =
              int.parse(colorString.substring(1), radix: 16) + 0xFF000000;
          final backgroundColor = Color(colorValue);
          final typeName = type['type_name'] as String;

          colorMap[typeName] = backgroundColor;
          textColorMap[typeName] = getColorContrast(backgroundColor);
        }
      }
      if (mounted) {
        setState(() {
          _shiftColors = colorMap;
          _shiftTextColors = textColorMap;
        });
      }
    } catch (e) {
      log('Error loading shift colors: $e', name: 'AdminCalendarView');
    }
  }

  void _updateNavigationButtons() {
    final focusedMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final firstMonth = DateTime(_firstDay.year, _firstDay.month, 1);
    final lastMonth = DateTime(_lastDay.year, _lastDay.month, 1);
    if (mounted) {
      setState(() {
        _isPrevEnabled = focusedMonth.isAfter(firstMonth);
        _isNextEnabled = focusedMonth.isBefore(lastMonth);
      });
    }
  }

  Future<void> _loadAllData({bool showLoadingScreen = false}) async {
    if (mounted && showLoadingScreen) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      await Future.wait([
        _loadShifts(),
        _loadShiftColors(),
      ]);
    } finally {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadShifts() async {
    try {
      final userId = _user['id'] as int?;
      if (userId == null) {
        log('User-ID not found in widget data', name: 'AdminCalendarView');
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final shiftsData = await apiService.fetchShiftsForUser(userId);
      if (!mounted) return;

      final Map<DateTime, Map<String, dynamic>> shiftsMap = {};
      for (var shift in shiftsData) {
        final date = DateTime.parse(shift['shift_date']);
        final dayOnly = DateTime(date.year, date.month, date.day);
        shiftsMap[dayOnly] = shift;
      }

      setState(() {
        _shifts = shiftsMap;
        log('Shifts for user $userId successfully loaded.', name: 'AdminCalendarView');
      });
    } catch (e, stack) {
      log('Error loading shifts for user: $e', name: 'AdminCalendarView');
      log('$stack', name: 'AdminCalendarView');
    }
  }

  void _showDayPopup(DateTime selectedDay) {
    final dayKey = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    final List<Map<String, dynamic>> shiftsForDay = [];

    if (_shifts.containsKey(dayKey)) {
      shiftsForDay.add(_shifts[dayKey]!);
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tag schließen',
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, anim1, anim2) {
        return Theme(
          data: Theme.of(this.context),
          child: DayDetailPopup(
            showEditButton: true,
            day: selectedDay,
            shifts: shiftsForDay,
            onClose: () {
              _loadAllData();
            },
            user: _user,
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = Curves.easeOut.transform(animation.value);
        return Transform.scale(
          scale: 0.92 + 0.08 * curved,
          child: Opacity(opacity: animation.value, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CustomScaffold(
          title: Text('Lade Kalender: ${_user['last_name'] ?? 'Mitarbeiter'}'),
          body: const Column(
              children: [
                SizedBox(height: 20),
                Center(child: CircularProgressIndicator(color: CHRONOSTheme.secondary))
              ])
      );
    }
    final userName = '${_user['first_name'] ?? ''} ${_user['last_name'] ?? ''}';
    return CustomScaffold(
      trailingIcon: IconButton(
        icon: const Icon(Symbols.edit_rounded),
        onPressed: () async {
          final res = await context.pushNamed('edit_user', extra: _user);
          if (res is Map<String, dynamic>) {
            setState(() {
              _user = Map<String, dynamic>.from(res);
            });
            await _loadAllData(showLoadingScreen: false);
          } else if (res == true) {
            await _loadAllData(showLoadingScreen: false);
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomFloatingActionButton(
            heroTag: 'editTodayButton',
            tooltip: 'Schicht für heute bearbeiten/anlegen',
            icon: Symbols.edit_calendar_rounded,
            onPressed: () async {
              final res = await context.pushNamed('edit_shift', extra: {
                'date': DateTime.now().toIso8601String(),
                'user': _user,
              });
              if(res == true) {
                await _loadAllData(showLoadingScreen: false);
              }
            },
            visible: true,
          ),
        ],
      ),
      title: Text(userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      onRefresh: _loadAllData,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Column(
              children: [
                TableCalendar(
                  daysOfWeekHeight: 20,
                  weekendDays: const [DateTime.saturday, DateTime.sunday],
                  loadEventsForDisabledDays: true,
                  rowHeight: MediaQuery.of(context).size.height * 0.6 / 5,
                  locale: 'de_DE',
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  firstDay: _firstDay,
                  lastDay: _lastDay,
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    _showDayPopup(selectedDay);
                    if (selectedDay.month == focusedDay.month) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                        });
                      }
                    } else {
                      setState(() {
                        _selectedDay = null;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                      _updateNavigationButtons();
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final shiftData = _shifts[DateTime(day.year, day.month, day.day)];
                      final shiftType = shiftData?['type_name'] as String?;
                      return Theme(
                        data: Theme.of(this.context),
                        child: DayCell(
                          day: day,
                          shiftColor: _shiftColors[shiftType],
                          shift: shiftType,
                          textColor: _shiftTextColors[shiftType],
                        ),
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      final shiftData = _shifts[DateTime(day.year, day.month, day.day)];
                      final shiftType = shiftData?['type_name'] as String?;
                      return Theme(
                        data: Theme.of(this.context),
                        child: DayCell(
                          day: day,
                          shiftColor: _shiftColors[shiftType],
                          shift: shiftType,
                          textColor: _shiftTextColors[shiftType],
                        ),
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      final shiftData = _shifts[DateTime(day.year, day.month, day.day)];
                      final shiftType = shiftData?['type_name'] as String?;
                      return Theme(
                        data: Theme.of(this.context),
                        child: DayCell(
                          day: day,
                          shiftColor: _shiftColors[shiftType],
                          shift: shiftType,
                          textColor: _shiftTextColors[shiftType],
                        ),
                      );
                    },
                  ),
                  headerStyle: HeaderStyle(
                    leftChevronVisible: _isPrevEnabled,
                    rightChevronVisible: _isNextEnabled,
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}