// language: dart
// Datei: `lib/routes/edit/edit_shift_page.dart`
// Vollständige, kompakte Edit-Page mit Save-Logik (ersetzt oder passt den bestehenden Page-Code an).
import 'package:flutter/material.dart';
import 'package:shift_schedule/services/api_service.dart';
import 'package:shift_schedule/ui/themes/theme.dart';
import 'package:shift_schedule/ui/widgets/custom_text_field.dart';

class EditShiftPage extends StatefulWidget {
  final Map<String, dynamic>? data; // erwartet: { 'shift': {...}?, 'date': 'ISO', 'user': {...} }

  const EditShiftPage({super.key, this.data});

  @override
  State<EditShiftPage> createState() => _EditShiftPageState();
}

class _EditShiftPageState extends State<EditShiftPage> {
  final ApiService api = ApiService();
  List<Map<String, dynamic>> _types = [];
  int? _selectedTypeId;
  bool _saving = false;
  Map<String, dynamic>? _existingShift;
  String? _dateIso;
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _existingShift = widget.data?['shift'] as Map<String, dynamic>?;
    _dateIso = widget.data?['date'] as String?;
    _user = widget.data?['user'] as Map<String, dynamic>?;
    _load();
  }

  Future<void> _load() async {
    try {
      final types = await api.getShiftTypes();
      setState(() {
        _types = types;
        if (_existingShift != null) {
          // server liefert type_name und type_color; wir brauchen id wenn vorhanden
          // Falls shift_type_id bereits in shift-Objekt ist, verwende diesen
          final existingTypeId = _existingShift?['shift_type_id'] ?? _existingShift?['type_id'];
          if (existingTypeId is int) _selectedTypeId = existingTypeId;
          // Fallback: match by name
          else {
            final typeName = _existingShift?['type_name'] as String?;
            final match = _types.firstWhere((t) => t['type_name'] == typeName, orElse: () => {});
            if (match.isNotEmpty) _selectedTypeId = match['id'] as int?;
          }
        }
      });
    } catch (e) {
      // still show UI but without types
    }
  }

  Future<void> _onSave() async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      // Wenn keine bestehende Schicht vorhanden -> erstellen (nur wenn Typ ausgewählt)
      if (_existingShift == null) {
        if (_selectedTypeId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kein Schichttyp ausgewählt.')),
          );
          return;
        }
        final userId = _user?['id'] as int?;
        if (userId == null || _dateIso == null) throw Exception('Benutzer oder Datum fehlt');
        await api.createShift(userId: userId, shiftDate: _dateIso!, shiftTypeId: _selectedTypeId!);
      } else {
        // bestehende Schicht vorhanden
        final shiftId = _existingShift!['id'] as int?;
        if (shiftId == null) throw Exception('Shift-id fehlt');
        if (_selectedTypeId == null) {
          // wenn Admin bei vorhandener Schicht keine Schicht auswählt -> löschen
          await api.deleteShift(shiftId);
        } else {
          // update shift_type_id (oder andere Felder falls benötigt)
          await api.updateShift(shiftId, {'shift_type_id': _selectedTypeId});
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Änderungen gespeichert'), backgroundColor: CHRONOSTheme.success),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e'), backgroundColor: CHRONOSTheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _dateIso != null ? DateTime.tryParse(_dateIso!)?.toLocal().toString().split(' ').first ?? _dateIso : 'Unbekannt';
    return Scaffold(
      appBar: AppBar(title: Text(_existingShift == null ? 'Schicht anlegen' : 'Schicht bearbeiten')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Datum: $dateText'),
            const SizedBox(height: 16),
            DropdownButtonFormField<int?>(
              value: _selectedTypeId,
              decoration: const InputDecoration(labelText: 'Schichttyp', border: OutlineInputBorder()),
              items: [
                const DropdownMenuItem<int?>(value: null, child: Text('Keine Schicht (löschen bei bestehender)')),
                ..._types.map((t) {
                  return DropdownMenuItem<int>(value: t['id'] as int, child: Text(t['type_name'] ?? 'Unbekannt'));
                }).toList(),
              ],
              onChanged: (v) => setState(() => _selectedTypeId = v),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saving ? null : _onSave,
              icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save),
              label: Text(_saving ? 'Speichert...' : 'Speichern'),
            ),
          ],
        ),
      ),
    );
  }
}