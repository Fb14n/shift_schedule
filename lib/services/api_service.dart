import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String? baseUrl = dotenv.env['BASE_URL'];
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  static const String _keyJwt = 'jwt_token';
  static const String _keyRefresh = 'refresh_token';
  static const String _keyExpiry = 'token_expiry';

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

  Future<List<Map<String, dynamic>>> fetchShiftsStored() async {
    final token = await getToken();
    if (token == null) throw Exception('Kein Token gefunden');
    return fetchShifts(token);
  }

  Future<List<Map<String, dynamic>>> getShiftTypes() async {
    final token = await getToken();
    if (token == null) throw Exception('Kein Token gefunden');

    final response = await http.get(
      Uri.parse('$baseUrl/shift-types'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      log('Fehler beim Abrufen der Schichttypen: ${response.statusCode}', name: 'ApiService');
      throw Exception('Fehler beim Laden der Schichttypen');
    }
  }

  Future<Map<String, dynamic>> updateShiftTypeColor(int id, String newColor) async {
    final token = await getToken();
    if (token == null) throw Exception('Kein Token gefunden');

    if (!newColor.startsWith('#') || newColor.length != 7) {
      throw Exception('Ungültiges Farbformat. Benutze #RRGGBB.');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/shift-types/$id/color'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'color': newColor}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      log('Fehler beim Aktualisieren der Schichtfarbe: ${response.statusCode}', name: 'ApiService');
      throw Exception('Fehler beim Aktualisieren der Schichtfarbe');
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
      log('User details fetched', name: 'ApiService');
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user details: ${response.statusCode} ${response.body}');
    }
  }

  Future<String> login(String username, String password) async {
    log('API-Base-Url: ${dotenv.env['BASE_URL']}', name: 'ApiService');
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final access = data['access_token'] as String?;
      final refresh = data['refresh_token'] as String?;
      if (access != null) {
        await _saveTokenData(access, refreshToken: refresh, fallbackExpiryHours: 2);
        log('Login successful, token saved', name: 'ApiService');
        return access;
      } else {
        throw Exception('Login failed: Token not found in response');
      }
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception('Login failed: ${errorResponse['error'] ?? 'Unknown error'}');
    }
  }

  Future<String?> getToken() async {
    final token = await storage.read(key: _keyJwt);
    if (token == null) return null;

    final expiryIso = await storage.read(key: _keyExpiry);
    if (expiryIso != null) {
      final expiry = DateTime.tryParse(expiryIso);
      if (expiry != null && DateTime.now().isBefore(expiry)) {
        return token;
      }
    }

    final refreshed = await refreshToken();
    return refreshed;
  }

  Future<String?> refreshToken() async {
    final refresh = await storage.read(key: _keyRefresh);
    if (refresh == null) return null;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refresh}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccess = data['access_token'] as String?;
        final newRefresh = data['refresh_token'] as String?;
        if (newAccess != null) {
          await _saveTokenData(newAccess, refreshToken: newRefresh, fallbackExpiryHours: 2);
          log('Token refreshed successfully', name: 'ApiService');
          return newAccess;
        }
      } else {
        log('Refresh failed: ${response.statusCode}', name: 'ApiService');
      }
    } catch (e) {
      log('Refresh exception: $e', name: 'ApiService');
    }

    await logout();
    return null;
  }

  Future<void> _saveTokenData(String accessToken, {String? refreshToken, int? fallbackExpiryHours}) async {
    await storage.write(key: _keyJwt, value: accessToken);
    if (refreshToken != null) {
      await storage.write(key: _keyRefresh, value: refreshToken);
    }

    final expiry = _parseJwtExpiry(accessToken) ?? DateTime.now().add(Duration(hours: fallbackExpiryHours ?? 2));
    await storage.write(key: _keyExpiry, value: expiry.toIso8601String());
  }

  DateTime? _parseJwtExpiry(String jwt) {
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final map = jsonDecode(decoded) as Map<String, dynamic>;
      if (map.containsKey('exp')) {
        final exp = map['exp'];
        if (exp is int) {
          return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true).toLocal();
        } else if (exp is String) {
          final seconds = int.tryParse(exp);
          if (seconds != null) {
            return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true).toLocal();
          }
        }
      }
    } catch (_) {}
    return null;
  }

  Future<void> logout() async {
    try {
      await storage.delete(key: _keyJwt);
      await storage.delete(key: _keyRefresh);
      await storage.delete(key: _keyExpiry);
      log('Logout successful: credentials cleared', name: 'ApiService');
    } catch (e) {
      log('Logout failed: $e', name: 'ApiService');
      throw Exception('Logout failed: $e');
    }
  }

  Future<void> saveToken(String token) async {
    await _saveTokenData(token, fallbackExpiryHours: 2);
    log('Token saved', name: 'ApiService');
  }
  Future<String?> readRawToken() async {
    return await storage.read(key: _keyJwt);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: _keyJwt);
  }

  Future<void> resetPassword({
    required String username,
    required String employeeId,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'employeeId': employeeId,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Unbekannter Fehler beim Zurücksetzen des Passworts.');
    }
  }
}