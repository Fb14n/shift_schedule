import 'package:flutter/material.dart';
import 'package:shift_schedule/ui/themes/theme.dart';
import 'day_timeline.dart';

class DayDetailPopup extends StatelessWidget {
  final DateTime day;
  final List<ShiftEntry> shifts;
  final VoidCallback? onClose;

  const DayDetailPopup({super.key, required this.day, required this.shifts, this.onClose});

  @override
  Widget build(BuildContext context) {
    final title = '${day.day}.${day.month}.${day.year}';
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,//CHRONOSTheme.onBackground,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Header
              Row(
                children: [
                  Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onClose != null) onClose!();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: shifts.isEmpty
                    ? Center(child: Text('Keine Schicht'))
                    : DayTimeline(shifts: shifts),
              ),
            ],
          ),
        ),
      ),
    );
  }
}