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
    this.borderColor = FEZTheme.borderColorDefault,
  });

  final DateTime day;
  final String? shift;
  final Color? highlight;
  final Color borderColor;


  Color getBackgroundColor() {
    switch (shift) {
      case 'Frühschicht':
        return FEZTheme.dayCellColors.earlyShift;
      case 'Spätschicht':
        return FEZTheme.dayCellColors.lateShift;
      case 'Urlaub':
        return FEZTheme.dayCellColors.holiday;
      case 'Krankheit':
      case 'Krank':
        return FEZTheme.dayCellColors.sick;
      default:
        return FEZTheme.dayCellColors.defaultColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CalendarDayDecoration(
        color: highlight ?? getBackgroundColor(),
        borderColor: borderColor,
      ).decoration,
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}