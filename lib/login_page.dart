import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shift_schedule/services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
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
        _usernameController.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}