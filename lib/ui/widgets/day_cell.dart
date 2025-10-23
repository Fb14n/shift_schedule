import 'dart:developer';

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
    this.shiftColor,
    this.borderColor,
    this.textColor,
  });

  final DateTime day;
  final String? shift;
  final Color? shiftColor;
  final Color? borderColor;
  final Color? textColor;

  isToday() {
    final now = DateTime.now();
    if (now.year == day.year && now.month == day.month && now.day == day.day) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CalendarDayDecoration(
        color: Colors.transparent,
        borderColor: borderColor ?? CHRONOSTheme.borderColorDefault(context),
      ).decoration,
      margin: EdgeInsets.fromLTRB(2,4,2,0),
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.fromLTRB(0,4,0,0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isToday() ?? true ? shiftColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: isToday() ?? true ? textColor : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          if (shift != null)
            Container(
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: shiftColor,
              ),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  shift!,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}