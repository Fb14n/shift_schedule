import 'package:flutter/material.dart';

class HolidayEditorView extends StatefulWidget {
  const HolidayEditorView({super.key});

  @override
  State<HolidayEditorView> createState() => _HolidayEditorViewState();
}

class _HolidayEditorViewState extends State<HolidayEditorView> {
  final List<String> users = ['Alice', 'Bob', 'Charlie', 'Diana'];
  final List<DateTime> days = List.generate(
    7,
        (index) => DateTime.now().add(Duration(days: index)),
  );

  final Map<String, Map<DateTime, String>> shifts = {
    'Alice': {
      DateTime.now(): 'Früh',
      DateTime.now().add(Duration(days: 1)): 'Spät',
    },
    'Bob': {
      DateTime.now(): 'Spät',
      DateTime.now().add(Duration(days: 2)): 'Früh',
    },
    'Charlie': {
      DateTime.now().add(Duration(days: 3)): 'Früh',
    },
    'Diana': {
      DateTime.now().add(Duration(days: 4)): 'Spät',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holiday Editor'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: [
              const DataColumn(label: Text('User')),
              ...days.map((day) {
                return DataColumn(
                  label: Text('${day.day}.${day.month}.${day.year}'),
                );
              }).toList(),
            ],
            rows: users.map((user) {
              return DataRow(
                cells: [
                  DataCell(Text(user)),
                  ...days.map((day) {
                    final shift = shifts[user]?[DateTime(day.year, day.month, day.day)] ?? '';
                    return DataCell(Text(shift));
                  }).toList(),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}