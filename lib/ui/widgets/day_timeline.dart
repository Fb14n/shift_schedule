import 'package:flutter/material.dart';
import 'package:shift_schedule/ui/themes/theme.dart';


class ShiftEntry {
  final double startHour;
  final double endHour;
  final String label;
  final Color color;
  final Color? textColor;

  ShiftEntry({
    required this.startHour,
    required this.endHour,
    required this.label,
    required this.color,
    this.textColor = Colors.white,
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
                        bottom: BorderSide(
                            color: CHRONOSTheme.of(context).borderColorDefault,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 48,
                          child: Text(
                            '${idx.toString().padLeft(2, '0')}:00',
                            style: TextStyle(
                              fontSize: 12,
                              color: CHRONOSTheme.of(context).borderColorDefault,
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  );
                }),
              ),
              for (final s in shifts)
                Positioned(
                  top: s.startHour * hourHeight,
                  left: 72,
                  right: 12,
                  height: (s.endHour - s.startHour) * hourHeight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: s.color,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: s.color, blurRadius: 6)],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(s.label, style: TextStyle(color: s.textColor, fontWeight: FontWeight.w600)),
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