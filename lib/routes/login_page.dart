import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shift_schedule/services/api_service.dart';
import 'package:shift_schedule/ui/themes/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _companies = [];
  int? _selectedCompanyId;
  bool _loadingCompanies = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadCompaniesFromApiOrEnv();
  }

  Future<void> _loadCompaniesFromApiOrEnv() async {
    setState(() => _loadingCompanies = true);

    List<Map<String, dynamic>> companiesFromApi = [];

    try {
      final apiResult = await _apiService.fetchCompanies();
      companiesFromApi = List<Map<String, dynamic>>.from(apiResult);
    } catch (e) {
      log('fetchCompanies failed, trying public endpoint: $e', name: 'LoginPage');

      try {
        final publicResult = await _apiService.fetchPublicCompanies();
        companiesFromApi = List<Map<String, dynamic>>.from(publicResult);
      } catch (e2) {
        log('fetchPublicCompanies failed: $e2', name: 'LoginPage');
      }
    }

    final mappedFromApi = companiesFromApi.map((c) {
      final id = c['id'] is int ? c['id'] as int : int.tryParse('${c['id']}');
      String name;
      if (id == 1) {
        name = 'Chronos';
      } else if (id == 2) {
        name = 'Company GmbH';
      } else {
        name = (c['name'] ?? c['company_name'] ?? 'Firma ${c['id']}').toString();
      }
      return {'id': id, 'name': name};
    }).where((m) => m['id'] != null).toList();

    if (mappedFromApi.isNotEmpty) {
      setState(() {
        _companies = mappedFromApi;
        _selectedCompanyId = _companies.first['id'] as int?;
        _loadingCompanies = false;
      });
      return;
    }

    final raw = dotenv.env['COMPANIES'];
    if (raw != null && raw.trim().isNotEmpty) {
      final parts = raw.split(',');
      final parsed = parts.map((p) {
        final kv = p.split(':');
        final id = int.tryParse(kv[0].trim());
        String name;
        if (id == 1) {
          name = 'Chronos';
        } else if (id == 2) {
          name = 'Company GmbH';
        } else {
          name = kv.length > 1 ? kv.sublist(1).join(':').trim() : 'Firma ${kv[0].trim()}';
        }
        return {'id': id, 'name': name};
      }).where((m) => m['id'] != null).toList();

      if (parsed.isNotEmpty) {
        setState(() {
          _companies = parsed;
          _selectedCompanyId = _companies.first['id'] as int?;
          _loadingCompanies = false;
        });
        return;
      }
    }
    setState(() {
      _companies = [
        {'id': 1, 'name': 'Chronos'},
        {'id': 2, 'name': 'Company GmbH'},
      ];
      _selectedCompanyId = _companies.first['id'] as int?;
      _loadingCompanies = false;
    });
  }

  Future<void> _checkLoginStatus() async {
    final token = await _secureStorage.read(key: 'auth_token');
    final expiry = await _secureStorage.read(key: 'token_expiry');

    if (token != null && expiry != null) {
      final expiryDate = DateTime.parse(expiry);
      if (DateTime.now().isBefore(expiryDate)) {
        context.pushReplacement('/calendar');
      } else {
        await _secureStorage.delete(key: 'auth_token');
        await _secureStorage.delete(key: 'token_expiry');
      }
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final token = await _apiService.login(
        _employeeIdController.text,
        _passwordController.text,
        companyId: _selectedCompanyId,
      );
      final expiryDate = DateTime.now().add(const Duration(hours: 2));
      await _secureStorage.write(key: 'auth_token', value: token);
      await _secureStorage.write(key: 'token_expiry', value: expiryDate.toIso8601String());
      context.pushReplacement('/calendar');
    } catch (e) {
      log('Login failed: ${e}', name: 'LoginPage');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'), backgroundColor: CHRONOSTheme.error),
      );
    }
  }

  void _showForgotPasswordDialog() {
    final usernameController = TextEditingController();
    final employeeIdController = TextEditingController();
    final newPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Passwort zurücksetzen'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: usernameController,
                  cursorColor: CHRONOSTheme.secondary,
                  decoration: const InputDecoration(
                    floatingLabelStyle: TextStyle(color: CHRONOSTheme.secondary),
                    labelText: 'Benutzername (Vorname)',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: CHRONOSTheme.secondary),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? 'Bitte Benutzernamen eingeben' : null,
                ),
                TextFormField(
                  controller: employeeIdController,
                  cursorColor: CHRONOSTheme.secondary,
                  decoration: const InputDecoration(
                    floatingLabelStyle: TextStyle(color: CHRONOSTheme.secondary),
                    labelText: 'Personalnummer',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: CHRONOSTheme.secondary),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Bitte Personalnummer eingeben' : null,
                ),
                TextFormField(
                  controller: newPasswordController,
                  cursorColor: CHRONOSTheme.secondary,
                  decoration: const InputDecoration(
                    floatingLabelStyle: TextStyle(color: CHRONOSTheme.secondary),
                    labelText: 'Neues Passwort',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: CHRONOSTheme.secondary),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Bitte neues Passwort eingeben' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen', style: TextStyle(color: CHRONOSTheme.secondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                navigator.pop();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Setze Passwort zurück...')),
                );

                try {
                  await _apiService.resetPassword(
                    username: usernameController.text,
                    employeeId: employeeIdController.text,
                    newPassword: newPasswordController.text,
                  );
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Passwort erfolgreich zurückgesetzt! Du kannst dich jetzt anmelden.'),
                      backgroundColor: CHRONOSTheme.success,
                      duration: Duration(seconds: 4),
                    ),
                  );

                } catch (e) {
                  log('Password reset failed: $e', name: 'LoginPage');
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Fehler: ${e.toString()}'),
                      backgroundColor: CHRONOSTheme.error,
                    ),
                  );
                }
              },
              child: const Text('Zurücksetzen', style: TextStyle(color: CHRONOSTheme.secondary)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CHRONOSTheme.primary,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_loadingCompanies)
                        const SizedBox(height: 56, child: Center(child: CircularProgressIndicator()))
                      else
                        DropdownButtonFormField<int>(
                          initialValue: _selectedCompanyId,
                          dropdownColor: CHRONOSTheme.primary,
                          decoration: const InputDecoration(
                            labelText: 'Firma',
                            labelStyle: TextStyle(color: CHRONOSTheme.onPrimary),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: CHRONOSTheme.onPrimary)),
                          ),
                          items: _companies.map((c) {
                            final id = c['id']?.toString() ?? '';
                            final name = c['name']?.toString() ?? 'Firma';
                            final display = id.isNotEmpty ? name : name;
                            return DropdownMenuItem<int>(
                              value: c['id'] as int?,
                              child: Text(display, style: const TextStyle(color: CHRONOSTheme.onPrimary)),
                            );
                          }).toList(),
                          onChanged: (v) => setState(() => _selectedCompanyId = v),
                          validator: (v) => v == null ? 'Bitte Firma auswählen' : null,
                        ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _employeeIdController,
                        cursorColor: CHRONOSTheme.onPrimary,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: CHRONOSTheme.onPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Personalnummer',
                          labelStyle: TextStyle(color: CHRONOSTheme.onPrimary),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: CHRONOSTheme.onPrimary),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: CHRONOSTheme.onPrimary),
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Bitte Personalnummer eingeben' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        cursorColor: CHRONOSTheme.onPrimary,
                        style: const TextStyle(color: CHRONOSTheme.onPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Passwort',
                          labelStyle: TextStyle(color: CHRONOSTheme.onPrimary),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: CHRONOSTheme.onPrimary),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: CHRONOSTheme.onPrimary),
                          ),
                        ),
                        obscureText: true,
                        validator: (v) => v == null || v.isEmpty ? 'Bitte Passwort eingeben' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CHRONOSTheme.onPrimary,
                            foregroundColor: CHRONOSTheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: const Text(
                          'Passwort vergessen?',
                          style: TextStyle(color: CHRONOSTheme.onPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}