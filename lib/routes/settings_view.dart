import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shift_schedule/services/api_service.dart';
import 'package:shift_schedule/ui/custom_scaffold.dart';
import 'package:shift_schedule/ui/themes/theme.dart';
import 'package:shift_schedule/utils/toggle_theme.dart';
import 'package:shift_schedule/ui/widgets/admin_badge.dart';


class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final ApiService _apiService = ApiService();
  Future<Map<String, dynamic>>? _userDetailsFuture;
  ThemeMode _currentThemeMode = ThemeManager.themeModeNotifier.value;
  Map<String, dynamic>? _userDetails;

  @override
  void initState() {
    super.initState();
    _userDetailsFuture = _apiService.fetchUserDetails();
    ThemeManager.themeModeNotifier.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeManager.themeModeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {
        _currentThemeMode = ThemeManager.themeModeNotifier.value;
      });
    }
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Abmelden bestätigen'),
          content: const Text('Möchten Sie sich wirklich abmelden?'),
          actions: [
            TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Ja', style: TextStyle(color: CHRONOSTheme.error)),
            ),
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Nein',
                    style: TextStyle(color: CHRONOSTheme.secondary)),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await _apiService.logout();
      if (mounted) {
        context.go('/login');
      }
    }
  }

  void _showVerifyOldPasswordDialog() {
    if (_userDetails == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Benutzerdaten noch nicht geladen.'),
        backgroundColor: CHRONOSTheme.error,
      ));
      return;
    }

    final oldPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;
    String? serverError;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setStateInDialog) {
          return AlertDialog(
            title: const Text('Aktuelles Passwort bestätigen'),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: oldPasswordController,
                cursorColor: CHRONOSTheme.secondary,
                decoration: InputDecoration(
                  labelText: 'Aktuelles Passwort',
                  floatingLabelStyle:
                  TextStyle(color: CHRONOSTheme.secondary),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CHRONOSTheme.secondary),
                  ),
                  errorText: serverError,
                ),
                obscureText: true,
                validator: (value) => value!.isEmpty
                    ? 'Bitte aktuelles Passwort eingeben'
                    : null,
                onChanged: (_) {
                  if (serverError != null) {
                    setStateInDialog(() {
                      serverError = null;
                    });
                  }
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Abbrechen', style: TextStyle(color: CHRONOSTheme.error)),
              ),
              isLoading
                  ? const CircularProgressIndicator(color: CHRONOSTheme.secondary)
                  : ElevatedButton(
                onPressed: () async {
                  setStateInDialog(() {
                    serverError = null;
                  });
                  if (!formKey.currentState!.validate()) return;

                  setStateInDialog(() => isLoading = true);

                  final String username = _userDetails!['first_name'];

                  try {
                    await _apiService.login(
                        username, oldPasswordController.text);

                    final currentToken = await _apiService.getToken();
                    if (currentToken != null) {
                      await _apiService.saveToken(currentToken);
                    }

                    if (!mounted) return;

                    Navigator.of(dialogContext).pop();
                    _showEnterNewPasswordDialog();

                  } catch (e) {
                    log('Passwort-Verifizierung fehlgeschlagen: $e', name: 'SettingsView');
                    setStateInDialog(() {
                      serverError = 'Falsches Passwort. Bitte erneut versuchen.';
                      isLoading = false;
                  });
                  }
                },
                child: const Text('Bestätigen', style: TextStyle(color: CHRONOSTheme.secondary)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEnterNewPasswordDialog() {
    if (_userDetails == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Benutzerdaten nicht verfügbar. Bitte warten.'),
            backgroundColor: CHRONOSTheme.error),
      );
      return;
    }

    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final String username = _userDetails!['first_name'] ?? '';
    final String employeeId = _userDetails!['employee_id']?.toString() ?? '';
    bool isLoading = false;
    String? serverError;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setStateInDialog) {
          return AlertDialog(
            title: const Text('Neues Passwort festlegen'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: newPasswordController,
                    cursorColor: CHRONOSTheme.secondary,
                    decoration: const InputDecoration(
                      labelText: 'Neues Passwort',
                      floatingLabelStyle: TextStyle(color: CHRONOSTheme.secondary),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CHRONOSTheme.secondary),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte neues Passwort eingeben';
                      }
                      if (value.length < 6) {
                        return 'Passwort muss mind. 6 Zeichen haben';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: confirmPasswordController,
                    cursorColor: CHRONOSTheme.secondary,
                    decoration: const InputDecoration(
                      labelText: 'Passwort bestätigen',
                      floatingLabelStyle: TextStyle(color: CHRONOSTheme.secondary),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CHRONOSTheme.secondary),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) => value != newPasswordController.text
                        ? 'Passwörter stimmen nicht überein'
                        : null,
                  ),
                  if (serverError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        serverError!,
                        style: const TextStyle(color: CHRONOSTheme.error, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Abbrechen', style: TextStyle(color: CHRONOSTheme.error)),
              ),
              isLoading
                  ? const CircularProgressIndicator(color: CHRONOSTheme.secondary)
                  : ElevatedButton(
                onPressed: () async {
                  setStateInDialog(() {
                    serverError = null;
                  });

                  if (!formKey.currentState!.validate()) return;
                  setStateInDialog(() => isLoading = true);

                  try {
                    await _apiService.resetPassword(
                      username: username,
                      employeeId: employeeId,
                      newPassword: newPasswordController.text,
                    );

                    if (!mounted) return;
                    Navigator.of(dialogContext).pop();
                    await _apiService.logout();
                    GoRouter.of(context).go('/login');

                  } catch (e) {
                    log('Password change failed: $e', name: 'SettingsView');
                    setStateInDialog(() {
                      serverError = 'Passwort konnte nicht geändert werden. Bitte versuchen Sie es erneut.';
                      isLoading = false;
                    });
                  }
                },
                child: const Text('Speichern & Abmelden', style: TextStyle(color: CHRONOSTheme.secondary)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: const Text('Einstellungen'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            _buildUserInfoSection(),
            const SizedBox(height: 32),
            _buildSettingsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _userDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: CHRONOSTheme.secondary));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(
              child: Text('Benutzerdaten konnten nicht geladen werden.'));
        }

        _userDetails = snapshot.data;
        final user = _userDetails!;

        final firstName = user['first_name'] ?? 'Unbekannt';
        final lastName = user['last_name'] ?? '';
        final employeeId = user['employee_id']?.toString() ?? 'Keine ID';

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: CHRONOSTheme.primary,
              child: Text(
                firstName.isNotEmpty ? firstName[0] : '?',
                style: const TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: CHRONOSTheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    '$firstName $lastName',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (user['is_admin'] == true) ...[
                  const SizedBox(width: 6),
                  const AdminBadge(height: 20),
                ],
              ],
            ),

            const SizedBox(height: 8),
            Text(
              'Mitarbeiter-ID: $employeeId',
              style: TextStyle(
                fontSize: 16,
                color: CHRONOSTheme.of(context).onBackgroundLight,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsList() {
    final isDarkMode = _currentThemeMode == ThemeMode.dark;

    return Column(
      children: [
        ListTile(
          onTap: ThemeManager.toggleTheme,
          leading: Icon(
            isDarkMode ? Symbols.dark_mode : Symbols.light_mode,
          ),
          title: Text(isDarkMode ? 'Dunkelmodus' : 'Hellmodus'),
          trailing: Switch(
            trackColor: WidgetStatePropertyAll(
                isDarkMode ? CHRONOSTheme.primary : CHRONOSTheme.secondary),
            thumbColor: WidgetStatePropertyAll(
                isDarkMode ? CHRONOSTheme.secondary : CHRONOSTheme.primary
            ),
            trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
            value: isDarkMode,
            onChanged: (bool value) {
              ThemeManager.toggleTheme();
            },
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Symbols.lock_reset),
          title: const Text('Passwort ändern'),
          onTap: _showVerifyOldPasswordDialog,
          trailing: const Icon(Symbols.arrow_forward_ios, size: 16),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Symbols.logout, color: CHRONOSTheme.error),
          title: const Text('Abmelden', style: TextStyle(color: CHRONOSTheme.error)),
          onTap: _logout,
        ),
      ],
    );
  }
}