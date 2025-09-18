import 'package:flutter/material.dart';
import 'package:shift_schedule/ui/themes/theme.dart';

class CalendarDayDecoration {
  final Color color;
  final Color borderColor;
  const CalendarDayDecoration({required this.borderColor, required this.color});

  BoxDecoration get decoration => BoxDecoration(
    color: color,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: borderColor, width: 0),
  );
}

class DayCell extends StatelessWidget {
  const DayCell({
    super.key,
    required this.day,
    required this.shift,
    this.highlight,
    this.borderColor,
    this.textColor,
  });

  final DateTime day;
  final String? shift;
  final Color? highlight;
  final Color? borderColor;
  final Color? textColor;

  Map<String, Color> getColors() {
    switch (shift) {
      case 'Frühschicht':
        return {
          'background': FEZTheme.dayCellColors.earlyShift,
        };
      case 'Spätschicht':
        return {
          'background': FEZTheme.dayCellColors.lateShift,
          'text': FEZTheme.dayCellColors.onLateShift,
        };
      case 'Urlaub':
        return {
          'background': FEZTheme.dayCellColors.holiday,
          'text': FEZTheme.dayCellColors.onHoliday,
        };
      case 'Krankheit':
      case 'Krank':
        return {
          'background': FEZTheme.dayCellColors.sick,
          'text': FEZTheme.dayCellColors.onSick,
        };
      default:
        return {
          'background': FEZTheme.dayCellColors.defaultColor,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = getColors();
    return Container(
      decoration: CalendarDayDecoration(
        color: highlight ?? colors['background']!,
        borderColor: borderColor ?? FEZTheme.borderColorDefault(context),
      ).decoration,
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(color: textColor ?? colors['text']),
      ),
    );
  }
}