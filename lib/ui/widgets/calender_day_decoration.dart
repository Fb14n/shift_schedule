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