import 'package:flutter/material.dart';
import 'package:shift_schedule/ui/themes/theme.dart';
import 'day_timeline.dart';

class DayDetailPopup extends StatelessWidget {
  final DateTime day;
  final List<Map<String, dynamic>> shifts; // Geändert zu Map
  final VoidCallback? onClose;

  const DayDetailPopup({super.key, required this.day, required this.shifts, this.onClose});

  // Hilfsfunktion zur Umwandlung von Zeit-Strings (z.B. "06:00:00") in Stunden als double
  double _timeToDouble(String time) {
    try {
      final parts = time.split(':');
      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);
      return hours + (minutes / 60.0);
    } catch (e) {
      return 0.0; // Fallback
    }
  }

  // Hilfsfunktion zur Umwandlung der #RRGGBB Farbe in ein Color-Objekt
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

    // Konvertiere die Shift-Daten aus der API in ShiftEntry-Objekte
    final shiftEntries = shifts.map((shift) {
      double startHour = _timeToDouble(shift['type_time_start'] ?? '00:00:00');
      double endHour = _timeToDouble(shift['type_time_end'] ?? '00:00:00');

      // Sonderfall für Nachtschicht, die über Mitternacht geht
      if (endHour <= startHour) {
        endHour = 24.0;
      }

      return ShiftEntry(
        startHour: startHour,
        endHour: endHour,
        label: shift['type_name'] ?? 'Unbekannt',
        color: _hexToColor(shift['type_color'] ?? '#808080'),
      );
    }).toList();

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white, // CHRONOSTheme.onBackground,
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
                child: shiftEntries.isEmpty
                    ? Center(child: Text('Keine Schicht'))
                    : DayTimeline(shifts: shiftEntries), // Verwende die konvertierten Einträge
              ),
            ],
          ),
        ),
      ),
    );
  }
}