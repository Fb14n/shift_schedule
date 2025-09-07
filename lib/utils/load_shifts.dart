import 'dart:developer';
import 'package:shift_schedule/services/api_service.dart';

Future<Map<DateTime, String>> loadShifts(String token) async {
  final ApiService apiService = ApiService();
  final Map<DateTime, String> shifts = {};

  try {
    final data = await apiService.fetchShiftsWithUsers(token);

    for (final shift in data) {
      final date = DateTime.tryParse(shift['shift_date']);
      final type = shift['shift_type'];

      if (date != null && type != null) {
        shifts[DateTime(date.year, date.month, date.day)] = type;
      }
    }
  } catch (e) {
    log('Error loading shifts from database: $e', name: 'loadShifts');
  }

  return shifts;
}