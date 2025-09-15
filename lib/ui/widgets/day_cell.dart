import 'package:flutter/material.dart';

class CalendarDayDecoration {
  final Color color;
  const CalendarDayDecoration({required this.color});

  BoxDecoration get decoration => BoxDecoration(
    color: color,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.black, width: 0),
  );
}

class DayCell extends StatelessWidget {
  const DayCell({
    super.key,
    required this.day,
    required this.shift,
    this.highlight
  });

  final DateTime day;
  final String? shift;
  final Color? highlight;


  Color _getBackgroundColor() {
    switch (shift) {
      case 'Frühschicht':
        return Colors.green;
      case 'Spätschicht':
        return Colors.blue;
      case 'Urlaub':
        return Colors.orange;
      case 'Krankheit':
      case 'Krank':
        return Colors.red;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CalendarDayDecoration(
        color: highlight ?? _getBackgroundColor(),
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