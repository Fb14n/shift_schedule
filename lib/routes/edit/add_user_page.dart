import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import für InputFormatter
import 'package:go_router/go_router.dart';
import 'package:shift_schedule/services/api_service.dart';
import 'package:shift_schedule/ui/custom_scaffold.dart';
import 'package:shift_schedule/ui/themes/theme.dart';
import 'package:shift_schedule/ui/widgets/custom_text_field.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _vacationDaysController = TextEditingController(text: '30'); // Default
  final _passwordController = TextEditingController(text: 'test'); // Default

  bool _isAdmin = false;
  bool _isSaving = false;
  String? _companyName;
  bool _isPasswordVisible = true;
  @override
  void initState() {
    super.initState();
    _fetchCompanyDetails();
  }

  Future<void> _fetchCompanyDetails() async {
    try {
      final companies = await _apiService.fetchCompanies();
      if (companies.isNotEmpty && mounted) {
        setState(() {
          _companyName = companies.first['name'];
        });
      }
    } catch (e) {
      log('Fehler beim Laden der Firma: $e', name: 'AddUserPage');
    }
  }

  Future<void> _saveUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);
      try {
        await _apiService.createUser(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          employeeId: _employeeIdController.text,
          password: _passwordController.text,
          vacationDays: int.tryParse(_vacationDaysController.text) ?? 30,
          isAdmin: _isAdmin,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Benutzer erfolgreich erstellt!'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      } catch (e) {
        log('Fehler beim Speichern des Benutzers: $e', name: 'AddUserPage');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fehler: ${e.toString()}'),
              backgroundColor: CHRONOSTheme.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSaving = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: const Text('Neuen Mitarbeiter anlegen'),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: _companyName ?? 'Lade Firma...',
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Firma',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _firstNameController,
                labelText: 'Vorname',
                validatorText: 'Vorname ist ein Pflichtfeld',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _lastNameController,
                labelText: 'Nachname',
                validatorText: 'Nachname ist ein Pflichtfeld',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _employeeIdController,
                labelText: 'Mitarbeiter-ID',
                validatorText: 'Mitarbeiter-ID ist ein Pflichtfeld',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _vacationDaysController,
                labelText: 'Urlaubstage',
                validatorText: 'Urlaubstage ist ein Pflichtfeld',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Passwort',
                validatorText: 'Passwort ist ein Pflichtfeld',
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                trackColor: WidgetStatePropertyAll(_isAdmin ? CHRONOSTheme.secondary : null),
                thumbColor: WidgetStatePropertyAll(_isAdmin ? CHRONOSTheme.onSecondary : null),
                title: const Text('Administrator'),
                subtitle: const Text('Der Benutzer erhält erweiterte Rechte.'),
                value: _isAdmin,
                onChanged: (value) {
                  setState(() {
                    _isAdmin = value;
                  });
                },
                secondary: Icon(_isAdmin ? Icons.person : Icons.person_outline),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveUser,
                icon: _isSaving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Speichert...' : 'Mitarbeiter erstellen'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: CHRONOSTheme.primary,
                  foregroundColor: CHRONOSTheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}