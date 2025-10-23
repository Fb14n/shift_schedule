import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shift_schedule/services/api_service.dart';
import 'package:shift_schedule/ui/custom_scaffold.dart';

// KORREKTUR 1: Der Klassenname wurde von 'SettingsView' zu 'SettingsPage' geändert,
// damit er mit der Verwendung in 'router.dart' übereinstimmt, falls du das noch nicht hattest.
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _shiftTypes = [];
  bool _isLoading = true;
  String? _errorMessage; // Variable zum Speichern der Fehlermeldung

  @override
  void initState() {
    super.initState();
    // KORREKTUR 2: Die _loadShiftTypes-Methode wird nach dem ersten Frame aufgerufen.
    // Dies stellt sicher, dass der BuildContext für die SnackBar verfügbar ist.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadShiftTypes();
    });
  }

  Future<void> _loadShiftTypes() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Fehler zurücksetzen
    });

    try {
      final types = await _apiService.getShiftTypes();
      if (mounted) {
        setState(() {
          _shiftTypes = types;
          _isLoading = false;
        });
      }
    } catch (e) {
      log('Fehler beim Laden der Schichttypen: $e', name: 'SettingsPage');
      if (mounted) {
        setState(() {
          _isLoading = false;
          // Fehlermeldung für die Anzeige im UI speichern
          _errorMessage = 'Fehler beim Laden der Einstellungen.\nBitte überprüfe deine Serververbindung.';
        });
        // Die SnackBar wird hier nicht mehr benötigt, da wir den Fehler direkt anzeigen
      }
    }
  }

  // Konvertiert einen Hex-String (z.B. '#FF0000') in eine Color
  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  // Konvertiert eine Color in einen Hex-String
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  void _showColorPicker(Map<String, dynamic> shiftType) {
    Color pickerColor = _colorFromHex(shiftType['type_color']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Farbe für "${shiftType['type_name']}" wählen'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                pickerColor = color;
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Speichern'),
              onPressed: () {
                _updateColor(shiftType['id'], pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateColor(int id, Color newColor) async {
    final hexColor = _colorToHex(newColor);

    // --- KORREKTUR: Speichere den BuildContext, BEVOR der Dialog geschlossen wird ---
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);

    try {
      await _apiService.updateShiftTypeColor(id, hexColor);

      // UI direkt aktualisieren für sofortiges Feedback
      setState(() {
        final index = _shiftTypes.indexWhere((type) => type['id'] == id);
        if (index != -1) {
          _shiftTypes[index]['type_color'] = hexColor;
        }
      });

      // Zeige die Erfolgsmeldung mit dem gespeicherten Context
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Farbe erfolgreich aktualisiert!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      log('Fehler beim Aktualisieren der Farbe: $e', name: 'SettingsPage');

      // Zeige die Fehlermeldung mit dem gespeicherten Context
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Fehler beim Aktualisieren: ${e.toString()}'),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    }
  }

  // Hilfs-Widget zur Anzeige des Ladezustands, Fehlers oder Inhalts
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // KORREKTUR 3: Explizite Fehleranzeige, falls _errorMessage gesetzt ist.
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 16),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadShiftTypes,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _shiftTypes.length,
        itemBuilder: (context, index) {
          final shiftType = _shiftTypes[index];
          final color = _colorFromHex(shiftType['type_color']);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: CircleAvatar(
                backgroundColor: color,
                radius: 20,
              ),
              title: Text(
                shiftType['type_name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.colorize),
              onTap: () => _showColorPicker(shiftType),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      // KORREKTUR 4: 'title' durch 'appBarTitle' ersetzt
      title: Text('Einstellungen'),
      body: _buildBody(),
    );
  }
}