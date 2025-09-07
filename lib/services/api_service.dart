import 'dart:developer';

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class ApiService {
  static const String baseUrl = 'http://127.0.0.1:3000';
  final storage = FlutterSecureStorage();

  Future<List<Map<String, dynamic>>> fetchShiftsWithUsers(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/shifts'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load shifts');
    }
  }

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['access_token'] != null) {
        saveToken(data['access_token']);
        log('Login successful, token saved', name: 'ApiService');
        return data['access_token'];
      } else {
        throw Exception('Login failed: Token not found in response');
      }
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception('Login failed: ${errorResponse['error'] ?? 'Unknown error'}');
    }
  }

  Future<void> logout() async {
    try {
      await storage.deleteAll();
      log('Logout successful: All data cleared', name: 'ApiService');
    } catch (e) {
      log('Logout failed: $e', name: 'ApiService');
      throw Exception('Logout failed: $e');
    }
  }

  Future<void> saveToken(String token) async {
    log('Saving token: $token', name: 'ApiService');
    await storage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getToken() async {
    final token = await storage.read(key: 'jwt_token');
    log('Retrieved token: $token', name: 'ApiService');
    return token;
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'jwt_token');
  }
}