import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shift_schedule/services/api_service.dart';
import 'package:shift_schedule/ui/custom_scaffold.dart';
import 'package:shift_schedule/ui/themes/theme.dart';


class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _shiftTypes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadShiftTypes();
    });
  }

  Future<void> _loadShiftTypes() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
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
          _errorMessage = 'Fehler beim Laden der Einstellungen.\nBitte überprüfe deine Serververbindung.';
        });
      }
    }
  }

  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

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
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await _apiService.updateShiftTypeColor(id, hexColor);

      setState(() {
        final index = _shiftTypes.indexWhere((type) => type['id'] == id);
        if (index != -1) {
          _shiftTypes[index]['type_color'] = hexColor;
        }
      });

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Farbe erfolgreich aktualisiert!'),
          backgroundColor: CHRONOSTheme.success,
        ),
      );
    } catch (e) {
      log('Fehler beim Aktualisieren der Farbe: $e', name: 'SettingsPage');

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Fehler beim Aktualisieren: ${e.toString()}'),
          backgroundColor: CHRONOSTheme.error,
        ),
      );
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(color: CHRONOSTheme.error, fontSize: 16),
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
      title: Text('Einstellungen'),
      body: _buildBody(),
    );
  }
}