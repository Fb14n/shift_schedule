import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shift_schedule/services/api_service.dart';
import 'package:shift_schedule/ui/custom_scaffold.dart';
import 'package:shift_schedule/ui/themes/theme.dart';

class EditShiftPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const EditShiftPage({super.key, this.data});

  @override
  State<EditShiftPage> createState() => _EditShiftPageState();
}

class _EditShiftPageState extends State<EditShiftPage> {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> _shiftTypes = [];
  List<Map<String, dynamic>> _userShifts = [];

  int? _selectedShiftTypeId;
  bool _saving = false;

  Map<String, dynamic>? _existingShift;
  String? _dateIso;
  Map<String, dynamic>? _user;

  late DateTime _startDate;
  late DateTime _endDate;

  Future<void>? _initialLoadFuture;

  @override
  void initState() {
    super.initState();
    _existingShift = widget.data?['shift'] as Map<String, dynamic>?;
    _dateIso = widget.data?['date'] as String?;
    _user = widget.data?['user'] as Map<String, dynamic>?;

    final initial = _dateIso != null ? DateTime.tryParse(_dateIso!) : DateTime.now();
    _startDate = DateTime(initial!.year, initial.month, initial.day);
    _endDate = _startDate;

    _initialLoadFuture = _loadInitialData();
  }

  String _dateLabel(DateTime d) => '${d.day}.${d.month}.${d.year}';
  String _dateIsoOnly(DateTime d) => d.toIso8601String().split('T')[0];

  Future<void> _loadInitialData() async {
    try {
      final types = await _api.getShiftTypes();
      List<Map<String, dynamic>> userShifts = [];
      if (_user != null && _user!['id'] != null) {
        final uid = _user!['id'] as int;
        userShifts = await _api.fetchShiftsForUser(uid);
      } else {
        userShifts = await _api.fetchShiftsStored();
      }

      if (!mounted) return;

      setState(() {
        _shiftTypes = List<Map<String, dynamic>>.from(types);
        _userShifts = List<Map<String, dynamic>>.from(userShifts);
      });

      if (_existingShift != null) {
        int? id;
        final rawId = _existingShift!['shift_type_id'] ?? _existingShift!['type_id'];
        if (rawId is int) {
          id = rawId;
        } else if (rawId != null) id = int.tryParse('$rawId');

        if (id == null && _existingShift!['type_name'] != null) {
          final name = (_existingShift!['type_name']).toString();
          id = _findShiftTypeIdByName(name);
        }

        if (id != null) {
          setState(() => _selectedShiftTypeId = id);
          return;
        }
      }

      _applySelectedDateShift();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fehler beim Laden: $e'), backgroundColor: CHRONOSTheme.error));
      }
    }
  }

  int? _findShiftTypeIdByName(String name) {
    try {
      final found = _shiftTypes.firstWhere((t) {
        final tn = (t['type_name'] ?? t['type']).toString();
        return tn.toLowerCase() == name.toLowerCase();
      }, orElse: () => {});
      if (found.isNotEmpty) {
        final raw = found['id'];
        if (raw is int) return raw;
        return int.tryParse('$raw');
      }
    } catch (_) {}
    return null;
  }

  void _applySelectedDateShift() {
    final dayIso = _dateIsoOnly(_startDate);
    Map<String, dynamic>? found;
    for (var s in _userShifts) {
      final sd = (s['shift_date'] ?? '').toString();
      if (sd.startsWith(dayIso)) {
        found = s;
        break;
      }
    }

    int? id;
    if (found != null) {
      final rawId = found['type_id'] ?? found['shift_type_id'];
      if (rawId is int) {
        id = rawId;
      } else if (rawId != null) id = int.tryParse('$rawId');

      if (id == null && found['type_name'] != null) {
        id = _findShiftTypeIdByName(found['type_name'].toString());
      }
    }

    setState(() {
      _selectedShiftTypeId = id;
    });
  }

  List<DateTime> _datesInRange() {
    final List<DateTime> days = [];
    var cur = DateTime(_startDate.year, _startDate.month, _startDate.day);
    while (!cur.isAfter(_endDate)) {
      days.add(cur);
      cur = cur.add(const Duration(days: 1));
    }
    return days;
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      helpText: 'Zeitraum auswählen',
      confirmText: 'Übernehmen',
      cancelText: 'Abbrechen',
      saveText: 'OK',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final primary = CHRONOSTheme.secondary;
        final secondary = CHRONOSTheme.secondaryLight;
        final scheme = isDark
            ? ColorScheme.dark(primary: primary, secondary: secondary)
            : ColorScheme.light(primary: primary, secondary: secondary);

        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: scheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _applySelectedDateShift();
      });
    }
  }

  Future<void> _onSave({required bool applyRange}) async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      final dates = applyRange ? _datesInRange() : [DateTime(_startDate.year, _startDate.month, _startDate.day)];
      final targetUserId = _user != null ? _user!['id'] as int? : (_existingShift != null ? _existingShift!['user_id'] as int? : null);

      if (targetUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Benutzer-ID unbekannt'), backgroundColor: CHRONOSTheme.error));
        return;
      }

      for (final d in dates) {
        final iso = _dateIsoOnly(d);
        Map<String, dynamic>? existing;
        for (var s in _userShifts) {
          final sd = (s['shift_date'] ?? '').toString();
          if (sd.startsWith(iso)) {
            existing = s;
            break;
          }
        }

        if (_selectedShiftTypeId == null) {
          if (existing != null && existing['id'] != null) {
            final sid = (existing['id'] is int) ? existing['id'] as int : int.tryParse('${existing['id']}');
            if (sid != null) {
              await _api.deleteShift(sid);
            }
          }
        } else {
          if (existing != null && existing['id'] != null) {
            final sid = (existing['id'] is int) ? existing['id'] as int : int.tryParse('${existing['id']}');
            if (sid != null) {
              await _api.updateShift(sid, {'shift_type_id': _selectedShiftTypeId});
            }
          } else {
            await _api.createShift(userId: targetUserId, shiftDate: iso, shiftTypeId: _selectedShiftTypeId!);
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Änderungen erfolgreich gespeichert'), backgroundColor: CHRONOSTheme.success));
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fehler beim Speichern: $e'), backgroundColor: CHRONOSTheme.error));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget buildShiftTypeDropdown() {
    if (_shiftTypes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    Color parseColor(dynamic raw) {
      try {
        if (raw == null) return Colors.grey;
        if (raw is String && raw.startsWith('#') && raw.length == 7) {
          final value = int.parse(raw.substring(1), radix: 16) + 0xFF000000;
          return Color(value);
        } else if (raw is int) {
          return Color(0xFF000000 | raw);
        } else {
          final asInt = int.tryParse('$raw');
          if (asInt != null) return Color(0xFF000000 | asInt);
        }
      } catch (_) {}
      return Colors.grey;
    }

    final items = <DropdownMenuItem<int?>>[];

    items.add(DropdownMenuItem<int?>(
      value: null,
      child: Row(
        children: const [
          Icon(Icons.delete_forever, color: Colors.redAccent, size: 18),
          SizedBox(width: 10),
          Expanded(child: Text('Keine Schicht (löschen)', style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    ));

    for (var t in _shiftTypes) {
      final rawId = t['id'];
      final int? id = rawId is int ? rawId : int.tryParse('$rawId');
      if (id == null) continue;
      final String label = (t['type_name'] ?? t['type'] ?? 'Unbekannt').toString();
      final Color color = parseColor(t['type_color']);
      items.add(DropdownMenuItem<int?>(
        value: id,
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: CHRONOSTheme.of(context).borderColorDefault, width: 0.5),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(label)),
          ],
        ),
      ));
    }

    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<int?>(
        value: _selectedShiftTypeId,
        items: items,
        onChanged: (val) {
          setState(() {
            _selectedShiftTypeId = val;
          });
        },
        decoration: const InputDecoration(
          labelText: 'Schichttyp',
          border: OutlineInputBorder(),
          floatingLabelStyle: TextStyle(color: CHRONOSTheme.secondary),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: CHRONOSTheme.secondary, width: 2)
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        isExpanded: true,
        hint: const Text('Schichttyp wählen'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final singleDay = _startDate.isAtSameMomentAs(_endDate);
    final dateDisplay = singleDay
        ? _dateLabel(_startDate)
        : '${_dateLabel(_startDate)} – ${_dateLabel(_endDate)}';
    return CustomScaffold(
      title: Text(_existingShift == null ? 'Schicht anlegen' : 'Schicht bearbeiten'),
      body: FutureBuilder(
        future: _initialLoadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Column(
              children: [
                SizedBox(height: 20),
                Center(child: CircularProgressIndicator(color: CHRONOSTheme.secondary)),
              ]
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: CHRONOSTheme.of(context).cardColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _pickDateRange(context),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Symbols.calendar_month_rounded, size: 28),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(singleDay ? 'Datum' : 'Zeitraum',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(dateDisplay,
                                    style: Theme.of(context).textTheme.titleMedium),
                              ],
                            ),
                          ),
                          const Icon(Symbols.edit_calendar_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  color: CHRONOSTheme.of(context).cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildShiftTypeDropdown(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: _saving ? null : () => _onSave(applyRange: true),
                                icon: _saving
                                    ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: CHRONOSTheme.secondary),
                                )
                                    : const Icon(Symbols.save_rounded, color: CHRONOSTheme.secondary),
                                label: Text(_saving
                                    ? 'Speichert...'
                                    : singleDay
                                    ? 'Speichern'
                                    : 'Bereich speichern',
                                    style: TextStyle(color: CHRONOSTheme.secondary)
                                ),
                              ),
                            ),
                            if (!singleDay) ...[
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: _saving
                                      ? null
                                      : () => _onSave(applyRange: false),
                                  icon: const Icon(Symbols.save_rounded, color: CHRONOSTheme.secondary),
                                  label: const Text('Nur Starttag', style: TextStyle(color: CHRONOSTheme.secondary)),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    singleDay
                        ? 'Ausgewählt: ${_dateLabel(_startDate)}'
                        : 'Ausgewählt: ${_dateLabel(_startDate)} – ${_dateLabel(_endDate)}',
                    style: TextStyle(color: CHRONOSTheme.of(context).onBackgroundLight),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}