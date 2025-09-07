/*
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shift_schedule/services/api_service.dart';

class ShiftsScreen extends StatefulWidget {
  const ShiftsScreen({super.key});

  @override
  _ShiftsScreenState createState() => _ShiftsScreenState();
}

class _ShiftsScreenState extends State<ShiftsScreen> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> shifts = [];

  @override
  void initState() {
    super.initState();
    _loadShifts();
  }

  Future<void> _loadShifts() async {
    try {
      final data = await apiService.fetchShiftsWithUsers();
      setState(() {
        shifts = data;
      });
    } catch (e) {
      log('Error loading shifts: $e', name: 'ShiftsScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shifts')),
      body: ListView.builder(
        itemCount: shifts.length,
        itemBuilder: (context, index) {
          final shift = shifts[index];
          return ListTile(
            title: Text('${shift['user_name']} - ${shift['shift_date']}'),
            subtitle: Text(shift['shift_type']),
          );
        },
      ),
    );
  }
}*/
