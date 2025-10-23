import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shift_schedule/services/api_service.dart';
import 'package:shift_schedule/ui/custom_scaffold.dart';
import 'package:shift_schedule/ui/themes/theme.dart';
import 'package:shift_schedule/ui/widgets/day_cell.dart';
import 'package:shift_schedule/utils/load_shifts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shift_schedule/ui/widgets/day_detail_popup.dart';
import 'package:shift_schedule/ui/widgets/day_timeline.dart';

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
  bool _isAdmin = false;
  Map<String, Color> _shiftColors = {}; // NEU: Map für Farben

  @override
  void initState() {
    super.initState();
    _updateNavigationButtons();
    _loadAllData(); // NEU: Kombinierte Ladefunktion
    _checkAdminStatus();
  }

  // --- NEUE METHODE zum Laden der Farben ---
  Future<void> _loadShiftColors() async {
    try {
      final types = await apiService.getShiftTypes();
      final Map<String, Color> colorMap = {};
      for (var type in types) {
        final colorString = type['type_color'] as String?;
        if (colorString != null && colorString.startsWith('#') && colorString.length == 7) {
          final colorValue = int.parse(colorString.substring(1), radix: 16) + 0xFF000000;
          colorMap[type['type_name']] = Color(colorValue);
        }
      }
      if (mounted) {
        setState(() {
          _shiftColors = colorMap;
        });
      }
    } catch (e) {
      log('Error loading shift colors: $e', name: 'CalendarView');
    }
  }
  // --- ENDE NEUE METHODE ---

  Future<void> _checkAdminStatus() async {
    try {
      final apiService = ApiService();
      final userDetails = await apiService.fetchUserDetails();
      log('User details: $userDetails', name: 'CalendarView');
      if (userDetails['first_name'] == 'Bob') {
        if(mounted) {
          setState(() {
            _isAdmin = true;
          });
        }
      }
    } catch (e) {
      log('Error checking admin status: $e', name: 'CalendarView');
    }
  }

  void _updateNavigationButtons() {
    final focusedMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final firstMonth = DateTime(_firstDay.year, _firstDay.month, 1);
    final lastMonth = DateTime(_lastDay.year, _lastDay.month, 1);
    if(mounted) {
      setState(() {
        _isPrevEnabled = focusedMonth.isAfter(firstMonth);
        _isNextEnabled = focusedMonth.isBefore(lastMonth);
      });
    }
  }

  // --- AKTUALISIERTE METHODE ---
  Future<void> _loadAllData() async {
    if(mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // Lade Schichten und Farben parallel
      await Future.wait([
        _loadShifts(),
        _loadShiftColors(),
      ]);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadShifts() async {
    try {
      final token = await apiService.getToken();
      if (token == null) {
        log('No token found', name: 'CalendarView');
        return;
      }
      final shiftsData = await apiService.fetchShifts(token); // Annahme: api_service hat fetchShifts
      if (!mounted) return;

      final Map<DateTime, String> shiftsMap = {};
      for (var shift in shiftsData) {
        final date = DateTime.parse(shift['shift_date']);
        final dayOnly = DateTime(date.year, date.month, date.day);
        shiftsMap[dayOnly] = shift['type_name'];
      }

      setState(() {
        _shifts = shiftsMap;
        log('Shifts successfully loaded.', name: 'CalendarView');
      });
    } catch (e, stack) {
      log('Error loading shifts: $e', name: 'CalendarView');
      log('$stack', name: 'CalendarView');
    }
  }

  void _showDayPopup(DateTime selectedDay) {
    List<ShiftEntry> parsed = [];
    final raw = _shifts[DateTime(selectedDay.year, selectedDay.month, selectedDay.day)];
    if (raw != null) {
      final parts = raw.split(RegExp(r'[,\;]')).map((s) => s.trim());
      for (final p in parts) {
        final m = RegExp(r'(\d{1,2})(?::\d{2})?-(\d{1,2})(?::\d{2})?').firstMatch(p);
        if (m != null) {
          final sh = int.parse(m.group(1)!);
          final eh = int.parse(m.group(2)!);
          parsed.add(ShiftEntry(startHour: sh, endHour: eh, label: p, color: _shiftColors[p] ?? Colors.blueAccent));
        } else {
          parsed.add(ShiftEntry(startHour: 0, endHour: 24, label: p, color: _shiftColors[p] ?? Colors.grey));
        }
      }
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tag schließen',
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, anim1, anim2) {
        return DayDetailPopup(day: selectedDay, shifts: parsed);
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
      return const Center(child: CircularProgressIndicator());
    }
    final isCurrentMonth = _focusedDay.year == DateTime.now().year &&
        _focusedDay.month == DateTime.now().month;

    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Column(
              children: [
                TableCalendar(
                  rowHeight: MediaQuery.of(context).size.height * 0.6/5,
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
                    _showDayPopup(selectedDay);
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                      _updateNavigationButtons();
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final shiftType = _shifts[DateTime(day.year, day.month, day.day)];
                      return DayCell(
                        day: day,
                        shiftColor: _shiftColors[shiftType] ?? DayCellColors().defaultColor,
                        shift: shiftType,
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      final shiftType = _shifts[DateTime(day.year, day.month, day.day)];
                      return DayCell(
                        day: day,
                        shift: shiftType,
                        shiftColor: _shiftColors[shiftType] ?? DayCellColors().defaultColor,
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      final shiftType = _shifts[DateTime(day.year, day.month, day.day)];
                      return DayCell(
                        day: day,
                        shift: shiftType,
                        shiftColor: _shiftColors[shiftType] ?? DayCellColors().defaultColor,
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
            Positioned(
              bottom: 24,
              right: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- Block für Admin-Buttons ---
                  Visibility(
                      visible: _isAdmin,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloatingActionButton(
                            heroTag: 'editButton',
                            onPressed: () {
                              context.pushNamed('holidayEditor');
                            },
                            tooltip: 'Feiertage bearbeiten',
                            backgroundColor: CHRONOSTheme.secondary,
                            child: const Icon(Icons.edit_calendar, color: CHRONOSTheme.onSecondary),
                          ),
                        ],
                      )
                  ),
                  // --- Ende Admin-Buttons ---
                  const SizedBox(height: 16),
                  Visibility(
                    visible: !isCurrentMonth,
                    child: FloatingActionButton(
                      heroTag: 'todayButton',
                      onPressed: () {
                        setState(() {
                          _focusedDay = DateTime.now();
                          _updateNavigationButtons();
                        });
                      },
                      tooltip: 'Zum aktuellen Monat springen',
                      backgroundColor: CHRONOSTheme.primary,
                      child: const Icon(Symbols.today_rounded, color: CHRONOSTheme.onPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}