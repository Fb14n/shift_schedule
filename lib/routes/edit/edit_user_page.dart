import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shift_schedule/services/api_service.dart';
import 'package:shift_schedule/ui/custom_scaffold.dart';
import 'package:shift_schedule/ui/themes/theme.dart';
import 'package:shift_schedule/ui/widgets/custom_text_field.dart';

class EditUserPage extends StatefulWidget {
  final Map<String, dynamic>? user;

  const EditUserPage({super.key, this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final ApiService _api = ApiService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _vacationDaysController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isAdmin = false;
  bool _isSaving = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserOrProvided();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _employeeIdController.dispose();
    _vacationDaysController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUserOrProvided() async {
    if (widget.user != null) {
      final u = widget.user!;
      setState(() {
        _firstNameController.text = (u['first_name'] ?? '').toString();
        _lastNameController.text = (u['last_name'] ?? '').toString();
        _employeeIdController.text = (u['employee_id']?.toString() ?? '');
        _vacationDaysController.text = (u['vacation_days']?.toString() ?? '30');
        _isAdmin = u['is_admin'] == true;
        _loaded = true;
      });
      return;
    }

    try {
      final user = await _api.fetchUserDetails();
      if (!mounted) return;
      setState(() {
        _firstNameController.text = (user['first_name'] ?? '').toString();
        _lastNameController.text = (user['last_name'] ?? '').toString();
        _employeeIdController.text = (user['employee_id']?.toString() ?? '');
        _vacationDaysController.text = (user['vacation_days']?.toString() ?? '30');
        _isAdmin = user['is_admin'] == true;
        _loaded = true;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fehler beim Laden der Benutzerdaten: $e'),
        backgroundColor: CHRONOSTheme.error,
      ));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final payload = <String, dynamic>{
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'employee_id': _employeeIdController.text.trim(),
        'vacation_days': int.tryParse(_vacationDaysController.text) ?? 30,
        'is_admin': _isAdmin,
      };

      if (_passwordController.text.isNotEmpty) {
        payload['password'] = _passwordController.text;
      }

      final int? targetId = widget.user != null
          ? (widget.user!['id'] is int ? widget.user!['id'] as int : int.tryParse('${widget.user!['id']}'))
          : null;

      final updatedUser = await _api.updateUser(payload, id: targetId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Benutzerdaten gespeichert'),
        backgroundColor: CHRONOSTheme.success,
      ));
      context.pop(updatedUser);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fehler beim Speichern: $e'),
        backgroundColor: CHRONOSTheme.error,
      ));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: const Text('Benutzer bearbeiten'),
      body: !_loaded
          ? const Column(
        children: [
          SizedBox(height: 20),
          Center(child: CircularProgressIndicator(color: CHRONOSTheme.secondary)),
        ],
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    _isAdmin ? Symbols.person_filled_rounded : Symbols.person_rounded),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox(
                    width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Symbols.save_rounded),
                label: Text(_isSaving ? 'Speichert...' : 'Speichern'),
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