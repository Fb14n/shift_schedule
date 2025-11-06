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
  final _companyNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _vacationDaysController = TextEditingController(text: '30');
  final _passwordController = TextEditingController(text: 'test');

  bool _isAdmin = false;
  bool _isSaving = false;
  bool _isPasswordVisible = true;
  int? _companyId;

  late Future<Map<String, dynamic>> _companyDetailsFuture;

  @override
  void initState() {
    super.initState();
    _companyDetailsFuture = _fetchCompanyDetails();
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _employeeIdController.dispose();
    _vacationDaysController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchCompanyDetails() async {
    try {
      final companies = await _apiService.fetchCompanies();
      if (companies.isNotEmpty) {
        final company = companies.first;
        final companyName = company['name'];
        final companyId = company['id'];
        log('Firma: $companyName (ID: $companyId)', name: 'AddUserPage');
        return {'id': companyId, 'name': companyName};
      }
      return {'id': null, 'name': 'Keine Firma gefunden'};
    } catch (e) {
      log('Fehler beim Laden der Firma: $e', name: 'AddUserPage');
      return {'id': null, 'name': 'Fehler beim Laden'};
    }
  }
  Future<void> _saveUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Sicherheitscheck, ob companyId geladen wurde
      if (_companyId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Firmen-ID konnte nicht geladen werden. Bitte versuchen Sie es erneut.'),
            backgroundColor: CHRONOSTheme.error,
          ),
        );
        return;
      }

      setState(() => _isSaving = true);
      try {
        await _apiService.createUser(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          employeeId: _employeeIdController.text,
          password: _passwordController.text,
          holidays: int.tryParse(_vacationDaysController.text) ?? 30,
          isAdmin: _isAdmin,
          // --- HIER DIE COMPANY ID ÜBERGEBEN ---
          companyId: _companyId,
        );

        if (mounted) {
          // ... (restliche Erfolgslogik bleibt gleich)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Benutzer erfolgreich erstellt!'),
              backgroundColor: CHRONOSTheme.success,
            ),
          );
          context.pop();
        }
      } catch (e) {
        log('Fehler beim Speichern des Benutzers: $e', name: 'AddUserPage');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString(), style: const TextStyle(color: CHRONOSTheme.onError)),
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
        body: FutureBuilder<Map<String, dynamic>>(
            future: _companyDetailsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                    children: [
                      const SizedBox(height: 20),
                      const Center(child: CircularProgressIndicator(color: CHRONOSTheme.secondary)),
                    ],
                );
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: Text('Fehler: ${snapshot.error ??
                    'Firmendetails konnten nicht geladen werden.'}'));
              }
              final companyData = snapshot.data!;
              _companyNameController.text = companyData['name'] ?? 'Fehler';
              _companyId = companyData['id']; // Speichere die ID für den save-Aufruf

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _companyNameController,
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _vacationDaysController,
                        labelText: 'Urlaubstage',
                        validatorText: 'Urlaubstage ist ein Pflichtfeld',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Passwort',
                        validatorText: 'Passwort ist ein Pflichtfeld',
                        obscureText: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility_off : Icons
                                .visibility,
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
                        trackColor: WidgetStatePropertyAll(
                            _isAdmin ? CHRONOSTheme.secondary : null),
                        thumbColor: WidgetStatePropertyAll(
                            _isAdmin ? CHRONOSTheme.onSecondary : null),
                        title: const Text('Administrator'),
                        subtitle: const Text(
                            'Der Benutzer erhält erweiterte Rechte.'),
                        value: _isAdmin,
                        onChanged: (value) {
                          setState(() {
                            _isAdmin = value;
                          });
                        },
                        secondary: Icon(
                            _isAdmin ? Icons.person : Icons.person_outline),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _isSaving ? null : _saveUser,
                        icon: _isSaving
                            ? const SizedBox(width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.save),
                        label: Text(_isSaving
                            ? 'Speichert...'
                            : 'Mitarbeiter erstellen'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: CHRONOSTheme.primary,
                          foregroundColor: CHRONOSTheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
        ),
    );
  }
}