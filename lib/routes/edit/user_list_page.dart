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

  @override
  void initState() {
    super.initState();
    _loadUsers(showCircularProgressIndicator: true);
    _searchController.addListener(_applyFilter);
  }

  Future<void> _loadUsers({bool showCircularProgressIndicator = false}) async {
    if (showCircularProgressIndicator) setState(() => _loading = true);
    try {
      final users = await api.fetchUsers();
      setState(() {
        _users = List<Map<String, dynamic>>.from(users);
        _filtered = _users;
      });
    } catch (_) {}
    if (showCircularProgressIndicator) setState(() => _loading = false);
  }

  void _applyFilter() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = _users;
      } else {
        _filtered = _users.where((u) {
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
      title:  const Text('Mitarbeiter verwalten'),
      body: _loading
          ? const Column(
          children: [
            SizedBox(height: 16),
            Center(
                child: CircularProgressIndicator(
                    color: CHRONOSTheme.secondary
                )
            )
          ])
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