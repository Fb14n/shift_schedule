import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shift_schedule/ui/themes/theme.dart';
import 'package:shift_schedule/utils/get_color_contrast.dart';
import 'day_timeline.dart';
import 'package:go_router/go_router.dart';


class DayDetailPopup extends StatelessWidget {
  final DateTime day;
  final List<Map<String, dynamic>> shifts;
  final VoidCallback? onClose;
  final bool showEditButton;
  final Map<String, dynamic>? user;

  const DayDetailPopup({super.key, required this.day, required this.shifts, this.onClose, this.showEditButton = false, this.user});

  double _timeToDouble(String time) {
    try {
      final parts = time.split(':');
      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);
      return hours + (minutes / 60.0);
    } catch (e) {
      return 0.0;
    }
  }

  Color _hexToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final title = '${day.day}.${day.month}.${day.year}';
    final shiftEntries = shifts.map((shift) {
      double startHour = _timeToDouble(shift['type_time_start'] ?? '00:00:00');
      double endHour = _timeToDouble(shift['type_time_end'] ?? '00:00:00');

      if (endHour <= startHour) {
        endHour = 24.0;
      }

      final Color shiftColor = _hexToColor(shift['type_color'] ?? '#808080');
      final Color textColor = getColorContrast(shiftColor);
      return ShiftEntry(
        startHour: startHour,
        endHour: endHour,
        label: shift['type_name'] ?? 'Unbekannt',
        color: shiftColor,
        textColor: textColor,
      );
    }).toList();

    final Map<String, dynamic>? firstShift = shifts.isNotEmpty ? shifts[0] : null;
    final now = DateTime.now();
    final todayOnly = DateTime(now.year, now.month, now.day);
    final isPast = DateTime(day.year, day.month, day.day).isBefore(todayOnly);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        if (onClose != null) onClose!();
      },
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {},
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CHRONOSTheme.of(context).popUpBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: CHRONOSTheme.of(context).popUpShadow,
                      blurRadius: 12
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )
                          )
                      ),
                      if (showEditButton)
                        IconButton(
                          icon: const Icon(Symbols.edit_rounded),
                          tooltip: isPast
                              ? 'Vergangene Schichten können nicht bearbeitet werden'
                              : 'Schicht bearbeiten',
                          onPressed: isPast
                              ? null
                              : () async {
                            Navigator.of(context).pop();
                            final res = await context.pushNamed('edit_shift', extra: {
                              'shift': firstShift,
                              'date': day.toIso8601String(),
                              'user': user,
                            });
                            if (res == true && onClose != null) onClose!();
                          },
                          color: isPast ? Theme.of(context).disabledColor : null,
                        ),
                      IconButton(
                        icon: const Icon(Symbols.close_rounded),
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (onClose != null) onClose!();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: shiftEntries.isEmpty
                        ? DayTimeline(shifts: [])
                        : DayTimeline(shifts: shiftEntries),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}