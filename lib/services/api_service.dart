import 'dart:developer';

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class ApiService {
  static final String? baseUrl = dotenv.env['API_BASE_URL'];
  final storage = FlutterSecureStorage();

  Future<List<Map<String, dynamic>>> fetchShifts(String token) async {
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

  Future<Map<String, dynamic>> fetchUserDetails() async {
    final token = await getToken();
    if (token == null) throw Exception('No token stored');

    final response = await http.get(
      Uri.parse('$baseUrl/user/details'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      log('User details: ${jsonDecode(response.body)}', name: 'ApiService');
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user details: ${response.statusCode} ${response.body}');
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
        final expiryDate = DateTime.now().add(const Duration(hours: 2));
        await storage.write(key: 'token_expiry', value: expiryDate.toIso8601String());
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