// Datei: `lib/routes/edit/user_list_page.dart` (Anpassungen für Unternehmensfilter)
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shift_schedule/services/api_service.dart';
import 'package:shift_schedule/ui/custom_scaffold.dart';
import 'package:shift_schedule/ui/themes/theme.dart';
import 'package:shift_schedule/ui/widgets/floating_action_button.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final ApiService api = ApiService();
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();
  int? _companyId;

  @override
  void initState() {
    super.initState();
    _loadUsers(showCircularProgressIndicator: true);
    _searchController.addListener(_applyFilter);
  }

  Future<void> _loadUsers({bool showCircularProgressIndicator = false}) async {
    if (showCircularProgressIndicator) setState(() => _loading = true);
    try {
      try {
        final details = await api.fetchUserDetails();
        _companyId = details['company_id'] as int?;
      } catch (_) {
        _companyId = null;
      }

      final users = await api.fetchUsers();
      final parsed = List<Map<String, dynamic>>.from(users);
      int empValue(Map<String, dynamic> u) {
        final v = u['employee_id'];
        if (v is int) return v;
        if (v is String) return int.tryParse(v) ?? 0;
        if (v is num) return v.toInt();
        return 0;
      }

      parsed.sort((a, b) => empValue(a).compareTo(empValue(b)));

      setState(() {
        _users = parsed;
        if (_companyId != null) {
          _filtered = _users.where((u) => u['company_id'] == _companyId).toList();
        } else {
          _filtered = _users;
        }
      });
    } catch (_) {}
    if (showCircularProgressIndicator) setState(() => _loading = false);
  }

  void _applyFilter() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      final base = _companyId != null ? _users.where((u) => u['company_id'] == _companyId).toList() : _users;
      if (q.isEmpty) {
        _filtered = base;
      } else {
        _filtered = base.where((u) {
          final name = '${u['first_name'] ?? ''} ${u['last_name'] ?? ''}'.toLowerCase();
          final id = (u['employee_id']?.toString() ?? '').toLowerCase();
          return name.contains(q) || id.contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          context.pushNamed('add_user').then((_) {
            _loadUsers();
          });
        },
        icon: Symbols.person_add_rounded,
      ),
      onRefresh: _loadUsers,
      title: const Text('Mitarbeiter verwalten'),
      body: _loading
          ? const Column(
        children: [
          SizedBox(height: 16),
          Center(child: CircularProgressIndicator(color: CHRONOSTheme.secondary))
        ],
      )
          : ListView.separated(
        itemCount: _filtered.length + 1,
        separatorBuilder: (context, index) {
          if (index == 0) return const SizedBox.shrink();
          return const Divider(height: 1, indent: 16, endIndent: 16);
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                cursorColor: CHRONOSTheme.secondary,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  focusColor: CHRONOSTheme.error,
                  hintText: 'Suche nach Name oder ID',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: CHRONOSTheme.secondary)),
                ),
              ),
            );
          }

          final userIndex = index - 1;
          final u = _filtered[userIndex];
          final name = '${u['first_name'] ?? ''} ${u['last_name'] ?? ''}';
          final emp = u['employee_id']?.toString() ?? '';
          return ListTile(
            title: Text(name),
            subtitle: Text('ID: $emp'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              log('Tapped user: $name', name: 'UserListPage');
              context.pushNamed('admin_calendar', extra: u);
            },
          );
        },
      ),
    );
  }
}