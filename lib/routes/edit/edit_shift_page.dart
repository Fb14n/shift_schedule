import 'package:flutter/material.dart';
import 'package:shift_schedule/services/api_service.dart';
import 'package:shift_schedule/ui/themes/theme.dart';
import 'package:shift_schedule/ui/custom_scaffold.dart';

class EditShiftPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const EditShiftPage({super.key, this.data});

  @override
  State<EditShiftPage> createState() => _EditShiftPageState();
}

class _EditShiftPageState extends State<EditShiftPage> {
  final ApiService _api = ApiService();

  List<Map<String, dynamic>> _shiftTypes = [];
  int? _selectedShiftTypeId;
  bool _saving = false;
  Map<String, dynamic>? _existingShift;
  String? _dateIso;
  Map<String, dynamic>? _user;
  Future<void>? _initialLoadFuture;

  @override
  void initState() {
    super.initState();
    _existingShift = widget.data?['shift'] as Map<String, dynamic>?;
    _dateIso = widget.data?['date'] as String?;
    _user = widget.data?['user'] as Map<String, dynamic>?;
    _initialLoadFuture = _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final types = await _api.getShiftTypes();
      final list = List<Map<String, dynamic>>.from(
        types.map((t) {
          final dynamic rawId = t['id'];
          final int? parsedId = rawId is int
              ? rawId
              : int.tryParse(rawId?.toString() ?? '');
          return {...Map<String, dynamic>.from(t), 'id': parsedId};
        }),
      );
      int? initialId;
      if (_existingShift != null) {
        final dynamic existingTypeRaw =
            _existingShift?['shift_type_id'] ??
            _existingShift?['type_id'] ??
            _existingShift?['id'];
        initialId = existingTypeRaw is int
            ? existingTypeRaw
            : int.tryParse(existingTypeRaw?.toString() ?? '');
      }
      if (mounted) {
        setState(() {
          _shiftTypes = list;
          _selectedShiftTypeId = initialId;
        });
      }
    } catch (e) {
      throw Exception('Fehler beim Laden der Schichttypen: $e');
    }
  }

  Future<void> _onSave() async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      if (_existingShift == null) {
        if (_selectedShiftTypeId == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kein Schichttyp ausgewählt.')),
            );
          }
          return;
        }
        final userId = _user?['id'] as int?;
        if (userId == null || _dateIso == null)
          throw Exception('Benutzer oder Datum fehlt');
        await _api.createShift(
          userId: userId,
          shiftDate: _dateIso!,
          shiftTypeId: _selectedShiftTypeId!,
        );
      } else {
        final shiftId = _existingShift!['id'] is int
            ? _existingShift!['id'] as int
            : int.tryParse(_existingShift!['id']?.toString() ?? '');
        if (shiftId == null) throw Exception('Shift-ID fehlt');
        if (_selectedShiftTypeId == null) {
          await _api.deleteShift(shiftId);
        } else {
          await _api.updateShift(shiftId, {
            'shift_type_id': _selectedShiftTypeId,
          });
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Änderungen gespeichert'),
            backgroundColor: CHRONOSTheme.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: CHRONOSTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _dateIso != null
        ? DateTime.tryParse(_dateIso!)?.toLocal().toString().split(' ').first ??
              _dateIso
        : 'Unbekannt';

    return CustomScaffold(
      title: Text(
        _existingShift == null ? 'Schicht anlegen' : 'Schicht bearbeiten',
      ),
      body: FutureBuilder(
        future: _initialLoadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: CircularProgressIndicator(
                    color: CHRONOSTheme.secondary,
                  ),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Datum: $dateText'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: DropdownMenu<int?>(
                    initialSelection: _selectedShiftTypeId,
                    label: const Text('Schichttyp'),
                    expandedInsets: EdgeInsets.zero,
                    dropdownMenuEntries: [
                      const DropdownMenuEntry<int?>(
                        value: null,
                        label: 'Keine Schicht',
                      ),
                      ..._shiftTypes.map((t) {
                        final int? id = t['id'] is int
                            ? t['id'] as int
                            : int.tryParse(t['id']?.toString() ?? '');
                        return DropdownMenuEntry<int?>(
                          value: id,
                          label: t['type_name'] ?? 'Unbekannt',
                        );
                      }).toList(),
                    ],
                    onSelected: (int? v) {
                      setState(() => _selectedShiftTypeId = v);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _saving ? null : _onSave,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(_saving ? 'Speichert...' : 'Speichern'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}