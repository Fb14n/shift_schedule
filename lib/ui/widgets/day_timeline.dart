import 'package:flutter/material.dart';


class ShiftEntry {
  final int startHour; // 0-23 (can be fractional hours if needed)
  final int endHour; // 1-24
  final String label;
  final Color color;

  ShiftEntry({
    required this.startHour,
    required this.endHour,
    required this.label,
    this.color = Colors.blueAccent,
  });
}

class DayTimeline extends StatelessWidget {
  final List<ShiftEntry> shifts;

  const DayTimeline({super.key, required this.shifts});

  @override
  Widget build(BuildContext context) {
    final hourHeight = MediaQuery.of(context).size.height / 24 > 60 ? 60.0 : MediaQuery.of(context).size.height / 24;

    return SingleChildScrollView(
      child: SizedBox(
        height: hourHeight * 24,
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Column(
                children: List.generate(24, (idx) {
                  return Container(
                    height: hourHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.withOpacity(0.12)),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 48,
                          child: Text(
                            '${idx.toString().padLeft(2, '0')}:00',
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  );
                }),
              ),
              // Shift-Balken
              for (final s in shifts)
                Positioned(
                  top: s.startHour * hourHeight,
                  left: 72,
                  right: 12,
                  height: (s.endHour - s.startHour) * hourHeight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: s.color.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: s.color.withOpacity(0.25), blurRadius: 6)],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(s.label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}