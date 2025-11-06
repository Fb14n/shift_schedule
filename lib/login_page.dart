import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
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
    try {
      final token = await _apiService.login(
        _employeeIdController.text,
        _passwordController.text,
      );
      final expiryDate = DateTime.now().add(const Duration(hours: 2));
      await _secureStorage.write(key: 'auth_token', value: token);
      await _secureStorage.write(key: 'token_expiry', value: expiryDate.toIso8601String());
      context.pushReplacement('/calendar');
    } catch (e) {
      log('Login failed: ${e}', name: 'LoginPage');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
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
                  decoration: const InputDecoration(labelText: 'Benutzername (Vorname)'),
                  validator: (value) => value!.isEmpty ? 'Bitte Benutzernamen eingeben' : null,
                ),
                TextFormField(
                  controller: employeeIdController,
                  decoration: const InputDecoration(labelText: 'Personalnummer'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Bitte Personalnummer eingeben' : null,
                ),
                TextFormField(
                  controller: newPasswordController,
                  decoration: const InputDecoration(labelText: 'Neues Passwort'),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Bitte neues Passwort eingeben' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
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
              child: const Text('Zurücksetzen'),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _employeeIdController,
                      cursorColor: CHRONOSTheme.onPrimary,
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
                    ),
                    const SizedBox(height: 12),
                    TextField(
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
    );
  }
}